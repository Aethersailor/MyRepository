#!/bin/bash

# 颜色映射（数字 => ANSI颜色码）
declare -A colors=(
  [1]=31   # 红色
  [2]=32   # 绿色
  [3]=33   # 黄色
  [4]=34   # 蓝色
  [5]=35   # 紫色
  [6]=36   # 青色
  [7]=91   # 亮红色
  [8]=92   # 亮绿色
  [9]=93   # 亮黄色
  [10]=94  # 亮蓝色
  [11]=95  # 亮紫色
  [12]=96  # 亮青色
)

# 打印彩色菜单
echo "请选择主机名显示颜色："
echo -e " 1) \e[31m红色\e[0m"
echo -e " 2) \e[32m绿色\e[0m"
echo -e " 3) \e[33m黄色\e[0m"
echo -e " 4) \e[34m蓝色\e[0m"
echo -e " 5) \e[35m紫色\e[0m"
echo -e " 6) \e[36m青色\e[0m"
echo -e " 7) \e[91m亮红色\e[0m"
echo -e " 8) \e[92m亮绿色\e[0m"
echo -e " 9) \e[93m亮黄色\e[0m"
echo -e "10) \e[94m亮蓝色\e[0m"
echo -e "11) \e[95m亮紫色\e[0m"
echo -e "12) \e[96m亮青色\e[0m"

read -rp "输入数字选择颜色 (1-12): " choice

if [[ ! ${colors[$choice]+_} ]]; then
  echo "无效选择，退出"
  exit 1
fi

color_code=${colors[$choice]}

# PS1，只给主机名加颜色
new_ps1='\\u@\\[\e['"$color_code"'m\\]\\h\\[\e[0m\\]:\\w\\$ '

# 写入 /etc/profile.d/hostname_color.sh
echo "export PS1=\"$new_ps1\"" > /etc/profile.d/hostname_color.sh

echo "设置完成，重新登录后主机名将显示为选中的颜色（仅主机名）"