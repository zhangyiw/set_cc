#!/bin/bash

# set_cc_linux.sh - 切换不同AI模型环境变量的脚本（Linux版本）

# 显示使用说明
show_usage() {
    echo "用法: $0 [模型名称]"
    echo "可用模型:"
    echo "  kimi       切换到Kimi模型"
    echo "  glm        切换到GLM模型"
    echo "  qwen       切换到Qwen模型"
    echo "  deepseek   切换到Deepseek模型（默认）"
    echo "  list       列出所有可用模型"
    echo "  current    显示当前模型配置"
    echo ""
    echo "示例:"
    echo "  $0 kimi      # 切换到Kimi模型"
    echo "  $0 current   # 显示当前配置"
}

# 显示当前配置
show_current() {
    echo "当前模型配置:"
    echo "ANTHROPIC_BASE_URL: ${ANTHROPIC_BASE_URL:-未设置}"
    echo "ANTHROPIC_MODEL: ${ANTHROPIC_MODEL:-未设置}"
    echo "ANTHROPIC_AUTH_TOKEN: ${ANTHROPIC_AUTH_TOKEN:-未设置}"
}

# 获取模型配置
get_model_config() {
    local model=$1
    local config_type=$2  # base, model, key

    case $model in
        kimi)
            case $config_type in
                base) echo "https://api.moonshot.cn/anthropic" ;;
                model) echo "kimi-k2-0905-preview" ;;
                key) echo "sk-" ;;
            esac
            ;;
        glm)
            case $config_type in
                base) echo "https://open.bigmodel.cn/api/anthropic" ;;
                model) echo "GLM-4.6" ;;
                key) echo "dd3" ;;
            esac
            ;;
        qwen)
            case $config_type in
                base) echo "https://dashscope.aliyuncs.com/apps/anthropic" ;;
                model) echo "qwen-coder-plus" ;;
                key) echo "sk-" ;;
            esac
            ;;
        deepseek)
            case $config_type in
                base) echo "https://api.deepseek.com/anthropic" ;;
                model) echo "deepseek-chat" ;;
                key) echo "sk-" ;;
            esac
            ;;
    esac
}

# 列出所有可用模型
list_models() {
    echo "可用模型配置:"
    echo "1. kimi      - $(get_model_config kimi model)"
    echo "2. glm       - $(get_model_config glm model)"
    echo "3. qwen      - $(get_model_config qwen model)"
    echo "4. deepseek  - $(get_model_config deepseek model)"
}

# 切换模型配置
switch_model() {
    local model=$1

    case $model in
        kimi|glm|qwen|deepseek)
            export ANTHROPIC_BASE_URL="$(get_model_config $model base)"
            export ANTHROPIC_MODEL="$(get_model_config $model model)"
            export ANTHROPIC_AUTH_TOKEN="$(get_model_config $model key)"

            # 检查并更新 ~/.bashrc (Linux默认使用bash)
            if grep -q "export ANTHROPIC_BASE_URL=" ~/.bashrc 2>/dev/null; then
                # 如果已存在ANTHROPIC_BASE_URL，则替换 (Linux sed语法)
                sed -i "s#export ANTHROPIC_BASE_URL=.*#export ANTHROPIC_BASE_URL=\"$(get_model_config $model base)\"#" ~/.bashrc
            else
                # 如果不存在，则追加
                echo "export ANTHROPIC_BASE_URL=\"$(get_model_config $model base)\"" >> ~/.bashrc
            fi

            if grep -q "export ANTHROPIC_MODEL=" ~/.bashrc 2>/dev/null; then
                # 如果已存在ANTHROPIC_MODEL，则替换
                sed -i "s#export ANTHROPIC_MODEL=.*#export ANTHROPIC_MODEL=\"$(get_model_config $model model)\"#" ~/.bashrc
            else
                # 如果不存在，则追加
                echo "export ANTHROPIC_MODEL=\"$(get_model_config $model model)\"" >> ~/.bashrc
            fi

            if grep -q "export ANTHROPIC_AUTH_TOKEN=" ~/.bashrc 2>/dev/null; then
                # 如果已存在ANTHROPIC_AUTH_TOKEN，则替换
                sed -i "s#export ANTHROPIC_AUTH_TOKEN=.*#export ANTHROPIC_AUTH_TOKEN=\"$(get_model_config $model key)\"#" ~/.bashrc
            else
                # 如果不存在，则追加
                echo "export ANTHROPIC_AUTH_TOKEN=\"$(get_model_config $model key)\"" >> ~/.bashrc
            fi

            echo "✅ 已切换到 $model 模型，请执行 'source ~/.bashrc' 或重新打开终端使更改永久生效."
            ;;
        *)
            echo "❌ 错误: 未知模型 '$model'"
            show_usage
            return 1
            ;;
    esac



    # 显示新的配置
    echo ""
    echo "新的配置:"
    echo "  ANTHROPIC_BASE_URL: $ANTHROPIC_BASE_URL"
    echo "  ANTHROPIC_MODEL: $ANTHROPIC_MODEL"
    echo "  ANTHROPIC_AUTH_TOKEN: ${ANTHROPIC_AUTH_TOKEN:0:10}..."  # 只显示API Key的前10位
}

# 主函数
main() {
    if [ $# -eq 0 ]; then
        show_usage
        exit 1
    fi

    case $1 in
        list)
            list_models
            ;;
        current)
            show_current
            ;;
        -h|--help)
            show_usage
            ;;
        *)
            switch_model "$1"
            ;;
    esac
}

# 如果脚本被直接执行，则运行主函数
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    main "$@"
fi