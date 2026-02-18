#!/usr/bin/env bash
set -euo pipefail

UBUNTU_CODENAME="jammy"

# ===== COLORS =====
RED="\033[1;31m"
GREEN="\033[1;32m"
YELLOW="\033[1;33m"
CYAN="\033[1;36m"
RESET="\033[0m"

echo -e "\n😈 ${CYAN}NETWORK BOOSTER GOD MODE PRO MAX${RESET}"
echo -e "🚀 Mirror + DNS + TCP BBR + Speed Boost\n"

# ================= MIRRORS =================

MIRRORS=(

# 🇮🇷 IRAN
"https://ubuntu.pishgaman.net/ubuntu|🇮🇷"
"http://mirror.aminidc.com/ubuntu|🇮🇷"
"https://ubuntu.pars.host|🇮🇷"
"https://ir.ubuntu.sindad.cloud/ubuntu|🇮🇷"
"https://ubuntu.shatel.ir/ubuntu|🇮🇷"
"https://ubuntu.mobinhost.com/ubuntu|🇮🇷"
"https://mirror.iranserver.com/ubuntu|🇮🇷"
"https://mirror.arvancloud.ir/ubuntu|🇮🇷"
"http://ir.archive.ubuntu.com/ubuntu|🇮🇷"
"https://ubuntu.parsvds.com/ubuntu|🇮🇷"
"http://mirror.asiatech.ir/ubuntu|🇮🇷"
"http://mirror.ut.ac.ir/ubuntu|🇮🇷"
"http://mirrors.sharif.ir/ubuntu|🇮🇷"

# ☁️ CDN
"https://cloudflare.cdn.ubuntu.com/ubuntu|☁️"

# 🇳🇱 NL
"http://mirror.ams1.nl.leaseweb.net/ubuntu|🇳🇱"
"http://mirror.serverion.com/ubuntu|🇳🇱"

# 🇺🇸 US
"https://archive.ubuntu.com/ubuntu|🇺🇸"
"http://security.ubuntu.com/ubuntu|🇺🇸"

# 🇨🇳 CN
"https://mirrors.tuna.tsinghua.edu.cn/ubuntu|🇨🇳"
"https://mirrors.aliyun.com/ubuntu|🇨🇳"
"https://mirrors.ustc.edu.cn/ubuntu|🇨🇳"

# 🇯🇵 JP
"http://ftp.jaist.ac.jp/pub/Linux/ubuntu|🇯🇵"
"http://mirror.riken.jp/Linux/ubuntu|🇯🇵"

# 🌍 GLOBAL
"http://mirrors.kernel.org/ubuntu|🌍"
"http://ftp.fau.de/ubuntu|🌍"
)

# ================= DNS =================

DNS_LIST=(
"178.22.122.100"
"185.51.200.2"
"1.1.1.1"
"1.0.0.1"
"8.8.8.8"
"8.8.4.4"
"9.9.9.9"
"149.112.112.112"
"94.140.14.14"
"94.140.15.15"
"208.67.222.222"
"208.67.220.220"
"45.90.28.0"
"45.90.30.0"
"76.76.2.0"
"223.5.5.5"
"119.29.29.29"
)

echo -e "🔍 ${YELLOW}Testing Mirrors...${RESET}\n"

AVAILABLE_MIRRORS=()
FLAGS=()

for MIR in "${MIRRORS[@]}"; do

URL=$(echo "$MIR"|cut -d'|' -f1)
FLAG=$(echo "$MIR"|cut -d'|' -f2)
DOMAIN=$(echo "$URL"|awk -F/ '{print $3}')

PING_MS=$(ping -c1 -W1 "$DOMAIN" 2>/dev/null | grep time= | sed -E 's/.*time=([0-9\.]+).*/\1/' || true)

if [ -n "$PING_MS" ]; then
echo -e "${GREEN}$FLAG $DOMAIN OK (${PING_MS} ms)${RESET}"
AVAILABLE_MIRRORS+=("$URL")
FLAGS+=("$FLAG")
else
echo -e "${RED}$FLAG $DOMAIN FAIL${RESET}"
fi

done

echo -e "\n📋 Select Mirror:"
for i in "${!AVAILABLE_MIRRORS[@]}"; do
echo "$((i+1))) ${FLAGS[$i]} ${AVAILABLE_MIRRORS[$i]}"
done

read -p "👉 Mirror: " CHOICE
WORKING_MIRROR=${AVAILABLE_MIRRORS[$((CHOICE-1))]}

echo -e "\n🌐 DNS:"
for i in "${!DNS_LIST[@]}"; do
echo "$((i+1))) ${DNS_LIST[$i]}"
done

read -p "Primary DNS: " D1
read -p "Secondary DNS: " D2

PRIMARY_DNS=${DNS_LIST[$((D1-1))]}
SECONDARY_DNS=${DNS_LIST[$((D2-1))]}

echo -e "\n🚀 Enabling TCP BBR..."

cat <<EOF >> /etc/sysctl.conf
net.core.default_qdisc=fq
net.ipv4.tcp_congestion_control=bbr
EOF

sysctl -p

echo -e "\n💾 Applying configs..."

cp /etc/apt/sources.list /etc/apt/sources.list.bak || true

cat <<EOF > /etc/apt/sources.list
deb $WORKING_MIRROR $UBUNTU_CODENAME main restricted universe multiverse
deb $WORKING_MIRROR $UBUNTU_CODENAME-updates main restricted universe multiverse
deb $WORKING_MIRROR $UBUNTU_CODENAME-backports main restricted universe multiverse
deb $WORKING_MIRROR $UBUNTU_CODENAME-security main restricted universe multiverse
EOF

echo -e "nameserver $PRIMARY_DNS\nnameserver $SECONDARY_DNS" > /etc/resolv.conf

echo -e "\n🔥 ${GREEN}GOD MODE PRO MAX ACTIVE 😈${RESET}"
echo "Run: sudo apt update"
