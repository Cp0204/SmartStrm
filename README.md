<a name="readme-top"></a>
<div align="center">

<img src="https://github.com/Cp0204/SmartStrm/raw/refs/heads/main/img/icon.svg" width="128" height="128">

# SmartStrm

一个媒体库 STRM 文件生成工具。

和 Emby 优雅配合，媒体资源丝滑入库，支持 302 直链播放，支持同步删除远端文件。

配合 Quark-Auto-Save/CloudSaver, OpenList, Emby 力求即存即看。🥳

[**项目文档**](https://smartstrm.github.io) · [快速部署](https://smartstrm.github.io/guide/deploy) · [保姆教程](https://smartstrm.github.io/help/tutorials) · [进阶玩法](https://smartstrm.github.io/settings/webhook) · [常见问题](https://smartstrm.github.io/help/faq) · [更新日志](https://smartstrm.github.io/changelog)

[![releases][releases-image]][docker-url] [![docker-pulls][docker-pulls-image]][docker-url] [![docker-image-size][docker-image-size-image]][docker-url] [![pro][pro-image]][pro-url] [![telegram][telegram-image]][telegram-url]

<!-- LINK GROUP -->
[releases-image]: https://img.shields.io/github/tag/cp0204/smartstrm?label=releases&style=flat-square
[docker-pulls-image]: https://img.shields.io/docker/pulls/cp0204/smartstrm?logo=docker&&logoColor=white&style=flat-square
[docker-image-size-image]: https://img.shields.io/docker/image-size/cp0204/smartstrm?logo=docker&&logoColor=white&style=flat-square
[github-url]: https://github.com/Cp0204/smartstrm
[docker-url]: https://hub.docker.com/r/cp0204/smartstrm
[telegram-image]: https://img.shields.io/badge/Telegram-2CA5E0?logo=telegram&logoColor=white&style=flat-square
[telegram-url]: https://t.me/smartstrm
[pro-image]: https://img.shields.io/badge/SmartStrm-Pro-FFC107?logo=simkl&logoColor=white&labelColor=00A2E9&style=flat-square
[pro-url]: https://licenserver.0x69.win/store/smartstrm
[back-to-top]: https://img.shields.io/badge/-BACK_TO_TOP-151515?style=flat-square

![main_page](https://github.com/Cp0204/SmartStrm/raw/refs/heads/main/img/main.png)

</div>

<details>
<summary><kbd>快速导航</kbd></summary>

- [SmartStrm](#smartstrm)
  - [✨ 核心特性](#-核心特性)
    - [📦 多驱动支持](#-多驱动支持)
    - [⏰ 自动化任务](#-自动化任务)
    - [🔗 联动触发](#-联动触发)
    - [🚀 302 直链播放](#-302-直链播放)
    - [🛠️ 插件系统](#️-插件系统)
    - [🧠 智能识别](#-智能识别)
  - [📖 使用指南](#-使用指南)
    - [什么是 STRM？](#什么是-strm)
    - [简单五步，开始使用](#简单五步开始使用)
  - [🚀 快速开始](#-快速开始)
  - [🤝 社区与支持](#-社区与支持)
  - [📜 许可说明](#-许可说明)

</details>

## ✨ 核心特性

打造主流云端存储通往私有媒体库的“最后一公里”，实现云端资源无感入库、丝滑秒开。

### 📦 多驱动支持
支持 **OpenList、WebDAV、夸克、115、天翼、123 云盘** 等主流网络存储驱动。轻松聚合碎片化的媒体资源，统一管理。

### ⏰ 自动化任务
基于 **Crontab** 的定时计划系统，支持 **增量生成**、**同步删除** 及 **本地存储实时监听**。让你的媒体库永远保持最新状态。

### 🔗 联动触发
深度配合 **QAS** (Quark-Auto-Save)、**CloudSaver** 等转存工具，实现“转存即触发”。同时支持 **Emby 联动删除**，保持文件与库的一致性。

### 🚀 302 直链播放
一站式 **Emby / Jellyfin / Plex / 飞牛影视** 302 重定向技术。视频流直连请求网盘，不占用 NAS 带宽，拒绝播放转圈。

### 🛠️ 插件系统
提供丰富插件扩展，包括 **文件名修复**、**内容正则替换**、**通知飞牛刷新**、**提取视频封面** 等能力，满足各种复杂的自动化场景。

### 🧠 智能识别
内置文件浏览器，支持 **TMDB 智能识别** 与批量重命名，让你的 STRM 文件结构标准、刮削精准。

<div align="right">

[![][back-to-top]](#readme-top)

</div>

## 📖 使用指南

### 什么是 STRM？
[STRM 文件](https://emby.media/support/articles/Strm-Files.html) 本质上是一个网络资源的快捷方式，它使得无须在本地存储媒体文件，让媒体服务器播放时再直接从网络上请求媒体资源。

- **入库极快**：扫描媒体库时仅需识别 KB 级别的文本文件，无需读取海量媒体数据。
- **兼容性强**：支持 Emby, Jellyfin, Plex, Kodi, 飞牛影视等主流媒体服务器。

### 简单五步，开始使用

1. **添加存储**：连接您的夸克、115、WebDAV 等网盘。
2. **创建任务**：配置扫描路径，一键生成 `.strm` 文件。
3. **目录映射**：将生成的 `strm` 目录挂载给 Emby 等媒体服务器容器。
4. **扫描入库**：在 Emby 中添加并扫描该目录，海量资源瞬间入库。
5. **302 代理 (Pro)**：配置 302 代理，视频流从网盘直达播放器，不占 NAS 带宽，极致秒开。

<div align="right">

[![][back-to-top]](#readme-top)

</div>

## 🚀 快速开始

使用 Docker 一键部署 SmartStrm：

```bash
docker run -d \
  --name smartstrm \
  --restart unless-stopped \
  --network host \
  -v /yourpath/smartstrm/config:/app/config \  # 挂载配置目录
  -v /yourpath/smartstrm/logs:/app/logs \  # 挂载日志目录，可选
  -v /yourpath/smartstrm/strm:/strm \  # 挂载 STRM 生成目录
  # 以上 /yourpath 改为你实际存放配置的路径
  -e PORT=8024 \  # 管理端口，可选
  -e ADMIN_USERNAME=admin \  # 管理用户名
  -e ADMIN_PASSWORD=admin123 \  # 管理用户密码
  cp0204/smartstrm:latest
```

使用 **docker-compose.yml** 部署（推荐）：

```yaml
name: smartstrm
services:
  smartstrm:
    image: cp0204/smartstrm:latest
    container_name: smartstrm
    restart: unless-stopped
    network_mode: host
    volumes:
      - /yourpath/smartstrm/config:/app/config # 挂载配置目录
      - /yourpath/smartstrm/logs:/app/logs # 挂载日志目录，可选
      - /yourpath/smartstrm/strm:/strm # 挂载 STRM 生成目录
      # 以上 /yourpath 改为你实际存放配置的路径
    environment:
      - PORT=8024 # 管理端口，可选
      - ADMIN_USERNAME=admin # 管理用户名
      - ADMIN_PASSWORD=admin123 # 管理用户密码
```

> [!TIP]
>
> 部署完成后，访问 `http://yourip:8024` 进入管理后台。
>
> 更多环境变量和部署技巧参考 [完整部署文档](https://smartstrm.github.io/guide/deploy)。

<div align="right">

[![][back-to-top]](#readme-top)

</div>

## 🤝 社区与支持

如果您在使用过程中遇到任何问题，欢迎通过以下渠道交流：

- 使用交流：[**Telegram Group**](https://t.me/smartstrm)
- 问题反馈：[**GitHub Issues**](https://github.com/Cp0204/SmartStrm/issues)

<details>
<summary><kbd>参与创作教程兑换 Pro</kbd></summary>

> 👑
>
> 有不少新手提到希望有较详细的视频或图文教程，因为~~作者很懒~~不爱写教程、宁愿写代码。**即日起，各位大佬在公众号、B站、知乎、值得买等平台发布 SmartStrm 教程，图文视频均可，对其他用户有帮助的，根据内容质量可兑换1~2年Pro，已购可续**，内容可以但不限于在各NAS系统的部署方法、和 OpenList、QAS、CS 联动配置、Emby、Jellyfin 入库配置、302代理等。**注意，教程演示请勿使用国内版权资源。**
>
> **兑换方式：** 将内容链接、平台登录截图（证明账号所有权）邮件到 Cp0204(at)163.com<sup>[1]</sup>，这则公告还挂着就长期有效。参加并兑换成功默认视为授权 SmartStrm 对内容公开引用、保留原作者信息前提下的[整理和转载](https://smartstrm.github.io/help/tutorials)。
>
> * *[1] 邮件不回复任何一对一的使用咨询，如果你有此类问题，请加TG群交流*

</details>

<div align="right">

[![][back-to-top]](#readme-top)

</div>


## 📜 许可说明

SmartStrm（以下简称“本应用”）是一个闭源项目，但站在巨人的肩膀上使用了多个开源库。我们尊重并遵守其 [《开放源代码许可》](https://github.com/Cp0204/SmartStrm/raw/refs/heads/main/OPEN-SOURCE-SOFTWARE-NOTICE.md) 要求。

1. **项目性质与目的**：本应用旨在通过程序自动化提高网络服务的使用效率，没有对第三方的破解行为，只是对于已有的 API 进行封装和调用。若需达到最佳使用体验，用户仍需开通相关平台的付费服务。

2. **数据来源与责任限制**：本应用所处理的数据均直接或间接来源于第三方，开发者不对网盘中用户上传、存储的任何内容的合法性、准确性、完整性、安全性以及任何潜在的侵权行为负责，用户应自行评估并承担由此产生的一切风险。

3. **非商业用途与严禁非法用途**：本应用仅供个人学习、研究与交流使用，开发者禁止用户将本应用用于任何商业行为与非法用途。用户若将本应用用于非法用途，应独立承担所有法律责任，开发者不承担任何连带责任。

通过继续使用本应用，您即被视为已完全理解并接受上述所有条款和条件。

版权所有 © 2025-至今 Cp0204

<div align="right">

[![][back-to-top]](#readme-top)

</div>