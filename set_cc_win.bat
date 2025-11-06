@echo off
setlocal enabledelayedexpansion

:: set_cc_win.bat - 切换不同AI模型环境变量的脚本（Windows版本）

:: 显示使用说明
:show_usage
echo 用法: %0 [模型名称]
echo 可用模型:
echo   kimi       切换到Kimi模型
echo   glm        切换到GLM模型
echo   qwen       切换到Qwen模型
echo   deepseek   切换到Deepseek模型（默认）
echo   list       列出所有可用模型
echo   current    显示当前模型配置
echo.
echo 示例:
echo   %0 kimi      # 切换到Kimi模型
echo   %0 current   # 显示当前配置
goto :eof

:: 显示当前配置
:show_current
echo 当前模型配置:
echo ANTHROPIC_BASE_URL: %ANTHROPIC_BASE_URL%
echo ANTHROPIC_MODEL: %ANTHROPIC_MODEL%
if "%ANTHROPIC_AUTH_TOKEN%"=="" (
    echo ANTHROPIC_AUTH_TOKEN: 未设置
) else (
    echo ANTHROPIC_AUTH_TOKEN: %ANTHROPIC_AUTH_TOKEN:~0,10%...
)
goto :eof

:: 获取模型配置
:get_model_config
set model=%1
set config_type=%2

if "%model%"=="kimi" (
    if "%config_type%"=="base" echo https://api.moonshot.cn/anthropic
    if "%config_type%"=="model" echo kimi-k2-0905-preview
    if "%config_type%"=="key" echo sk-
)

if "%model%"=="glm" (
    if "%config_type%"=="base" echo https://open.bigmodel.cn/api/anthropic
    if "%config_type%"=="model" echo GLM-4.6
    if "%config_type%"=="key" echo dd3
)

if "%model%"=="qwen" (
    if "%config_type%"=="base" echo https://dashscope.aliyuncs.com/apps/anthropic
    if "%config_type%"=="model" echo qwen-coder-plus
    if "%config_type%"=="key" echo sk-
)

if "%model%"=="deepseek" (
    if "%config_type%"=="base" echo https://api.deepseek.com/anthropic
    if "%config_type%"=="model" echo deepseek-chat
    if "%config_type%"=="key" echo sk-
)
goto :eof

:: 列出所有可用模型
:list_models
echo 可用模型配置:
for /f "tokens=1,2 delims=:" %%i in ('call :get_model_config kimi model') do set model_kimi=%%i
for /f "tokens=1,2 delims=:" %%i in ('call :get_model_config glm model') do set model_glm=%%i
for /f "tokens=1,2 delims=:" %%i in ('call :get_model_config qwen model') do set model_qwen=%%i
for /f "tokens=1,2 delims=:" %%i in ('call :get_model_config deepseek model') do set model_deepseek=%%i

echo 1. kimi      - !model_kimi!
echo 2. glm       - !model_glm!
echo 3. qwen      - !model_qwen!
echo 4. deepseek  - !model_deepseek!
goto :eof

:: 切换模型配置
:switch_model
set model=%1

if "%model%"=="kimi" goto valid_model
if "%model%"=="glm" goto valid_model
if "%model%"=="qwen" goto valid_model
if "%model%"=="deepseek" goto valid_model
echo ❌ 错误: 未知模型 '%model%'
call :show_usage
exit /b 1

:valid_model
for /f "tokens=*" %%i in ('call :get_model_config %model% base') do set base_url=%%i
for /f "tokens=*" %%i in ('call :get_model_config %model% model') do set model_name=%%i
for /f "tokens=*" %%i in ('call :get_model_config %model% key') do set api_key=%%i

:: 设置环境变量
set ANTHROPIC_BASE_URL=%base_url%
set ANTHROPIC_MODEL=%model_name%
set ANTHROPIC_AUTH_TOKEN=%api_key%

:: 更新用户环境变量（永久生效）
setx ANTHROPIC_BASE_URL "%base_url%" >nul
setx ANTHROPIC_MODEL "%model_name%" >nul
setx ANTHROPIC_AUTH_TOKEN "%api_key%" >nul

echo ✅ 已切换到 %model% 模型，环境变量已永久设置。
echo     重新打开命令提示符或运行 "refreshenv" 使更改生效。

:: 显示新的配置
echo.
echo 新的配置:
echo   ANTHROPIC_BASE_URL: %ANTHROPIC_BASE_URL%
echo   ANTHROPIC_MODEL: %ANTHROPIC_MODEL%
echo   ANTHROPIC_AUTH_TOKEN: %ANTHROPIC_AUTH_TOKEN:~0,10%...
goto :eof

:: 主函数
:main
if "%1"=="" (
    call :show_usage
    exit /b 1
)

if "%1"=="list" (
    call :list_models
    exit /b 0
)

if "%1"=="current" (
    call :show_current
    exit /b 0
)

if "%1"=="-h" (
    call :show_usage
    exit /b 0
)

if "%1"=="--help" (
    call :show_usage
    exit /b 0
)

call :switch_model "%1"
exit /b 0

:: 如果脚本被直接执行，则运行主函数
if "%~0"=="%~nx0" (
    call :main %*
)