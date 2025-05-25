#!/bin/bash

ZSHRC="/root/.zshrc"
BACKUP="${ZSHRC}.bak"
ZSH_CUSTOM="${ZSH_CUSTOM:-/root/.oh-my-zsh/custom}"

# 备份
cp "$ZSHRC" "$BACKUP"

# 替换 ZSH_THEME
sed -i -E 's/^ZSH_THEME=.*/ZSH_THEME="maran"/' "$ZSHRC"

# 添加 z 插件（如果未存在）
if ! grep -qE '^plugins=.*\bz\b' "$ZSHRC"; then
    sed -i -E 's/^(plugins=\([^\)]*)/\1 z/' "$ZSHRC"
fi

# 安装 zsh-autosuggestions 插件
git clone https://github.com/zsh-users/zsh-autosuggestions "${ZSH_CUSTOM}/plugins/zsh-autosuggestions"

# 安装 zsh-syntax-highlighting 插件
git clone https://github.com/zsh-users/zsh-syntax-highlighting.git "${ZSH_CUSTOM}/plugins/zsh-syntax-highlighting"

echo "✅ 修改完成，已备份原文件为 $BACKUP"
