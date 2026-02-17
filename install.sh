#!/usr/bin/env bash
set -euo pipefail

UBUNTU_CODENAME="jammy"
echo -e "\n📌 \033[1;36mUbuntu GOD MODE Ultra - Semi Manual\033[0m"
echo ""

# ==================== MIRRORS LIST ====================
# فرمت: "URL|Country Emoji|Country Name"
MIRRORS=(
"https://ir.archive.ubuntu.com/ubuntu/|🇮🇷|Iran"
"https://mirror.iranserver.com/ubuntu/|🇮🇷|Iran"
"http://mirror.iranserver.com/ubuntu/|🇮🇷|Iran"
"https://ubuntu.shatel.ir/ubuntu/|🇮🇷|Iran"
"http://mirror.asiatech.ir/ubuntu/|🇮🇷|Iran"
"https://archive.ubuntu.petiak.ir/ubuntu/|🇮🇷|Iran"
"https://ir.ubuntu.sindad.cloud/ubuntu/|🇮🇷|Iran"
"http://linuxmirrors.ir/pub/ubuntu/|🇮🇷|Iran"
"http://repo.iut.ac.ir/repo/ubuntu/|🇮🇷|Iran"
"http://mirrors.sharif.ir/ubuntu/|🇮🇷|Iran"
"http://mirror.ut.ac.ir/ubuntu/|🇮🇷|Iran"
"http://mirror.faraso.org/ubuntu/|🇮🇷|Iran"
"https://mirror.rasanegar.com/ubuntu/|🇮🇷|Iran"
"https://mirrors.pardisco.co/ubuntu/|🇮🇷|Iran"
"http://mirror.sbu.ac.ir/ubuntu/|🇮🇷|Iran"

"https://cloudflare.cdn.ubuntu.com/ubuntu/|☁️|CDN"
"https://mirror.arvancloud.ir/ubuntu/|☁️|CDN"

"https://archive.ubuntu.com/ubuntu/|🇺🇸|USA"
"http://security.ubuntu.com/ubuntu/|🇺🇸|USA"
"https://mirrors.tuna.tsinghua.edu.cn/ubuntu/|🇨🇳|China"
"https://mirrors.aliyun.com/ubuntu/|🇨🇳|China"
"https://mirrors.ustc.edu.cn/ubuntu/|🇨🇳|China"
"https://mirrors.huaweicloud.com/ubuntu/|🇨🇳|China"
"http://ftp.uni-stuttgart.de/ubuntu/|🇩🇪|Germany"
"http://mirror.netcologne.de/ubuntu/|🇩🇪|Germany"
"http://mirrors.kernel.org/ubuntu/|🌍|Global"
)

# ==================== DNS LIST ====================
DNS_LIST=(
"178.22.122.100"
"185.51.200.2"
"1.1.1.1"
"1.0.0.1"
"8.8.8.8"
"8.8.4.4"
"9.9.9.9"
"149.112.112.112"
)

# ==================== Ping + TCP Test ====================
echo -e "\n🔍 تست Ping و TCP میرورها...\n"
AVAILABLE_MIRRORS=()
PING_RESULTS=()
TCP_RESULTS=()
FLAGS=()

for MIR in "${MIRRORS[@]}"; do
    URL=$(echo "$MIR" | cut -d'|' -f1)
    FLAG=$(echo "$MIR" | cut -d'|' -f2)
    DOMAIN=$(echo "$URL" | awk -F/ '{print $3}')

    # Ping
    PING_MS=$(ping -c1 -W1 "$DOMAIN" 2>/dev/null | grep 'time=' | sed -E 's/.*time=([0-9\.]+).*/\1/' || echo 9999)

    # TCP test
    START=$(date +%s%3N)
    if nc -z -w1 "$DOMAIN" 80 &>/dev/null; then
        END=$(date +%s%3N)
        TCP_MS=$((END-START))
    else
        TCP_MS=9999
    fi

    if [ "$PING_MS" -lt 9999 ]; then
        AVAILABLE_MIRRORS+=("$URL")
        PING_RESULTS+=("$PING_MS")
        TCP_RESULTS+=("$TCP_MS")
        FLAGS+=("$FLAG")
    fi

    # نمایش رنگی
    if [ "$PING_MS" -lt 50 ]; then
        COLOR="\033[1;32m" # سبز
    elif [ "$PING_MS" -lt 150 ]; then
        COLOR="\033[1;33m" # زرد
    else
        COLOR="\033[1;31m" # قرمز
    fi

    echo -e "$FLAG $DOMAIN | Ping: $PING_MS ms | TCP: $TCP_MS ms"
