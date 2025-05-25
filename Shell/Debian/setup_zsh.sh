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

# === 3. 添加 z 插件到 plugins=(...)，避免重复 ===
if grep -qE '^plugins=.*\bz\b' "$ZSHRC"; then
    echo "✅ 插件 z 已存在于 plugins 列表中，无需添加"
else
    sed -i -E 's/^(plugins=\([^\)]*)/\1 z/' "$ZSHRC" && \
    echo "➕ 已向 plugins 添加 z 插件"
fi

# === 4. 克隆 zsh-autosuggestions 插件 ===
AUTO_DIR="${ZSH_CUSTOM}/plugins/zsh-autosuggestions"
if [ -d "$AUTO_DIR" ]; then
    echo "✅ zsh-autosuggestions 插件已存在，跳过克隆"
else
    git clone https://github.com/zsh-users/zsh-autosuggestions "$AUTO_DIR" && \
    echo "📥 已克隆 zsh-autosuggestions 插件"
fi

# === 5. 克隆 zsh-syntax-highlighting 插件 ===
SYNTAX_DIR="${ZSH_CUSTOM}/plugins/zsh-syntax-highlighting"
if [ -d "$SYNTAX_DIR" ]; then
    echo "✅ zsh-syntax-highlighting 插件已存在，跳过克隆"
else
    git clone https://github.com/zsh-users/zsh-syntax-highlighting.git "$SYNTAX_DIR" && \
    echo "📥 已克隆 zsh-syntax-highlighting 插件"
fi

# === 最终提示 ===
echo
echo "🎉 所有操作完成！"
echo "👉 如果还未添加 autosuggestions 和 syntax-highlighting 到 plugins，请手动添加："
echo '   plugins=(... zsh-autosuggestions zsh-syntax-highlighting)'
echo "⚠️ 修改已完成，如有问题可恢复 $BACKUP"
