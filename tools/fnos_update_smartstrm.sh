#!/bin/bash

# bash <(sudo wget -qO- https://github.com/Cp0204/SmartStrm/raw/refs/heads/main/tools/fnos_update_smartstrm.sh)
# 使用代理: 添加 --proxy 参数
# bash <(sudo wget -qO- https://github.com/Cp0204/SmartStrm/raw/refs/heads/main/tools/fnos_update_smartstrm.sh) --proxy

# 定义颜色
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# 代理设置
USE_PROXY=false
GITHUB_PROXY="https://wget.la/"

# 解析命令行参数
for arg in "$@"; do
    case $arg in
        --proxy)
            USE_PROXY=true
            shift
            ;;
        *)
            # 忽略未知参数
            ;;
    esac
done

# 根据参数决定是否使用代理
if [ "$USE_PROXY" = true ]; then
    echo -e "${YELLOW}启用代理: ${GITHUB_PROXY}${NC}"
else
    GITHUB_PROXY=""
    echo -e "${YELLOW}未启用代理，直接连接${NC}"
fi

# 默认版本变量
DEFAULT_VERSION=""
# 原始的 GitHub API 和 Release URL，将通过代理访问
GITHUB_API_URL_BASE="https://api.github.com/repos/Cp0204/SmartStrm/releases/latest"
GITHUB_DOWNLOAD_URL_BASE="https://github.com/Cp0204/SmartStrm/releases/download/"

# 定义 SmartStrm 相关信息
APP_NAME="smartstrm"
SMARTSTRM_INSTALL_PATH="" # 自动检测
TARGET_EXECUTABLE_NAME="SmartStrm" # 可执行文件名
TARGET_EXECUTABLE_PATH="" # 自动检测完整路径

echo -e "${YELLOW}--- SmartStrm 可执行文件更新脚本 ---${NC}"
echo ""

# --- 1. 检查 SmartStrm 安装状态和运行状态 ---
echo -e "${BLUE}>> 检查 SmartStrm 套件状态...${NC}"
APP_INFO=$(appcenter-cli list | grep -w "${APP_NAME}") # -w 确保精确匹配

if [ -z "$APP_INFO" ]; then
    echo -e "${RED}错误: 未检测到 SmartStrm (${APP_NAME}) 套件安装。请先安装。${NC}"
    exit 1
fi

# 修正字段索引
SMARTSTRM_CURRENT_VERSION=$(echo "$APP_INFO" | awk '{print $6}')
SMARTSTRM_STATUS=$(echo "$APP_INFO" | awk '{print $8}')

echo -e "${GREEN}SmartStrm 版本: ${SMARTSTRM_CURRENT_VERSION}${NC}"
echo -e "${GREEN}SmartStrm 状态: ${SMARTSTRM_STATUS}${NC}"

# 记录更新前的运行状态
WAS_RUNNING=false
if [ "$SMARTSTRM_STATUS" == "running" ]; then
    WAS_RUNNING=true
    echo -e "${YELLOW}SmartStrm 正在运行，将在更新前停止。${NC}"
fi

# --- 2. 自动检测 SmartStrm 安装路径 ---
echo -e "${BLUE}>> 自动检测 SmartStrm 安装路径...${NC}"
FOUND_PATH=false
for i in $(seq 1 10); do
    TEST_PATH="/vol${i}/@appcenter/${APP_NAME}/server"
    if [ -d "$TEST_PATH" ]; then
        SMARTSTRM_INSTALL_PATH="$TEST_PATH"
        TARGET_EXECUTABLE_PATH="${SMARTSTRM_INSTALL_PATH}/${TARGET_EXECUTABLE_NAME}"
        FOUND_PATH=true
        break
    fi
done

if [ "$FOUND_PATH" = false ]; then
    echo -e "${RED}错误: 无法找到 SmartStrm 的安装路径 (未在 /vol1 到 /vol10 中找到)。${NC}"
    exit 1
