ClaudeCode 模型切换工具
======================

项目简介
--------
本项目提供跨平台的ClaudeCode模型切换脚本，支持在macOS、Linux和Windows系统上快速切换不同的AI模型配置。

脚本文件
--------
- `set_cc_mac.sh`      - macOS版本脚本
- `set_cc_linux.sh`    - Linux版本脚本
- `set_cc_win.bat`     - Windows版本脚本

支持模型
--------
- **kimi**      - Kimi模型 (kimi-k2-0905-preview)
- **glm**       - GLM模型 (GLM-4.6)
- **qwen**      - Qwen模型 (qwen-coder-plus)
- **deepseek**  - Deepseek模型 (deepseek-chat) - 默认模型

使用方法
--------

### macOS / Linux
```bash
# 给脚本添加执行权限
chmod +x set_cc_mac.sh
chmod +x set_cc_linux.sh

# 使用bash执行（推荐）
bash set_cc_linux.sh list
bash set_cc_linux.sh current
bash set_cc_linux.sh kimi

# 或直接执行（需要执行权限）
./set_cc_linux.sh list
./set_cc_linux.sh current
./set_cc_linux.sh kimi
```

### Windows
```cmd
# 直接执行批处理文件
set_cc_win.bat list
set_cc_win.bat current
set_cc_win.bat kimi
```

命令说明
--------
- `list`     - 列出所有可用模型
- `current`  - 显示当前模型配置
- `模型名称` - 切换到指定模型 (kimi/glm/qwen/deepseek)
- `-h/--help` - 显示帮助信息

环境变量
--------
脚本会设置以下环境变量：
- `ANTHROPIC_BASE_URL`    - API基础URL
- `ANTHROPIC_MODEL`       - 模型名称
- `ANTHROPIC_AUTH_TOKEN`  - API密钥前缀

注意事项
--------
- Linux脚本需要使用bash执行，不要使用sh
- Windows脚本使用setx命令永久设置环境变量，需要重新打开命令提示符生效
- 各脚本会修改对应的shell配置文件（.bashrc/.zshrc）或注册表
- API密钥需要用户自行补充完整

项目结构
--------
```
cc_starter/
├── README.txt          # 项目说明文档
├── set_cc_mac.sh       # macOS切换脚本
├── set_cc_linux.sh     # Linux切换脚本
└── set_cc_win.bat      # Windows切换脚本
```

许可证
------
MIT License

Copyright (c) 2025 zhangyiw

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.
