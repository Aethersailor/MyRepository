#!/bin/bash

ZSHRC="/root/.zshrc"
BACKUP="${ZSHRC}.bak"
ZSH_CUSTOM="${ZSH_CUSTOM:-/root/.oh-my-zsh/custom}"

echo "🔧 开始配置 zsh 环境..."

# === 1. 备份 .zshrc 文件 ===
if [ -f "$ZSHRC" ]; then
    cp "$ZSHRC" "$BACKUP"
    echo "📦 已备份原始 .zshrc 为 $BACKUP"
else
    echo "⚠️ 未找到 $ZSHRC，将跳过备份"
fi

# === 2. 修改 ZSH_THEME ===
if grep -q '^ZSH_THEME=' "$ZSHRC"; then
    sed -i -E 's/^ZSH_THEME=.*/ZSH_THEME="maran"/' "$ZSHRC"
    echo "🎨 已将 ZSH_THEME 修改为 \"maran\""
else
    echo 'ZSH_THEME="maran"' >> "$ZSHRC"
    echo "🎨 未找到 ZSH_THEME，已添加 \"maran\" 配置"
fi

# === 3. 插件管理：添加 z、autosuggestions、syntax-highlighting，避免重复 ===
REQUIRED_PLUGINS=(z zsh-autosuggestions zsh-syntax-highlighting)
if grep -qE '^plugins=\(.*\)' "$ZSHRC"; then
    CURRENT_LINE=$(grep -E '^plugins=\(.*\)' "$ZSHRC")
    for plugin in "${REQUIRED_PLUGINS[@]}"; do
        if ! echo "$CURRENT_LINE" | grep -qw "$plugin"; then
            CURRENT_LINE=$(echo "$CURRENT_LINE" | sed -E "s/^(plugins=\()([^\)]*)\)/\1\2 $plugin)/")
        fi
    done
    sed -i -E "s/^plugins=\(.*\)/$CURRENT_LINE/" "$ZSHRC"
    echo "🧩 plugins 行已更新，已确保包含：${REQUIRED_PLUGINS[*]}"
else
    echo "plugins=(${REQUIRED_PLUGINS[*]})" >> "$ZSHRC"
    echo "🧩 plugins 行不存在，已添加：${REQUIRED_PLUGINS[*]}"
fi

# === 4. 插件安装 ===
AUTO_DIR="${ZSH_CUSTOM}/plugins/zsh-autosuggestions"
SYNTAX_DIR="${ZSH_CUSTOM}/plugins/zsh-syntax-highlighting"

if [ -d "$AUTO_DIR" ]; then
    echo "✅ zsh-autosuggestions 插件已存在，跳过克隆"
else
    git clone https://github.com/zsh-users/zsh-autosuggestions "$AUTO_DIR" && \
    echo "📥 已克隆 zsh-autosuggestions 插件"
fi

if [ -d "$SYNTAX_DIR" ]; then
    echo "✅ zsh-syntax-highlighting 插件已存在，跳过克隆"
else
    git clone https://github.com/zsh-users/zsh-syntax-highlighting.git "$SYNTAX_DIR" && \
    echo "📥 已克隆 zsh-syntax-highlighting 插件"
fi

# === 5. 使用 zstyle 设置 oh-my-zsh 自动更新 ===
echo "🛠️ 正在设置 oh-my-zsh 自动更新策略 (zstyle)..."

# 设置 zstyle ':omz:update' mode auto
if grep -qE "^\s*zstyle ':omz:update' mode " "$ZSHRC"; then
    sed -i -E "s|^\s*zstyle ':omz:update' mode .*|zstyle ':omz:update' mode auto|" "$ZSHRC"
    echo "✅ 已设置 zstyle auto-update 模式为 auto"
else
    MODE_LINE=$(grep -n "Uncomment one of the following lines to change the auto-update behavior" "$ZSHRC" | cut -d: -f1)
    if [ -n "$MODE_LINE" ]; then
        INSERT_LINE=$((MODE_LINE + 4))
        sed -i "${INSERT_LINE}i zstyle ':omz:update' mode auto" "$ZSHRC"
        echo "✅ 已插入 zstyle auto-update 模式为 auto 到对应注释下方"
    else
        echo "zstyle ':omz:update' mode auto" >> "$ZSHRC"
        echo "⚠️ 注释未找到，已添加 zstyle auto-update 模式配置到文件末尾"
    fi
fi

# 设置 zstyle ':omz:update' frequency 1
if grep -qE "^\s*zstyle ':omz:update' frequency " "$ZSHRC"; then
    sed -i -E "s|^\s*zstyle ':omz:update' frequency .*|zstyle ':omz:update' frequency 1|" "$ZSHRC"
    echo "✅ 已设置 zstyle auto-update 频率为每日 (1 天)"
else
    FREQ_LINE=$(grep -n "Uncomment the following line to change how often to auto-update" "$ZSHRC" | cut -d: -f1)
    if [ -n "$FREQ_LINE" ]; then
        INSERT_LINE=$((FREQ_LINE + 1))
        sed -i "${INSERT_LINE}i zstyle ':omz:update' frequency 1" "$ZSHRC"
        echo "✅ 已插入 zstyle auto-update 频率为每日 到对应注释下方"
    else
        echo "zstyle ':omz:update' frequency 1" >> "$ZSHRC"
        echo "⚠️ 注释未找到，已添加 zstyle auto-update 频率配置到文件末尾"
    fi
fi

# === 6. 立即应用配置 ===
#echo
#echo "🔁 正在执行：source ~/.zshrc"
#source "$ZSHRC"

# === 最终提示 ===
echo
echo "🎉 所有配置已完成并生效！"
echo "🧩 plugins 列表包含：${REQUIRED_PLUGINS[*]}"
echo "💡 当前配置文件路径：$ZSHRC"
echo "🛡️ 如需还原，可使用备份文件：$BACKUP"