fi
echo -e "${GREEN}SmartStrm 安装路径: ${SMARTSTRM_INSTALL_PATH}${NC}"
echo -e "${GREEN}目标可执行文件: ${TARGET_EXECUTABLE_PATH}${NC}"
echo ""

# 临时目录
TEMP_DIR=$(mktemp -d)
if [ $? -ne 0 ]; then
    echo -e "${RED}错误: 无法创建临时目录。${NC}"
    exit 1
fi

# 确保在脚本退出时清理临时文件
function cleanup {
    echo -e "${YELLOW}>> 清理临时文件...${NC}"
    rm -rf "$TEMP_DIR"

    # 如果脚本因错误退出，尝试恢复 SmartStrm 服务
    if [ "$WAS_RUNNING" = true ] && [ $? -ne 0 ]; then
        echo -e "${RED}脚本异常退出，尝试恢复 SmartStrm 服务...${NC}"
        appcenter-cli start "${APP_NAME}" &>/dev/null # 静默启动
        if [ $? -eq 0 ]; then
            echo -e "${GREEN}SmartStrm 服务已尝试重启。${NC}"
        else
            echo -e "${RED}SmartStrm 服务重启失败，请手动检查。${NC}"
        fi
    fi
}
trap cleanup EXIT

# --- 3. 检测系统架构 ---
echo -e "${BLUE}>> 检测系统架构...${NC}"
ARCH=$(uname -m)
if [ "$ARCH" = "x86_64" ] || [ "$ARCH" = "x86" ]; then
    ARCH="x86"
    elif [ "$ARCH" = "aarch64" ] || [ "$ARCH" = "arm64" ]; then
    ARCH="arm"
else
    echo -e "${RED}错误: 不支持的架构 $ARCH。默认使用 x86。${NC}"
    ARCH="x86"
fi
echo -e "${GREEN}检测到架构: ${ARCH}${NC}"

# --- 4. 获取最新版本 ---
echo -e "${YELLOW}>> 获取最新版本...${NC}"
echo -e "${YELLOW}>> 使用代理：${GITHUB_PROXY}${NC}"
# 使用代理访问 GitHub API
LATEST_RELEASE_INFO=$(curl -s "${GITHUB_PROXY}${GITHUB_API_URL_BASE}")
LATEST_VERSION_TAG=$(echo "$LATEST_RELEASE_INFO" | grep -oP '"tag_name": "\Kv[^"]+')

if [ -z "$LATEST_VERSION_TAG" ]; then
    echo -e "${RED}错误: 无法获取最新版本号。请检查代理或网络。${NC}"
    echo -e "${YELLOW}调试信息: 尝试访问 ${GITHUB_PROXY}${GITHUB_API_URL_BASE}${NC}"
    exit 1
else
    DEFAULT_VERSION=$(echo "$LATEST_VERSION_TAG" | sed 's/^v//')
    echo -e "${GREEN}最新版本: ${DEFAULT_VERSION}${NC}"
fi

FULL_VERSION_TAG="v${DEFAULT_VERSION}"
# 使用新的 FPK 文件名格式 SmartStrm_{x.x.x}_{arch}.fpk
FPK_FILENAME="SmartStrm_${DEFAULT_VERSION}_${ARCH}.fpk"
# 构建代理下载 URL
DOWNLOAD_URL="${GITHUB_PROXY}${GITHUB_DOWNLOAD_URL_BASE}${FULL_VERSION_TAG}/${FPK_FILENAME}"

echo -e "${YELLOW}即将更新到版本: ${DEFAULT_VERSION}${NC}"
echo ""

# --- 5. 如果 SmartStrm 正在运行，则停止它 ---
if [ "$WAS_RUNNING" = true ]; then
    echo -e "${BLUE}>> 停止 SmartStrm 服务...${NC}"
    appcenter-cli stop "${APP_NAME}" &>/dev/null
    if [ $? -ne 0 ]; then
        echo -e "${RED}错误: 停止 SmartStrm 服务失败。请手动停止后再试。${NC}"
        exit 1
    fi
    echo -e "${GREEN}SmartStrm 服务已停止。${NC}"
    sleep 2 # 等待服务完全停止
