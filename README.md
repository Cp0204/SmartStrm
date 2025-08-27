<div align="center">

<img src="https://github.com/Cp0204/SmartStrm/raw/refs/heads/main/img/icon.svg" width="128" height="128">

# SmartStrm

一个媒体库 STRM 文件生成工具。

和 Emby 优雅配合，媒体资源丝滑入库，支持 302 直链播放，支持同步删除远端文件。

配合 Quark-Auto-Save/CloudSaver, OpenList, Emby 力求即存即看。🥳

[![releases][releases-image]][docker-url] [![docker pulls][docker-pulls-image]][docker-url] [![docker image size][docker-image-size-image]][docker-url] [![telegram][telegram-image]][telegram-url]

[telegram-image]: https://img.shields.io/badge/Telegram-2CA5E0?logo=telegram&logoColor=white
[releases-image]: https://img.shields.io/docker/v/cp0204/smartstrm
[docker-pulls-image]: https://img.shields.io/docker/pulls/cp0204/smartstrm?logo=docker&&logoColor=white
[docker-image-size-image]: https://img.shields.io/docker/image-size/cp0204/smartstrm?logo=docker&&logoColor=white
[github-url]: https://github.com/Cp0204/smartstrm
[docker-url]: https://hub.docker.com/r/cp0204/smartstrm
[telegram-url]: https://t.me/smartstrm

