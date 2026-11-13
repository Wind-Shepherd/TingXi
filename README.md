# 听隙

![听隙封面](封面.png)

这是一个**完全离线、无需安装**的 Windows 英语听力工具。项目独立实现，不包含 HEYGOW 原站源码。

## 下载

在 [Releases](https://github.com/Wind-Shepherd/TingXi/releases/latest) 下载 `TingXi.exe`，双击即可启动。运行时需要本机有 Edge；没有 Edge 时会尝试用默认浏览器打开。

## 第一种方式：最简单，保证不需要 Python

1. 将 ZIP **完整解压**到普通文件夹（不要在 ZIP 压缩包预览窗口里运行 BAT）。
2. 直接双击 **`listenloop.html`**；它会在默认浏览器中打开。推荐 Edge 或 Chrome。
3. 点击顶部大框选择 MP3/WAV/M4A 文件，或将音频拖入页面，即可看到完整波形、放大时间轴、点击跳转与 A-B 循环。

这是最推荐的使用方式：只要浏览器能正常运行，就不依赖 BAT、PowerShell、Python、服务器或网络。

## 第二种方式：像独立软件窗口一样启动

双击 **`启动播放器.bat`**：如果系统能找到 Edge，就会以独立应用窗口打开；否则自动用默认浏览器打开 HTML。

若启动脚本无法使用，可直接打开 HTML。

## 第三种方式：打包真正的 EXE（可选）

**注意：这不是运行播放器的必要步骤。** 只在希望得到可直接双击的 Windows EXE 文件时使用。

1. Windows 上安装 Python 3（建议 3.11 或更新），可用命令提示符测试 `py -3 --version` 或 `python --version`。
2. 运行 **`打包EXE.bat`**。脚本创建独立 `.build_venv`，联网安装 PyInstaller，再打包。
3. 成功后打开 `dist\TingXi.exe`，它会用 Windows Edge 开一个没有地址栏的独立应用窗口；如无 Edge，则在默认浏览器打开。

运行生成的 EXE **不需要 Python**。打包阶段需要 Python 和网络。EXE 已在 Windows 11 上完成构建，使用 `TingXi.ico` 作为程序图标。

### EXE 的本地缓存

打包后的 EXE 会把内置 HTML 放到 `%LOCALAPPDATA%\TingXi\listenloop.html` 后再打开。这样浏览器不会因单文件 EXE 的临时解压目录被清理而丢失页面。音频仍然只在本机读取，不会上传。

## 故障排查

- **两个 BAT 双击无反应**：首先直接双击 `listenloop.html`。如果 HTML 能使用，播放器本身没问题。
- **打包提示未找到 Python**：只影响打包，不影响播放。需要先安装 Python 3。
- **打包提示无法下载 PyInstaller**：需要联网且能访问 PyPI，可以检查网络代理。
- **启动脚本一闪而过**：打开 CMD，切换到解压文件夹，输入 `启动播放器.bat` 或 `打包EXE.bat`，可查看提示信息。
- **HTML 双击也不能用**：右键 HTML，选择“打开方式”→ Microsoft Edge / Chrome，并把具体错误截图发给我。

## 播放操作

- 点击顶部大框选择 MP3/WAV/M4A，或拖入音频文件；波形覆盖整个录音。
- 局部波形上单击或拖动放置播放光标；滚轮放大缩小；按住 Shift 并滚轮横向平移。
- 定位到起点和终点后，分别点击“设 A”“设 B”来设置 A-B 循环。
- 左右方向键移动 2 秒，Shift+方向键微调 0.2 秒；空格播放/暂停。
- 上一句/下一句依据静音间隙作近似定位，不等于语音识别，噪声可能影响结果。

## 文件说明

- `listenloop.html`：离线播放器本体；直接双击即可运行。
- `启动播放器.bat`：打开 Edge 独立窗口 / 默认浏览器（无需 Python）。
- `打包EXE.bat`：安装打包依赖并生成 EXE（需要 Python）。
- `desktop.py`：EXE 所用的极简 Edge 启动器。
- `封面.png`、`TingXi.ico`：仓库封面和 EXE 图标；运行 `生成封面.ps1` 可以重新生成。
