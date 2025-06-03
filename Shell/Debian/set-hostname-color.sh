#!/bin/bash

# 定义颜色变量
RED='\e[31m'
GREEN='\e[32m'
YELLOW='\e[33m'
BLUE='\e[34m'
PURPLE='\e[35m'
CYAN='\e[36m'
WHITE='\e[37m'
RESET='\e[0m'

echo -e "请选择主机名显示颜色："
echo -e " 1) ${RED}红色${RESET}"
echo -e " 2) ${GREEN}绿色${RESET}"
echo -e " 3) ${YELLOW}黄色${RESET}"
echo -e " 4) ${BLUE}蓝色${RESET}"
echo -e " 5) ${PURPLE}紫色${RESET}"
echo -e " 6) ${CYAN}青色${RESET}"
echo -e " 7) ${WHITE}白色${RESET}"
echo -n "输入数字选择颜色 (1-7): "
read choice

case $choice in
  1) COLOR_CODE=31 ;;
  2) COLOR_CODE=32 ;;
  3) COLOR_CODE=33 ;;
  4) COLOR_CODE=34 ;;
  5) COLOR_CODE=35 ;;
  6) COLOR_CODE=36 ;;
  7) COLOR_CODE=37 ;;
  *) echo "无效选择，退出"; exit 1 ;;
esac

BASHRC="$HOME/.bashrc"
BACKUP="$HOME/.bashrc.bak_$(date +%F_%T)"

# 备份.bashrc
cp "$BASHRC" "$BACKUP"
echo "已备份原始文件为 $BACKUP"

# 删除之前PS1相关行（匹配含 \u@\h 的行）
sed -i '/\\u@\\h/d' "$BASHRC"

# 添加新的PS1定义（彩色主机名，用户名+主机名）
echo -e "\n# 设置彩色主机名的提示符" >> "$BASHRC"
echo "PS1='\\[\\e[${COLOR_CODE}m\\]\\u@\\h\\[\\e[0m\\]:\\w\\\$ '" >> "$BASHRC"

echo "已修改 $BASHRC，请重新登录或者运行命令使之生效："
echo "source ~/.bashrc"

# 自动刷新当前shell
source "$BASHRC"