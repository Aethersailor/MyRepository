#!/usr/bin/env bash
# ensure_sshd_config.sh
# 用于更新 /etc/ssh/sshd_config 的关键配置
# 用法：./ensure_sshd_config.sh [配置文件路径]

set -euo pipefail

# 默认配置文件路径
SSHD_CONFIG_PATH="${1:-/etc/ssh/sshd_config}"
# 生成备份文件
BACKUP_PATH="${SSHD_CONFIG_PATH}.bak.$(date +%Y%m%d%H%M%S)"

# 1. 备份原文件
cp "$SSHD_CONFIG_PATH" "$BACKUP_PATH"
echo "备份已保存到 $BACKUP_PATH"

# 2. 仅保留 ed25519 HostKey，删除其它 HostKey 行（不包含注释）
sed -i "/^[[:space:]]*HostKey.*ssh_host_ed25519_key/!{/^[[:space:]]*HostKey[[:space:]]/d}" "$SSHD_CONFIG_PATH"

# 3. 定义需要设置的键值对
declare -A config_map=(
  [Ciphers]="aes128-gcm@openssh.com,chacha20-poly1305@openssh.com"
  [MACs]="hmac-sha2-256-etm@openssh.com"
  [KexAlgorithms]="curve25519-sha256,curve25519-sha256@libssh.org"
  [AllowUsers]="root"
  [KbdInteractiveAuthentication]="no"
  [ChallengeResponseAuthentication]="no"
  [UseDNS]="no"
  [LoginGraceTime]="30s"
  [ClientAliveInterval]="60"
  [ClientAliveCountMax]="5"
  [MaxStartups]="10:30:100"
  [AllowTcpForwarding]="yes"
  [AllowAgentForwarding]="yes"
  [GatewayPorts]="no"
  [X11Forwarding]="no"
)

# 4. 更新或添加每一项配置
for key in "${!config_map[@]}"; do
  value="${config_map[$key]}"
  # 检查是否存在非注释的配置行
  if grep -Eq "^[[:space:]]*${key}[[:space:]]+" "$SSHD_CONFIG_PATH"; then
    # 存在则替换整行
    sed -i -E "s|^[[:space:]]*(${key})[[:space:]]+.*|\1 ${value}|" "$SSHD_CONFIG_PATH"
  else
    # 不存在则追加
    echo -e "\n${key} ${value}" >> "$SSHD_CONFIG_PATH"
  fi
done

echo "sshd_config 已更新完毕，重启 SSH 服务..."
systemctl restart sshd

