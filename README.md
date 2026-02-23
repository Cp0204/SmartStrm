<div align="center">

<img src="https://github.com/Cp0204/SmartStrm/raw/refs/heads/main/img/icon.svg" width="128" height="128">

# SmartStrm

一个媒体库 STRM 文件生成工具。

和 Emby 优雅配合，媒体资源丝滑入库，支持 302 直链播放，支持同步删除远端文件。

配合 Quark-Auto-Save/CloudSaver, OpenList, Emby 力求即存即看。🥳

[![releases][releases-image]][docker-url] [![docker-pulls][docker-pulls-image]][docker-url] [![docker-image-size][docker-image-size-image]][docker-url] [![pro][pro-image]][pro-url] [![telegram][telegram-image]][telegram-url]

[telegram-image]: https://img.shields.io/badge/Telegram-2CA5E0?logo=telegram&logoColor=white
[releases-image]: https://img.shields.io/github/tag/cp0204/smartstrm?label=releases
[docker-pulls-image]: https://img.shields.io/docker/pulls/cp0204/smartstrm?logo=docker&&logoColor=white
[docker-image-size-image]: https://img.shields.io/docker/image-size/cp0204/smartstrm?logo=docker&&logoColor=white
[github-url]: https://github.com/Cp0204/smartstrm
[docker-url]: https://hub.docker.com/r/cp0204/smartstrm
[telegram-url]: https://t.me/smartstrm
[pro-image]: https://img.shields.io/badge/SmartStrm-Pro-FFC107?logo=simkl&logoColor=white&labelColor=00A2E9
[pro-url]: https://licenserver.0x69.win/store/smartstrm