![run_log](https://github.com/Cp0204/SmartStrm/raw/refs/heads/main/img/main.png)

</div>

> [!TIP]
>
> 有不少新手提到希望有较详细的视频或图文教程，因为~~作者很懒~~ 想把有限的时间花在代码上。**即日起，各位大佬在公众号、B站、知乎、值得买等平台发布 SmartStrm 教程，图文视频均可，对其他用户有帮助的，根据内容质量可兑换1~2年Pro，已购可续**，内容可以但不限于在各NAS系统的部署方法、和 OpenList、QAS、CS 联动配置、Emby、Jellyfin 入库配置、302代理等。**注意，教程演示请勿使用国内版权资源。**
>
> **兑换方式：** 将内容链接、平台登录截图（证明账号所有权）邮件到 Cp0204#qq.com (#替换@），这则公告还挂着就长期有效。参加并兑换成功默认视为授权 SmartStrm 对内容公开引用、保留原作者信息前提下的整理和转载。
>
> *如果教程涉及 Pro 功能，但你还没有，可以先邮件发内容规划（什么平台发什么内容），领取 5 天体验*

## 特性

- 支持 OpenList、WebDAV、Quark、115、天翼云盘 等网络驱动
- 任务管理
  - 基于 Crontab 的定时任务
  - 单个任务独立日志
  - 任务工具箱：内容替换、一键清理
- STRM 生成
  - 目录时间检查
  - 增量/同步生成：可清理远端已删文件
  - 指定生成的媒体后缀、文件大小阈值
  - 指定复制的文件后缀
- Webhook
  - 联动 QAS、CloudSaver 转存即触发任务
  - Emby 中删除媒体，同步删除远端文件
  - CloudDrive2 文件变更通知实时触发任务 (Pro)
- 粗糙但极其友好的管理页面
  - 存储浏览、批量重命名
  - 任务日志查看
- 一站式 Emby Jellyfin 302 直链播放 (Pro)

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
  -e LICENSE= \  # 许可证字符串（如有）
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
      - LICENSE= # 许可证字符串（如有）
```

一键更新

```bash
docker run --rm -v /var/run/docker.sock:/var/run/docker.sock containrrr/watchtower -cR smartstrm
```

## 使用

**原理：** [STRM 文件](https://emby.media/support/articles/Strm-Files.html) 是一个网络资源的快捷方式，它使得无须在本地存储媒体文件，让 Emby 播放时再直接从网络上请求媒体资源，因扫描媒体库只识别文件名，而不用读取媒体文件内容，所以入库极快。支持 STRM 文件的有 Emby, Jellyfin, Kodi 等。

### SmartStrm 的使用步骤：

1. 添加存储
2. 添加任务，生成 STRM 文件
3. 挂载 STRM 目录给媒体库容器的 /strm 路径
4. 扫描媒体库，识别 STRM 文件

完成以上步骤，Emby 已经能够直接从网盘直接提供播放，此时所有视频流量经过 Emby ，如果你在局域网外访问，可能受限于家中网络的上传带宽（特别是多人同时播放时）。你可能还需要：

5. 设置302代理服务器（Pro），改从 SmartStrm 提供的端口访问 Emby ，将直接从网盘获取视频流（需网盘支持），享受最顺畅的播放。

## 进阶使用

### 转存自动生成STRM

支持和 `quark-auto-save` `CloudSaver` 联动，在转存后触发任务。支持**仅触发转存的那一个文件夹，秒级生成**。

#### quark-auto-save 插件

- **webhook**: SmartStrm Webhook 地址，从 `系统设置 - Webhook` 中获取
- **strmtask**: 相关的 SmartStrm 任务名，支持多个如 `tv,movie`
- **xlist_path_fix**: 路径映射， SmartStrm 任务使用 夸克网盘 驱动时无须填写；使用 OpenList 驱动时需填写如 `/storage_mount_path:/quark_root_dir` 的格式 ，例如把夸克根目录(/)挂载在 OpenList 的 /quark 下，则填写 `/quark:/`。**SmartStrm 会使 OpenList 强制刷新目录，无需再用 alist 插件刷新。**

#### CloudSaver 扩展

基本和 QAS 参数的逻辑相同，但需增加 `event` `savepath` 和调整 `xlist_path_fix` 参数。

- **webhook**: 同QAS
- **strmtask**: 同QAS
- **event**: `cs_strm`
- **savepath**: `/{savePath}`
- **xlist_path_fix**: 任务使用夸克网盘、天翼云盘驱动时无须填写；使用 OpenList 驱动时需填写，夸克网盘同QAS，天翼云盘 `/你挂载在oplist的路径:/全部文件` ，只改动 : 前面部分，后面 /全部文件 保持不变。

<details>
<summary>天翼网盘配置示例图</summary>

![cs_189_set](https://github.com/Cp0204/SmartStrm/raw/refs/heads/main/img/cs_189_set.png)

</details>

<details>
<summary>夸克网盘配置示例图</summary>

![cs_quark_set](https://github.com/Cp0204/SmartStrm/raw/refs/heads/main/img/cs_quark_set.png)

</details>


### Emby 删除同步

> **前提：需把 STRM 目录挂载到 Emby 容器的 /strm 路径下**
>
> 如果你无法改变 Emby 的 STRM 目录（例如群晖套件版）的解决办法：
>
> 手动修改 SmartStrm 的配置文件 config.yaml ，找到 `strm_in_emby:` ，根据你 Emby 中的路径来改，重启 SS 就能按新的识别。

在 `SmartStrm - Webhook - Emby 删除同步设置` 中启用功能，默认关闭。

在 `Emby - 后台管理 - 通知` 中设置：

- **网址**： SmartStrm Webhook 地址
- **请求内容类型**: application/json
- **Events**: 勾选 `媒体库-媒体删除`



### Webhook 运行任务

```bash
curl --request POST \
  --url http://127.0.0.1:8024/webhook/9dfb51234d483e83 \
  --header 'Content-Type: application/json' \
  --data '{
    "event": "a_task",
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
- `task.name` 必须为已存在的任务名，仅支持单个
- `task.storage_path` 可选，填写时必须为任务的路径或子路径
- `strm` 字典可选，如缺省则使用系统设置

### CloudDrive2 文件变更通知触发任务

在 `SmartStrm - Webhook - CloudDrive2 文件变更触发设置` 中启用功能，默认关闭。

并设置 **存储映射** ，有两种联动方式：

1. 两边各添加同一网盘的同一账号（推荐）：目前支持 115、天翼云盘，填写格式为 `A=A1,B=B1,C=C1,CD2_NAME=SS_NAME` 表示把 CD2 的 A 存储映射到 SS 的 A1 存储。

2. 利用 CD2 的 WebDAV 功能，把 CD2 添加为 WebDAV 存储，该方式所有文件请求流量经过CD2。
   1. 如添加 CD2 名为 `115open` 的存储到 SS 的 `115openA` ，WebDAV 地址 `http://yoururl:19798/dav/115open` ，映射填写格式同上如 `115open=115openA`。
   2. 也可以加整个 CD2 根目录，假如在 SS 名为 `CD2_DAV` 存储，填写格式为 `/=CD2_DAV`；但有以上指定存储映射时优先用指定的映射。


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

> 使用 SmartStrm 提供的 302 代理，将 Emby 客户端播放请求重定向，直接从直链获取视频流，不受 Emby 服务器的带宽限制。
>
> 测试支持绝大多数提供 http 直链的网盘，如使用 115VIP、天翼云盘、OpenList-支持302的盘 等方案较为完美。
>
> 图标示意: ✅兼容 ❌不兼容 🟡部分兼容 ⚫未测试

### 按驱动分

| 驱动        | Emby 302 | Jellyfin 302 | 备注                                                  |
| ----------- | -------- | ------------ | ----------------------------------------------------- |
| OpenList    | ✅        | ✅            | 如果 oplist 开启302，直链兼容性依赖于网盘能否提供直链 |
| 夸克网盘    | 🟡        | 🟡            | 默认使用转码直链，部分视频不兼容，可用智能回落到代理  |
| 115开放平台 | ✅        | ✅            | 直链完美兼容；但普通用户API限速，频繁报错             |
| 天翼云盘    | ✅        | ✅            | 直链完美兼容，速度完美                                |

### 按客户端分

| 客户端     | Emby | Jellyfin | 备注                             |
| ---------- | ---- | -------- | -------------------------------- |
| Web        | 🟡    | 🟡        | 不兼容夸克部分转码资源，其他正常 |
| Android    | ✅    | ⚫        |                                  |
| Android TV | 🟡    | -        | 不兼容夸克部分转码资源，其他正常 |
| VidHub     | ✅    | ✅        |                                  |
| Yamby      | 🟡    | -        | 不兼容夸克部分转码资源，其他正常 |
| AfuseKt    | ✅    | ✅        |                                  |

## Q&A

#### Q: 是否支持网盘转存、自动转存？
> A: 暂无计划，做好一件事，少即是多。市面上已经有不少转存工具，不重复造轮子，除非我有信心做成最好用的轮子。

#### Q: 免费和收费？
> A: 基础功能免费（STRM生成，Webhook等），已经能够满足绝大多数人需求，高级功能付费（302代理），定价极其合理。作者的免费开源项目 QAS 至今已迭代多个版本， SmartStrm 是打通网络存储和私有媒体库的最后一块拼图，从高级功能中获取一定的回报，更有利于项目的长远发展。
>
> 功能定位：
> - 免费功能：基础的功能、细节优化、大众的需求。
> - 高级功能：进阶的功能、小众的需求，尤其是一个功能我自己用不上，是为了满足用户们需求而开发，那将会是Pro功能。

#### Q: 302代理之后可以分享给家人和朋友用吗 这样会风控吗？
> A: 302代理后直接由客户端直接向网盘请求资源，理论上能识别到你的账号在异地下载。假设你家里登录了、公司在异地也登录了，少量属于正常的使用需求。但如果公开出去同时十几、几十处异地下载，只能说有风险，风险自担。

#### Q: 关于目录时间检查选项的工作机制？
> A: 这个选项是为了最小化地请求接口，和最快的速度执行任务。远端目录的修改时间更新了、比本地新，就会往下检查。已知115新增/删除文件都会更新父目录的修改时间；夸克网盘新增会更新但删除不会；各个盘可能机制不一，建议自行验证。

#### Q: 映射了 302 代理端口访问 Emby ，还要不要映射 SmartStrm 端口？
> A: 不需要，如果用 SS 的 302 代理功能，分享代理后的 Emby 端口出去，STRM 地址可以直接用内网，代理会自行处理。别人访问不到 SmsrtStrm 或 STRM 的地址，能访问的只有代理后的 Emby 服务，所以我称之为 “一站式 Emby Jellyfin 302 直链播放” 。

#### Q: 能否支持 Jellyfin 的删除 Webhook 通知？
> A: Jellyfin 的通知中缺少一些关键信息，导致 SS 无法得知要删除的路径，所以没办法支持。

#### Q: 夸克播放部分资源偏色？
> 这是个已知问题。这是流媒体和杜比的兼容性问题，无解。你可以去夸克客户端、夸克TV播这个资源验证一下，也是一样的偏色。目前已知同一个直链资源，呼出 PotPlayer 播放不会偏色，如果客户端不支持只能换资源。

## 最后

感谢你看到这里，感谢你了解这个项目。这个项目起源于我在用过同类 STRM 工具后，始终找不到一款符合完美期望的，于是尝试自己写一个。

SmartStrm 的定位是媒体库 STRM 生成工具，是打通网络存储和私有媒体库的最后一块拼图。

如果说 QAS 是练手项目，那么 SmartStrm 就是用心之作，其中包含了大量相互联动的巧思、对新手友好的设计。

正如其名，它希望尽可能地为你减少繁杂的操作和配置，让你感觉就是“好用”！

希望你能喜欢。