done

# ==================== نمایش و انتخاب Mirror ====================
echo -e "\n📋 Mirror های قابل انتخاب:"
for i in "${!AVAILABLE_MIRRORS[@]}"; do
    INDEX=$((i+1))
    echo -e "$INDEX) ${FLAGS[$i]} ${AVAILABLE_MIRRORS[$i]} | Ping: ${PING_RESULTS[$i]} ms | TCP: ${TCP_RESULTS[$i]} ms"
done

read -p "👉 شماره Mirror را انتخاب کنید: " CHOICE
if ! [[ "$CHOICE" =~ ^[0-9]+$ ]] || [ "$CHOICE" -lt 1 ] || [ "$CHOICE" -gt ${#AVAILABLE_MIRRORS[@]} ]; then
    echo -e "\033[1;31m❌ انتخاب نامعتبر.\033[0m"
    exit 1
fi
WORKING_MIRROR=${AVAILABLE_MIRRORS[$((CHOICE-1))]}

echo -e "\n✅ Mirror انتخاب شده: $WORKING_MIRROR"

# ==================== Ping DNS ====================
echo -e "\n🔍 تست Ping DNS ها..."
AVAILABLE_DNS=()
DNS_MS=()
for i in "${!DNS_LIST[@]}"; do
    IP=${DNS_LIST[$i]}
    PING_MS=$(ping -c1 -W1 "$IP" 2>/dev/null | grep 'time=' | sed -E 's/.*time=([0-9\.]+).*/\1/' || echo 9999)
    if [ "$PING_MS" -lt 9999 ]; then
        AVAILABLE_DNS+=("$IP")
        DNS_MS+=("$PING_MS")
    fi
    echo -e "$((i+1))) $IP | Ping: $PING_MS ms"
done

# ==================== انتخاب دو DNS ====================
read -p "👉 شماره Primary DNS را انتخاب کنید: " DNS1
read -p "👉 شماره Secondary DNS را انتخاب کنید: " DNS2
PRIMARY_DNS=${AVAILABLE_DNS[$((DNS1-1))]}
SECONDARY_DNS=${AVAILABLE_DNS[$((DNS2-1))]}

echo -e "\n🔥 DNS انتخاب شده:"
echo -e "Primary: $PRIMARY_DNS"
echo -e "Secondary: $SECONDARY_DNS"

# ==================== Backup Files ====================
sudo cp /etc/resolv.conf /etc/resolv.conf.bak || true
sudo cp /etc/apt/sources.list /etc/sources.list.bak || true

# ==================== Apply Mirror ====================
sudo tee /etc/apt/sources.list >/dev/null <<EOF
deb $WORKING_MIRROR $UBUNTU_CODENAME main restricted universe multiverse
deb $WORKING_MIRROR $UBUNTU_CODENAME-updates main restricted universe multiverse
deb $WORKING_MIRROR $UBUNTU_CODENAME-backports main restricted universe multiverse
deb $WORKING_MIRROR $UBUNTU_CODENAME-security main restricted universe multiverse
EOF

# ==================== Apply DNS ====================
sudo tee /etc/resolv.conf >/dev/null <<EOF
nameserver $PRIMARY_DNS
nameserver $SECONDARY_DNS
EOF

# ==================== APT Boost ====================
sudo tee /etc/apt/apt.conf.d/99boost >/dev/null <<EOF
Acquire::Retries "3";
Acquire::http::Pipeline-Depth "5";
EOF

echo -e "\n✅ Mirror و DNS اعمال شد و APT Boost فعال شد 👍"
echo -e "📦 اجرا کنید:\n sudo apt update && sudo apt upgrade -y"
echo -e "😈 GOD MODE ULTRA COMPLETE"