[快速部署](#部署) | [保姆教程](#第三方教程) | [进阶玩法](#进阶使用) | [常见答疑](#qa)

![main_page](https://github.com/Cp0204/SmartStrm/raw/refs/heads/main/img/main.png)

</div>

> [!TIP]
>
> 有不少新手提到希望有较详细的视频或图文教程，因为~~作者很懒~~ ~~想把有限的时间花在代码上~~ 写教程宁愿写代码。**即日起，各位大佬在公众号、B站、知乎、值得买等平台发布 SmartStrm 教程，图文视频均可，对其他用户有帮助的，根据内容质量可兑换1~2年Pro，已购可续**，内容可以但不限于在各NAS系统的部署方法、和 OpenList、QAS、CS 联动配置、Emby、Jellyfin 入库配置、302代理等。**注意，教程演示请勿使用国内版权资源。**
>
> **兑换方式：** 将内容链接、平台登录截图（证明账号所有权）邮件到 Cp0204(at)163.com<sup>[1]</sup>，这则公告还挂着就长期有效。参加并兑换成功默认视为授权 SmartStrm 对内容公开引用、保留原作者信息前提下的[整理和转载](#第三方教程)。
>
> * *[1] 邮件不回复任何一对一的使用咨询，如果你有此类问题，请加TG群交流*
>
> *如果教程涉及 Pro 功能，但你还没有，可以先邮件发内容规划（什么平台发什么内容），领取 5 天体验*

## 特性

- 支持 OpenList、WebDAV、夸克网盘、115网盘、天翼云盘、123云盘 等网络驱动
- 任务管理
  - 基于 Crontab 的定时任务
  - 单个任务独立日志
  - 任务工具箱：内容替换、一键清理
- STRM 生成
  - 目录时间检查
  - 增量/同步生成：可清理远端已删文件
  - 指定生成的媒体后缀、文件大小阈值
  - 指定复制的文件后缀
  - 本地存储实时监听生成
- Webhook
  - 联动 QAS、CloudSaver 转存即触发任务
  - 配合油猴脚本，网页转存即触发任务
  - Emby 中删除媒体，同步删除远端文件
  - CloudDrive2 文件变更通知实时触发任务 (Pro)
- 插件系统
  - STRM内容替换、非法文件名修正 等插件，支持任务级配置
  - 飞牛影视刷新 插件 (Pro)
- 粗糙但极其友好的管理页面
  - 存储浏览、批量重命名
  - 任务日志查看
- 一站式 Emby/Jellyfin/Plex/飞牛影视 302 直链播放 (Pro)

## 部署

部署命令

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

docker-compose.yml

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

一键更新

```bash
docker run --rm -v /var/run/docker.sock:/var/run/docker.sock containrrr/watchtower -cR smartstrm
```

### 环境变量

| 变量名              | 默认值     | 描述             |
| ------------------- | ---------- | ---------------- |
| `PORT`              | `8024`     | 管理端口         |
| `ADMIN_USERNAME`    | `admin`    | 管理用户名       |
| `ADMIN_PASSWORD`    | `admin123` | 管理用户密码     |
| `MAINLOG_MAX_DAYS`  | `7`        | 容器日志保存天数 |
| `TASKLOG_MAX_LINES` | `1000`     | 任务日志保存行数 |
| `ENABLE_IPV6`       | `true`     | 启用 IPv6 支持   |

## 版本区别

| 功能                      | 基础版 | Pro版 |
| ------------------------- | ------ | ----- |
| STRM 生成                 | ✅      | ✅     |
| 支持多种存储驱动          | ✅      | ✅     |
| Emby 删除同步             | ✅      | ✅     |
| 网页、QAS、CS转存触发任务 | ✅      | ✅     |
| 全局插件                  | ✅      | ✅     |
| 任务级插件                | ⏰      | ✅     |
| 飞牛影视刷新 插件         | 🔢      | ✅     |
| 302代理-直链播放          | ❌      | ✅     |
| CD2 WebHook               | ❌      | ✅     |
| 本地存储实时监听          | ❌      | ✅     |

> ✅支持  ❌不支持  ⏰限时免费  🔢 试用限制

## 使用

**原理：** [STRM 文件](https://emby.media/support/articles/Strm-Files.html) 是一个网络资源的快捷方式，它使得无须在本地存储媒体文件，让 Emby 播放时再直接从网络上请求媒体资源，因扫描媒体库只识别文件名，而不用读取媒体文件内容，所以入库极快。支持 STRM 文件的有 Emby, Jellyfin, Kodi 等。

### SmartStrm 的使用步骤

1. 添加存储
2. 添加任务，生成 STRM 文件
3. 挂载 STRM 目录给媒体库容器的 /strm 路径
4. 扫描媒体库，识别 STRM 文件

完成以上步骤，Emby 已经能够直接从网盘直接提供播放，此时所有视频流量经过 Emby ，如果你在局域网外访问，可能受限于家中网络的上传带宽（特别是多人同时播放时）。你可能还需要：

5. 设置302代理服务器（Pro），改从 SmartStrm 提供的端口访问 Emby ，将直接从网盘获取视频流（需网盘支持），享受最顺畅的播放。

### 第三方教程

- [视频教程：10分钟搞定！飞牛OS部署 SmartStrm+Emby 最强联动](https://www.bilibili.com/video/BV14shdzaEY7/)
- [视频教程：SmartStrm 302 原理，使用演示，在外秒播云盘资源](https://www.bilibili.com/video/BV1DKaGzUEP7/)
- [图文教程：SmartStrm + Emby：夸克网盘 302 直链播放完全指南](https://club.fnnas.com/forum.php?mod=viewthread&tid=36387)
- [图文教程：SmartStrm 部署，配置 Emby 媒体库，CloudSaver+QAS 联动，一站式302](https://linux.do/t/topic/924963)
- [图文教程：QAS+SmartStrm 部署、追更秒入库丝滑体验](https://zhuanlan.zhihu.com/p/1943376528730756600)
- [图文教程：SmartStrm +Emby +OpenList +Emby 联动删除直链播放，零成本NAS播放完全指南](https://post.smzdm.com/p/amon9plz/)
- [玩法教程：SmartStrm + Openlist + 绿联影视中心 避免网盘风控](https://club.ugnas.com/forum.php?mod=viewthread&tid=2037)
- [图文教程：飞牛影视配置STRM指南](https://www.wifilu.com/4683.html)

> [!TIP]
>
> 🥰 **感谢教程作者：** 噜啦噜啦萝卜、Jochen、SunnyD、太阳营业了、寒梅别有、韵茂茂阿、WIFI之路 作出的贡献！🥰
> *（排名不分先后）*

## 进阶使用

### 转存自动生成STRM

支持和 `quark-auto-save` `CloudSaver` 联动，在转存后触发任务。支持**仅触发转存的目标文件夹，秒级生成**。

#### quark-auto-save 插件

- **webhook**: SmartStrm Webhook 地址，从 `系统设置 - Webhook` 中获取
- **strmtask**: 相关的 SmartStrm 任务名，支持多个如 `tv,movie`
- **xlist_path_fix**: 可选，路径映射，SmartStrm 任务使用 夸克网盘 驱动时无须填写；使用 OpenList 驱动时需填写如 `/storage_mount_path:/quark_root_dir` 的格式 ，例如把夸克根目录(/)挂载在 OpenList 的 /quark 下，则填写 `/quark:/`。**SmartStrm 会使 OpenList 强制刷新目录，无需再用 alist 插件刷新。**

#### CloudSaver 扩展

支持夸克、天翼、115、123网盘，基本和 QAS 参数的逻辑相同，但需增加 `event` `savepath` 和调整 `xlist_path_fix` 参数。

- **webhook**: SmartStrm Webhook 地址，从 `系统设置 - Webhook` 中获取
- **strmtask**: 相关的 SmartStrm 任务名，支持多个如 `tv,movie`
- **event**: `cs_strm`
- **savepath**: `/{savePath}`
- **xlist_path_fix**: 可选，任务使用夸克网盘、115 开放平台、123云盘开放平台、天翼云盘驱动时无须填写；使用 OpenList 驱动时需填写，夸克、115、123网盘同QAS，天翼云盘 `/你挂载在oplist的路径:/全部文件` ，只改动 : 前面部分，后面 /全部文件 保持不变。
- **delay**: `0` 可选，延迟执行的秒数

<details>
<summary>天翼网盘配置示例图</summary>

![cs_189_set](https://github.com/Cp0204/SmartStrm/raw/refs/heads/main/img/cs_189_set.png)

</details>

<details>
<summary>夸克网盘配置示例图</summary>

![cs_quark_set](https://github.com/Cp0204/SmartStrm/raw/refs/heads/main/img/cs_quark_set.png)

</details>

### Emby 删除同步

> **前提: SmartStrm 的 STRM 目录需挂载到 Emby 容器的 `/strm` 路径**
>
> 例如 SmartStrm 容器目录映射为 `/yourpath/strm:/strm` ，Emby 容器同样映射为 `/yourpath/strm:/strm`
>
> 如果你无法改变 Emby 的 STRM 目录（例如群晖套件版）的解决办法：
>
> 手动修改 SmartStrm 的配置文件 config.yaml ，找到 `strm_in_emby:` ，修改为 SmartStrm 的 STRM 目录在 Emby 中录路径，重启 SS 就能按新的识别。

在 `SmartStrm - Webhook - Emby 删除同步设置` 中启用功能，默认关闭。

在 `Emby - 后台管理 - 通知` 中设置：

- **网址**： SmartStrm Webhook 地址
- **请求内容类型**: application/json
- **Events**: 勾选 `媒体库-媒体删除`

### Webhook 运行任务

除了常用的 QAS、CloudSaver 触发外，SmartStrm 还支持通过自定义 Webhook 运行任务，供开发者调用。

```bash
curl --request POST \
  --url http://127.0.0.1:8024/webhook/9dfb51234d483e83 \
  --header 'Content-Type: application/json' \
  --data '{
    "event": "a_task",
    "delay": 0,
    "task": {
        "name": "test",
        "storage_path": "/drive/quark/test"
    },
    "strm": {
        "media_ext": [
            "mp4",
            "mkv"
        ],
        "url_encode": true,
        "media_size": 100,
        "copy_ext": [
            "srt",
            "ass"
        ]
    }
}'
```

其中：

- `event` 是事件名，固定不变
- `delay` 可选，延迟执行的秒数
- `task.name` 必须为已存在的任务名，仅支持单个
- `task.storage_path` 可选，填写时必须为任务的路径或子路径
- `strm` 字典可选，如缺省则使用系统设置

### 网页转存自动触发任务

在网页转存资源成功时，向 SmartStrm 推送当前的网盘类型和保存路径，自动匹配并触发任务。

使用指引：

1. [安装 油猴/暴力猴/篡改猴 浏览器扩展](https://greasyfork.org/zh-CN/help/installing-user-scripts)
2. 安装脚本：[SmartStrm助手 - 转存触发任务](https://greasyfork.org/zh-CN/scripts/549634)
3. 打开任意分享页面，按提示填入 SmartStrm Webhook 地址
4. 如后续需要修改 Webhook 地址，可从油猴扩展菜单中呼出

### CloudDrive2 文件变更通知触发任务

在 `SmartStrm - Webhook - CloudDrive2 文件变更触发设置` 中启用功能，默认关闭。

并设置 **存储映射** ，有两种联动方式：

1. 两边各添加同一网盘的同一账号（推荐）：目前支持 115、天翼云盘，填写格式为 `A=A1,B=B1,C=C1` 表示把 CD2 的 A 存储映射到 SS 的 A1 存储。

2. 利用 CD2 的 WebDAV 功能，把 CD2 添加为 WebDAV 存储，该方式所有文件请求流量经过CD2。
   1. 如添加 CD2 名为 `115open` 的存储到 SS 的 `115openA` ，WebDAV 地址 `http://yoururl:19798/dav/115open` ，映射填写格式同上如 `115open=115openA`。
   2. 也可以加整个 CD2 根目录，假如在 SS 名为 `CD2_DAV` 存储，填写格式为 `/=CD2_DAV`；但有以上指定存储映射时优先用指定的映射。

> [!TIP]
>
> **使用实例：** 使用115网盘，在CD2的名称是 `115` ，在 SS 的名称是 `open115_Cp0204`
>
> 在 SS 中填写存储映射 `115=open115_Cp0204` ，同时创建路径为 `/影视库/电影`、`/影视库/剧集` 的任务
>
> 当 CD2 中检测到 `/115/影视库/电影/xxx` 变更时，SS 会根据变更的文件路径，自动找到要触发的任务。

<details>
<summary>CloudDrive2 Webhook 配置</summary>

```ini
[global_params]
# 此处 base_url修改为你的 SmartStrm Webhook 地址，其他保持不变
base_url = "http://192.168.8.8:8024/webhook/9df1236ad884a83"
enabled = true

[global_params.default_headers]
content-type = "application/json"
user-agent = "clouddrive2/{version}"

[file_system_watcher]
url = "{base_url}/file_notify?device_name={device_name}&user_name={user_name}"
method = "POST"
enabled = true
body = '''
{
    "device_name": "{device_name}",
    "user_name": "{user_name}",
    "version": "{version}",
    "event_category": "{event_category}",
    "event_name": "{event_name}",
    "event_time": "{event_time}",
    "send_time": "{send_time}",
    "data": [
        {
            "action": "{action}",
            "is_dir": "{is_dir}",
            "source_file": "{source_file}",
            "destination_file": "{destination_file}"
        }
    ]
}
'''
```

</details>

## 302 代理

> 使用 SmartStrm 内置的 302 代理功能，将 Emby 客户端播放请求重定向，直接从直链获取视频流，不受 Emby 服务器的带宽限制。
>
> 测试支持绝大多数提供 http 直链的网盘，如使用 115VIP、天翼云盘、OpenList-支持302的盘 等方案较为完美。
>
> 图标示意: ✅兼容 ❌不兼容 🟡部分兼容 ⚫未测试

### 按驱动分

| 驱动        | Emby | Jellyfin | Plex | 备注                                                  |
| ----------- | ---- | -------- | ---- | ----------------------------------------------------- |
| OpenList    | ✅    | ✅        | ⚫    | 如果 oplist 开启302，直链兼容性依赖于网盘能否提供直链 |
| 夸克网盘    | 🟡    | 🟡        | ✅    | 默认使用转码直链，部分视频不兼容，可用智能回落到代理  |
| 115开放平台 | ✅    | ✅        | ⚫    | 直链完美兼容；但普通用户API限速，频繁报错             |
| 天翼云盘    | ✅    | ✅        | ✅    | 直链完美兼容，速度完美                                |
| 123开放平台 | ✅    | ✅        | ✅    | 直链完美兼容，速度完美                                |

### 按客户端分

| 客户端     | Emby | Jellyfin | Plex | 备注                             |
| ---------- | ---- | -------- | ---- | -------------------------------- |
| Web        | 🟡    | 🟡        | 🟡    | 不兼容夸克部分转码资源，其他正常 |
| Android    | ✅    | ⚫        | 🟡    |                                  |
| Android TV | 🟡    | -        | ⚫    | 不兼容夸克部分转码资源，其他正常 |
| VidHub     | ✅    | ✅        | ✅    |                                  |
| Yamby      | 🟡    | -        | -    | 不兼容夸克部分转码资源，其他正常 |
| AfuseKt    | ✅    | ✅        |      |                                  |
| 网易爆米花 | ✅    | ✅        |      |                                  |

由于第三方播放器众多，未能一一测试。如果你重度依赖 302 功能，订阅长期 Pro 前请订阅 1 天试用，以测试其兼容性。

### Plex 302 说明

Plex 是账号服务+自部署服务，和 Emby/Jellyfin 独立的自部署有区别，你需要提前知道的：

1. 第三方客户端 VidHub、Infuse 连接 Plex 本身就支持 STRM 播放，无须另外的 302 代理。
2. 本项目对自部署的 Web 服务代理后，可以实现 Web 端 302 播放；将代理后的地址加 HTTPS 设置为 `设置 - 网络 - 自定义服务器访问 URL` 后，支持 Plex 客户端 302 播放。
3. 在 app.plex.tv 中无法实现 STRM 播放，因为即使修改了后端返回，无法修改官方前端的代码。
4. 受限于客户端解码能力，部分非流媒体的视频格式不能播放，这是无法解决的。

Plex 自身有穿透机制，需要调整远程设置才能将代理端口提供于各客户端访问。具体设置方法请参考同类项目帮助：

- [plex-服务端控制台设置](https://github.com/bpking1/embyExternalUrl/blob/main/plex2Alist/README.zh-Hans.md#5-plex-服务端控制台设置)
- [plex2alist魔改版本](https://github.com/diannaSIN/plex2alist-)

## 关联项目

- [Quark-Auto-Save](https://github.com/Cp0204/quark-auto-save)

  夸克网盘签到、自动转存、命名整理、发推送提醒和刷新媒体库一条龙。

- [CloudSaver](https://github.com/jiangrui1994/cloudsaver)

  一个基于 Vue 3 + Express 的网盘资源搜索与转存工具。

- [Emby](https://emby.media/download.html)

  一款强大的家庭媒体库管理和串流软件，可以帮助您整理和播放存储在服务器上的电影、音乐、照片等媒体内容。

- [Jellyfin](https://jellyfin.org/downloads/docker)

  一个开源的媒体库管理软件，支持多种媒体格式，可以跨平台使用。

## Q&A

#### Q: 是否支持网盘资源转存、自动转存？
> A: 暂无计划，做好一件事，少即是多。网络上已经有不少转存工具，不重复造轮子，除非我有信心做成最好用的轮子。

#### Q: 免费和收费？
> A: 基础功能免费（STRM生成，Webhook等），已经能够满足绝大多数人需求，高级功能付费（302代理），定价极其合理。作者的免费开源项目 QAS 至今已迭代多个版本， SmartStrm 是打通网络存储和私有媒体库的最后一块拼图，从高级功能中获取一定的回报，更有利于项目的长远发展。
>
> 功能定位：
> - 免费功能：基础的功能、细节优化、大众的需求。
> - 高级功能：进阶的功能、小众的需求。尤其是一个功能我自己用不上，是为了满足用户们需求而开发，那将会是Pro功能。

#### Q: 未配置许可信息可以使用吗？
> A: 可以正常使用，没配置许可证不影响基础功能的使用，基础功能不逊色于同类项目。
>
> 如果你的容器不能启动、或管理后台打不开，则可能是端口没配置等其它问题导致。

#### Q: 如何订阅和激活 Pro？
> 目前依托爱发电平台自助订阅：
> 1. [订阅入口](https://licenserver.0x69.win/store/smartstrm)；
> 2. 在 SmartStrm 后台的左下角，点 “免费版” 可以跳转，已经是 Pro 的，点击时间可以跳转到续订，容器重启后生效。
>
> 订阅成功后，密钥邮件自动发送，将密钥在 `系统设置-关于` 中验证即可，谢谢支持！
>
> 如果没有收到邮件，先检查有没有被拦截，确认没有收到可在爱发电给作者留言。

#### Q: 302代理之后可以分享给家人和朋友用吗 这样会风控吗？
> A: 302代理后直接由客户端直接向网盘请求资源，表现为你的网盘账号在异地下载。假设你家里登录了、公司在异地也登录了，少量属于正常的使用需求。但如果公开出去同时十几、几十处异地下载，账号将有可能被风控，请自行承担风险。

#### Q: 映射了 302 代理端口访问 Emby ，还要不要映射 SmartStrm 端口？
> A: 不需要，如果用 SS 的 302 代理功能，分享代理后的 Emby 端口出去，STRM 地址可以直接用内网，代理会自行处理。别人访问不到 SmsrtStrm 或 STRM 的地址，能访问的只有代理后的 Emby 服务，所以我称之为 “一站式 Emby Jellyfin 302 直链播放” 。

#### Q: 能否支持 Jellyfin 的删除 Webhook 通知？
> A: Jellyfin 的通知中缺少一些关键信息，导致 SS 无法得知要删除的路径，所以没办法支持。

#### Q: 夸克播放部分视频偏色？
> A: 这是个已知问题。目前的结论是偏色是夸克转码和播放客户端的问题，把杜比视界视频当流媒体处理时，播放器不支持杜比视界造成的。（当302时，直接由客户端解码杜比视界原文件，理论上只要是302和客户播放器不支持杜比视界都会偏色，和用哪个网盘无关）如果到夸克客户端、夸克TV播这个资源验证一下，也会是一样的偏色。目前已知同一个资源，调用 PotPlayer 播放不会偏色，如果客户端不支持只能换资源。

#### Q: Emby 提示没有兼容的流如何排查？
> 1. 找到对应的 .strm 文件，用文本编辑器打开，里面有个 URL ，复制到浏览器看能否访问。
> 2. 检查 Emby 容器和以上 URL 的连接，如果是局域网，是否在同一个网段。
> 3. 检查 URL 中的媒体格式，部分媒体格式可能无法被网页端解码，尝试用客户端播放。

#### Q: 新存入文件不生成？
> 尝试关闭任务设置的 `目录时间检查` 选项，这个选项本意是为了减少历遍请求，快速生成。但在某些盘中增修 /aa/bb/cc/ 下的文件，只有目录cc的修改时间会更新，aa和bb的修改时间不变，所以不会往下索引。

#### Q: 关于目录时间检查选项的工作机制？
> A: 这个选项是为了最小化地请求接口，和最快的速度执行任务。远端目录的修改时间更新了、比本地新，就会往下检查。已知115新增/删除文件都会更新父目录的修改时间；夸克网盘新增会更新但删除不会；各个盘可能机制不一，建议自行验证。

#### Q: 如何为 PikPak WebDAV 设置代理？
> 为容器添加环境变量如：
> ```bash
> HTTP_PROXY=http://172.17.0.1:10808
> HTTPS_PROXY=http://172.17.0.1:10808
> ```
> 把 172.17.0.1:10808 替换为你的 http 代理，并且应为黑白名单，而非全局代理。

#### Q: 关于起播速度？
> A: 有三方面的因素：
>
> 1. 和本地媒体不同，STRM 相当于一个快捷方式。入库时 Emby 不会预读媒体文件规格（4K, HDR, 编码, 大小等），在首次播放时，才从网络请求文件读取文件规格。
> 2. 播放 STRM 时，SmartStrm 需要从网盘请求直链再做 302 跳转，内部会有若干个网络请求的时间；在 v0.3.0+ 生成 STRM 使用 `文件编号模式` 可减少至一个网络请求，稍微提高起播速度。
> 3. 获取到直链后，客户端需要对视频文件缓冲；这个时间和你的网络、服务器有关，部分网盘还可能会有限速。
>
> 入库快，免下载、在线播放，但起播速度会变慢。这是 STRM 的优点，也是不可避免有弊端。使用下来通常在10秒内起播，个人认为可以接受，无须盲目追求起播速度。

## 开放源代码许可

SmartStrm 是一个闭源项目，但站在巨人的肩膀上使用了多个开源库。我们尊重并遵守所有第三方开放源代码的许可要求。

本项目使用的开放源代码及其许可证信息：[《开放源代码许可》](https://github.com/Cp0204/SmartStrm/raw/refs/heads/main/OPEN-SOURCE-SOFTWARE-NOTICE.md)

## 最后

感谢你看到这里，感谢你了解这个项目。

这个项目最开始源自于 夸克自动转存(QAS) 的一次 [PR 讨论](https://github.com/Cp0204/quark-auto-save/pull/65#issuecomment-2779488163)，以及用过同类 STRM 后，自己用着处处不顺手（需求精准生成、速度快、方便调用）。

所以立项之初就决定了要和 QAS 能联动，后来也和 CloudSaver 作者一拍即合，基本做到这俩工具转存后就能生成 STRM、Emby 入库一条龙，这里有一个[演示视频](https://www.bilibili.com/video/BV1wtaAzCEBv/)。

用 STRM 的方式播 115、天翼、夸克的资源，和 QAS、CS 联动转存即触发生成，个人认为一点已经可以优于同类工具了。

不仅于此，SmartStrm 未直接支持的网盘，同样可以用 OpenList 来转接。

作为一个工具类软件，我希望它足够精巧优雅，就像一块积木，和其他积木一起拼在一起，在你的 NAS 中组合成你自己的观影自动化方案。

希望你能喜欢。