fi

# --- 6. 下载 FPK 文件 ---
echo -e "${BLUE}>> 下载 ${FPK_FILENAME}...${NC}"
wget -q -O "${TEMP_DIR}/${FPK_FILENAME}" "$DOWNLOAD_URL"
if [ $? -ne 0 ]; then
    echo -e "${RED}错误: 下载 ${FPK_FILENAME} 失败。请检查版本、代理或网络。${NC}"
    exit 1
fi
echo -e "${GREEN}下载完成。${NC}"

# --- 7. 解压 FPK 并提取 SmartStrm 可执行文件 ---
echo -e "${BLUE}>> 解压文件并提取 SmartStrm 可执行文件...${NC}"
tar -xzf "${TEMP_DIR}/${FPK_FILENAME}" -C "$TEMP_DIR" app.tgz &>/dev/null
if [ $? -ne 0 ]; then
    echo -e "${RED}错误: 无法解压 ${FPK_FILENAME}。${NC}"
    exit 1
fi

tar -xzf "${TEMP_DIR}/app.tgz" -C "$TEMP_DIR" "server/${TARGET_EXECUTABLE_NAME}" &>/dev/null
if [ $? -ne 0 ]; then
    echo -e "${RED}错误: 无法从 app.tgz 提取 ${TARGET_EXECUTABLE_NAME}。${NC}"
    exit 1
fi

EXTRACTED_EXECUTABLE="${TEMP_DIR}/server/${TARGET_EXECUTABLE_NAME}"
if [ ! -f "$EXTRACTED_EXECUTABLE" ]; then
    echo -e "${RED}错误: 提取的 SmartStrm 可执行文件不存在。${NC}"
    exit 1
fi
echo -e "${GREEN}SmartStrm 可执行文件提取成功。${NC}"

# --- 8. 替换 SmartStrm 可执行文件 ---
echo -e "${BLUE}>> 替换 SmartStrm 可执行文件...${NC}"

if [ -f "$TARGET_EXECUTABLE_PATH" ]; then
    echo -e "${YELLOW}备份旧文件到 ${TARGET_EXECUTABLE_PATH}.bak...${NC}"
    mv "$TARGET_EXECUTABLE_PATH" "${TARGET_EXECUTABLE_PATH}.bak" &>/dev/null
    if [ $? -ne 0 ]; then
        echo -e "${RED}警告: 备份旧文件失败。${NC}"
    fi
fi

cp "$EXTRACTED_EXECUTABLE" "$TARGET_EXECUTABLE_PATH"
if [ $? -ne 0 ]; then
    echo -e "${RED}错误: 复制新的 SmartStrm 可执行文件失败。${NC}"
    exit 1
fi
echo -e "${GREEN}新文件已复制。${NC}"

# --- 9. 设置权限 ---
echo -e "${BLUE}>> 设置权限为 755...${NC}"
chmod 755 "$TARGET_EXECUTABLE_PATH"
if [ $? -ne 0 ]; then
    echo -e "${RED}错误: 设置权限失败。${NC}"
    exit 1
fi
echo -e "${GREEN}权限设置成功。${NC}"

# --- 10. 如果 SmartStrm 更新前是 running 状态，则重启它 ---
if [ "$WAS_RUNNING" = true ]; then
    echo -e "${BLUE}>> SmartStrm 更新完成，重启服务...${NC}"
    appcenter-cli start "${APP_NAME}" &>/dev/null
    if [ $? -ne 0 ]; then
        echo -e "${RED}错误: 重启 SmartStrm 服务失败。请手动检查并启动。${NC}"
    else
        echo -e "${GREEN}SmartStrm 服务已成功重启。${NC}"
    fi
else
    echo -e "${YELLOW}SmartStrm 在更新前未运行。您可手动启动。${NC}"
fi

echo ""
echo -e "${GREEN}--- SmartStrm 更新成功 (版本: ${DEFAULT_VERSION}) ---${NC}"