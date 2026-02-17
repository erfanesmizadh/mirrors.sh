#!/usr/bin/env bash
set -euo pipefail

UBUNTU_CODENAME="jammy"

echo "📌 Ubuntu GOD MODE Mirror & DNS Selector (Ping + TCP + 2DNS + APT Boost)"
echo ""

# ==================== FULL MIRROR LIST ====================

MIRRORS=(

# 🇮🇷 IRAN
"https://ir.archive.ubuntu.com/ubuntu/"
"https://mirror.iranserver.com/ubuntu/"
"http://mirror.iranserver.com/ubuntu/"
"https://ubuntu.shatel.ir/ubuntu/"
"http://mirror.asiatech.ir/ubuntu/"
"https://archive.ubuntu.petiak.ir/ubuntu/"
"https://ir.ubuntu.sindad.cloud/ubuntu/"
"http://linuxmirrors.ir/pub/ubuntu/"
"http://repo.iut.ac.ir/repo/ubuntu/"
"http://mirrors.sharif.ir/ubuntu/"
"http://mirror.ut.ac.ir/ubuntu/"
"http://mirror.faraso.org/ubuntu/"
"https://mirror.rasanegar.com/ubuntu/"
"https://mirrors.pardisco.co/ubuntu/"
"http://mirror.sbu.ac.ir/ubuntu/"

# ☁️ CDN
"https://cloudflare.cdn.ubuntu.com/ubuntu/"
"https://mirror.arvancloud.ir/ubuntu/"

# 🌍 GLOBAL
"https://archive.ubuntu.com/ubuntu/"
"http://archive.ubuntu.com/ubuntu/"
"http://security.ubuntu.com/ubuntu/"
"https://security.ubuntu.com/ubuntu/"
"http://mirror.ams1.nl.leaseweb.net/ubuntu/"
"http://mirror.serverion.com/ubuntu/"
"http://mirror.i3d.net/pub/ubuntu/"
"http://ftp.uni-stuttgart.de/ubuntu/"
"http://mirror.netcologne.de/ubuntu/"
"http://mirrors.kernel.org/ubuntu/"
"http://ubuntu.mirrors.ovh.net/ubuntu/"
"http://mirror.checkdomain.de/ubuntu/"
"http://ftp.fau.de/ubuntu/"
"http://mirror.init7.net/ubuntu/"
"http://mirror.in2p3.fr/pub/linux/ubuntu/"
"https://mirrors.tuna.tsinghua.edu.cn/ubuntu/"
"https://mirrors.aliyun.com/ubuntu/"
"https://mirrors.ustc.edu.cn/ubuntu/"
"https://mirrors.huaweicloud.com/ubuntu/"
"http://mirror.riken.jp/Linux/ubuntu/"
"http://ftp.jaist.ac.jp/pub/Linux/ubuntu/"
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
"94.140.14.14"
"94.140.15.15"
"76.76.2.0"
"208.67.222.222"
"208.67.220.220"
"185.222.222.222"
"45.90.28.0"
"45.90.30.0"
)

echo "🔍 تست Ping + TCP میرورها..."
echo ""

AVAILABLE_MIRRORS=()
PING_RESULTS=()
TCP_RESULTS=()

# ==================== Ping + TCP ====================

for MIRROR in "${MIRRORS[@]}"; do
    DOMAIN=$(echo "$MIRROR" | awk -F/ '{print $3}')
    echo -n "⏳ $DOMAIN ... "

    # Ping
    PING_OUTPUT=$(ping -c1 -W1 "$DOMAIN" 2>/dev/null || true)
    if echo "$PING_OUTPUT" | grep -q "time="; then
        MS=$(echo "$PING_OUTPUT" | grep 'time=' | sed -E 's/.*time=([0-9\.]+).*/\1/')
        PING_STATUS="✅ ${MS} ms"
    else
        PING_STATUS="❌ Fail"
        MS="-"
    fi

    # TCP test port 80
    START=$(date +%s%3N)
    if nc -z -w1 "$DOMAIN" 80 &>/dev/null; then
        END=$(date +%s%3N)
        TCP_MS=$((END-START))
        TCP_STATUS="✅ ${TCP_MS} ms"
    else
        TCP_STATUS="❌ Fail"
        TCP_MS="-"
    fi

    echo "$PING_STATUS | TCP $TCP_STATUS"

    if [[ "$MS" != "-" ]]; then
        AVAILABLE_MIRRORS+=("$MIRROR")
        PING_RESULTS+=("$MS")
        TCP_RESULTS+=("$TCP_MS")
    fi
