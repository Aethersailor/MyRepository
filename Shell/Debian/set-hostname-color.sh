#!/bin/bash

echo "请选择主机名显示颜色："
echo -e "1) \e[31m红色\e[0m"
echo -e "2) \e[32m绿色\e[0m"
echo -e "3) \e[33m黄色\e[0m"
echo -e "4) \e[34m蓝色\e[0m"
echo -e "5) \e[35m紫色\e[0m"
echo -e "6) \e[36m青色\e[0m"
echo -e "7) \e[91m亮红\e[0m"
echo -e "8) \e[92m亮绿\e[0m"
echo -e "9) \e[93m亮黄\e[0m"
echo -e "10) \e[94m亮蓝\e[0m"
echo -e "11) \e[95m亮紫\e[0m"
echo -e "12) \e[96m亮青\e[0m"

read -p "输入数字选择颜色 (1-12): " color_choice

case $color_choice in
  1) color_code="31" ;;
  2) color_code="32" ;;
  3) color_code="33" ;;
  4) color_code="34" ;;
  5) color_code="35" ;;
  6) color_code="36" ;;
  7) color_code="91" ;;
  8) color_code="92" ;;
  9) color_code="93" ;;
 10) color_code="94" ;;
 11) color_code="95" ;;
 12) color_code="96" ;;
  *) echo "无效选择，退出"; exit 1 ;;
esac

read -p "是否加粗主机名？(y/n): " bold_choice

if [[ "$bold_choice" =~ ^[Yy]$ ]]; then
  color_seq="\\[\\e[1;${color_code}m\\]"
else
  color_seq="\\[\\e[0;${color_code}m\\]"
fi

reset_seq="\\[\\e[0m\\]"

# 构造 PS1
new_ps1='\\u@'"${color_seq}"'\\h'"${reset_seq}"':\\w\\$ '

# 修改 .bashrc
if grep -q '^PS1=' ~/.bashrc; then
  sed -i 's/^PS1=.*/PS1='"\"$new_ps1\""'/g' ~/.bashrc
else
  echo "PS1=\"$new_ps1\"" >> ~/.bashrc
fi

echo -e "\n已更新主机名颜色为 \e[${color_code}m$(hostname)\e[0m"
echo "变更将在下次登录或执行 'source ~/.bashrc' 后生效。"