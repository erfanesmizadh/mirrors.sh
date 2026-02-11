#!/usr/bin/env bash
set -euo pipefail

UBUNTU_CODENAME="jammy"

echo "📌 Ubuntu Ultimate Mirror Selector"
echo ""

# ==================== FULL MIRROR LIST ====================

MIRRORS=(

# 🇮🇷 IRAN MIRRORS
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

# ☁️ CDN / CLOUD
"https://cloudflare.cdn.ubuntu.com/ubuntu/"   # Cloudflare CDN
"https://mirror.arvancloud.ir/ubuntu/"        # ArvanCloud

# 🌍 GLOBAL FAST MIRRORS
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

echo "🔍 تست Ping میرورها..."
echo ""

AVAILABLE_MIRRORS=()

# ==================== PING TEST ====================

for MIRROR in "${MIRRORS[@]}"; do

    DOMAIN=$(echo "$MIRROR" | awk -F/ '{print $3}')
    echo -n "⏳ Ping $DOMAIN ... "

    if ping -c1 -W1 "$DOMAIN" >/dev/null 2>&1; then
        echo "✅ OK"
        AVAILABLE_MIRRORS+=("$MIRROR")
    else
        echo "❌ Fail"
    fi

done

# ==================== CHECK ====================

if [ ${#AVAILABLE_MIRRORS[@]} -eq 0 ]; then
    echo ""
    echo "🚫 هیچ mirror در دسترس نیست."
    exit 1
fi

echo ""
echo "📋 Mirror های قابل انتخاب:"
echo ""

INDEX=1
for MIRROR in "${AVAILABLE_MIRRORS[@]}"; do
    echo "$INDEX) $MIRROR"
    ((INDEX++))
done

echo ""
read -p "👉 شماره mirror را انتخاب کنید: " CHOICE

if ! [[ "$CHOICE" =~ ^[0-9]+$ ]] || [ "$CHOICE" -lt 1 ] || [ "$CHOICE" -gt ${#AVAILABLE_MIRRORS[@]} ]; then
    echo "❌ انتخاب نامعتبر."
    exit 1
fi

WORKING_MIRROR=${AVAILABLE_MIRRORS[$((CHOICE-1))]}

echo ""
echo "✅ Mirror انتخاب شده:"
echo "$WORKING_MIRROR"

# ==================== UPDATE SOURCES ====================

sudo tee /etc/apt/sources.list >/dev/null <<EOF
deb $WORKING_MIRROR $UBUNTU_CODENAME main restricted universe multiverse
deb $WORKING_MIRROR $UBUNTU_CODENAME-updates main restricted universe multiverse
deb $WORKING_MIRROR $UBUNTU_CODENAME-backports main restricted universe multiverse
deb $WORKING_MIRROR $UBUNTU_CODENAME-security main restricted universe multiverse
EOF

echo ""
echo "✅ sources.list آپدیت شد."
echo "📦 اجرا کنید:"
echo "sudo apt update"