done

if [ ${#AVAILABLE_MIRRORS[@]} -eq 0 ]; then
    echo ""
    echo "🚫 هیچ mirror در دسترس نیست."
    exit 1
fi

echo ""
echo "📋 Mirror های قابل انتخاب:"
for i in "${!AVAILABLE_MIRRORS[@]}"; do
    INDEX=$((i+1))
    echo "$INDEX) ${AVAILABLE_MIRRORS[$i]}   Ping: ${PING_RESULTS[$i]} ms | TCP: ${TCP_RESULTS[$i]} ms"
done

echo ""
read -p "👉 شماره mirror را انتخاب کنید: " CHOICE
if ! [[ "$CHOICE" =~ ^[0-9]+$ ]] || [ "$CHOICE" -lt 1 ] || [ "$CHOICE" -gt ${#AVAILABLE_MIRRORS[@]} ]; then
    echo "❌ انتخاب نامعتبر."
    exit 1
fi
WORKING_MIRROR=${AVAILABLE_MIRRORS[$((CHOICE-1))]}
echo ""
echo "✅ Mirror انتخاب شده: $WORKING_MIRROR"

# ==================== انتخاب DNS ====================
echo ""
echo "📋 Available DNS:"
for i in "${!DNS_LIST[@]}"; do
    INDEX=$((i+1))
    # Ping DNS
    PING_MS=$(ping -c1 -W1 "${DNS_LIST[$i]}" 2>/dev/null | grep 'time=' | sed -E 's/.*time=([0-9\.]+).*/\1/' || echo "-")
    echo "$INDEX) ${DNS_LIST[$i]} (${PING_MS} ms)"
done

read -p "👉 Select Primary DNS: " DNS1
read -p "👉 Select Secondary DNS: " DNS2

if ! [[ "$DNS1" =~ ^[0-9]+$ ]] || ! [[ "$DNS2" =~ ^[0-9]+$ ]] || [ "$DNS1" -lt 1 ] || [ "$DNS2" -lt 1 ] || [ "$DNS1" -gt ${#DNS_LIST[@]} ] || [ "$DNS2" -gt ${#DNS_LIST[@]} ] || [ "$DNS1" -eq "$DNS2" ]; then
    echo "❌ انتخاب DNS نامعتبر یا تکراری است."
    exit 1
fi

PRIMARY_DNS=${DNS_LIST[$((DNS1-1))]}
SECONDARY_DNS=${DNS_LIST[$((DNS2-1))]}

echo ""
echo "🔥 DNS Applied: $PRIMARY_DNS & $SECONDARY_DNS"

# ==================== UPDATE SOURCES ====================

sudo tee /etc/apt/sources.list >/dev/null <<EOF
deb $WORKING_MIRROR $UBUNTU_CODENAME main restricted universe multiverse
deb $WORKING_MIRROR $UBUNTU_CODENAME-updates main restricted universe multiverse
deb $WORKING_MIRROR $UBUNTU_CODENAME-backports main restricted universe multiverse
deb $WORKING_MIRROR $UBUNTU_CODENAME-security main restricted universe multiverse
EOF

# ==================== UPDATE DNS ====================

sudo tee /etc/resolv.conf >/dev/null <<EOF
nameserver $PRIMARY_DNS
nameserver $SECONDARY_DNS
EOF

# ==================== APT BOOST ====================

sudo tee /etc/apt/apt.conf.d/99godmode >/dev/null <<EOF
Acquire::Retries "3";
Acquire::http::Pipeline-Depth "5";
EOF

echo ""
echo "😈 GOD MODE COMPLETE!"
echo "📦 اجرا کنید:"
echo "sudo apt update && sudo apt upgrade -y"
