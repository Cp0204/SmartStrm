# SmartStrm What's New

## v0.0.3

- STRM 生成
  - 优化复制文件名的处理逻辑，如目录下有需生成的同名媒体，将复制的文件命名为 `同名.(media_ext).copy_ext`  解决 nfo 不匹配的问题 https://github.com/Cp0204/SmartStrm/issues/1#issuecomment-3216267328
- 302代理
  - 修复观看 直播/IPTV 没有兼容的流
- 驱动
  - 修复本地文件驱动兼容性问题 #1
  - 修复本地驱动路径问题
- Webhook
  - 优化 Emby 同步删除时无效路径的错误提示

## v0.0.2

- 驱动
  - 添加 115 开放平台一键授权功能
  - 夸克添加 SVIP+ 识别
- STRM 生成
  - 修复大写扩展名的判断异常
  - 调整远程目录读取失败时不创建本地目录
  - 优化日志输出，增加读取目录失败计数
- UI
  - 完善页面文案描述、错误提示、防错
- 部分代码逻辑重构，提升性能

## v0.0.1

首次发布，一个媒体库 STRM 文件生成工具。 和 Emby 优雅配合，支持 302 直链播放，支持同步删除远端文件。 正如其名，配合 quark-auto-save/CloudSaver, OpenList, Emby 力求即存即看。🥳

* 多驱动支持
  * OpenList/AList、WebDAV、本地文件、夸克网盘、115
* STRM 生成
  * 基础生成功能
  * 远端删除自动清理
  * 生成后缀、大小阈值、复制文件后缀等基础设定
* Webhook 支持
  * Emby 媒体删除同步
  * 联动 QAS/CloudSaver 触发任务
* 存储浏览
  * 基础目录浏览
  * 批量重命名（WIP）