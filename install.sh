#!/usr/bin/env bash

set -e

# ===================== CHECK ROOT =====================
if [ "$EUID" -ne 0 ]; then
  echo "❌ Please run as root"
  exit 1
fi

# ===================== CONFIG =====================
UBUNTU_CODENAME="jammy"
RESOLV_BACKUP="/etc/resolv.conf.bak.$(date +%s)"

echo "========================================"
echo " 😈 NETWORK BOOSTER GOD MODE FIXED"
echo "========================================"
echo ""

# ===================== MIRRORS =====================
MIRRORS=(

# 🇮🇷 IRAN
https://ir.archive.ubuntu.com/ubuntu/
https://mirror.iranserver.com/ubuntu/
http://mirror.asiatech.ir/ubuntu/
https://ubuntu.shatel.ir/ubuntu/
https://ir.ubuntu.sindad.cloud/ubuntu/
http://mirrors.sharif.ir/ubuntu/
http://mirror.ut.ac.ir/ubuntu/
https://mirror.rasanegar.com/ubuntu/
https://mirror.pardisco.co/ubuntu/

# CDN
https://cloudflare.cdn.ubuntu.com/ubuntu/
https://mirror.arvancloud.ir/ubuntu/

# EUROPE FAST
http://mirror.i3d.net/pub/ubuntu/
http://mirror.ams1.nl.leaseweb.net/ubuntu/
http://mirror.serverion.com/ubuntu/
http://mirror.netcologne.de/ubuntu/
http://ftp.fau.de/ubuntu/
http://mirror.init7.net/ubuntu/
http://ftp.uni-stuttgart.de/ubuntu/
http://ubuntu.mirrors.ovh.net/ubuntu/
http://mirror.checkdomain.de/ubuntu/

# GLOBAL
https://archive.ubuntu.com/ubuntu/
http://mirrors.kernel.org/ubuntu/
http://mirror.pnl.gov/ubuntu/
http://mirror.math.princeton.edu/pub/ubuntu/
http://mirror.csclub.uwaterloo.ca/ubuntu/
http://mirror.clarkson.edu/ubuntu/
http://mirror.its.dal.ca/ubuntu/

# ASIA
https://mirrors.tuna.tsinghua.edu.cn/ubuntu/
https://mirrors.aliyun.com/ubuntu/
https://mirrors.ustc.edu.cn/ubuntu/
https://mirrors.huaweicloud.com/ubuntu/
http://mirror.riken.jp/Linux/ubuntu/
http://ftp.jaist.ac.jp/pub/Linux/ubuntu/

)

# ===================== DNS LIST =====================
DNS_LIST=(

# 🇮🇷 IRAN
178.22.122.100
185.51.200.2
194.225.70.26
10.202.10.10
185.55.226.26

# GLOBAL FAST
1.1.1.1
1.0.0.1
8.8.8.8
8.8.4.4
9.9.9.9
149.112.112.112
94.140.14.14
94.140.15.15
76.76.2.0
208.67.222.222
208.67.220.220
185.222.222.222
45.90.28.0
45.90.30.0

)

# ===================== BACKUP DNS =====================
if [ -f /etc/resolv.conf ]; then
  cp /etc/resolv.conf "$RESOLV_BACKUP"
  echo "📌 Backup DNS saved: $RESOLV_BACKUP"
fi

# ===================== HELPER =====================
ping_test() {
  TARGET=$1
  ping -c1 -W1 "$TARGET" 2>/dev/null | grep time= | sed -E 's/.*time=([0-9\.]+).*/\1/' || echo ""
}

# ===================== MIRROR TEST =====================
echo ""
echo "⚡ Scanning Mirrors..."

VALID_MIRRORS=()
MIRROR_MS=()

for M in "${MIRRORS[@]}"; do
  DOMAIN=$(echo $M | awk -F/ '{print $3}')
  MS=$(ping_test "$DOMAIN")
  if [ ! -z "$MS" ]; then
    echo "✅ $M (${MS} ms)"
    VALID_MIRRORS+=("$M")
    MIRROR_MS+=("$MS")
  else
    echo "❌ $M unreachable"
  fi
done

if [ ${#VALID_MIRRORS[@]} -eq 0 ]; then
  echo "🚫 No mirror reachable! Exiting..."
  exit 1
fi

echo ""
echo "📋 Available Mirrors:"
for i in "${!VALID_MIRRORS[@]}"; do
  echo "$((i+1))) ${VALID_MIRRORS[$i]} (${MIRROR_MS[$i]} ms)"
done

read -p "👉 Select Mirror: " MSEL
if ! [[ "$MSEL" =~ ^[0-9]+$ ]] || [ "$MSEL" -lt 1 ] || [ "$MSEL" -gt ${#VALID_MIRRORS[@]} ]; then
  echo "❌ Invalid choice. Using fastest mirror."
  MSEL=1
fi

SELECTED_MIRROR=${VALID_MIRRORS[$((MSEL-1))]}

# ===================== APPLY MIRROR =====================
sudo tee /etc/apt/sources.list >/dev/null <<EOF
deb $SELECTED_MIRROR $UBUNTU_CODENAME main restricted universe multiverse
deb $SELECTED_MIRROR $UBUNTU_CODENAME-updates main restricted universe multiverse
deb $SELECTED_MIRROR $UBUNTU_CODENAME-security main restricted universe multiverse
deb $SELECTED_MIRROR $UBUNTU_CODENAME-backports main restricted universe multiverse
EOF

echo "🔥 Mirror Applied: $SELECTED_MIRROR"

# ===================== DNS TEST =====================
echo ""
echo "⚡ Scanning DNS..."

VALID_DNS=()
DNS_MS=()

for D in "${DNS_LIST[@]}"; do
  MS=$(ping_test "$D")
  if [ ! -z "$MS" ]; then
    echo "✅ $D (${MS} ms)"
    VALID_DNS+=("$D")
    DNS_MS+=("$MS")
  else
    echo "❌ $D unreachable"
  fi
done

if [ ${#VALID_DNS[@]} -eq 0 ]; then
  echo "🚫 No DNS reachable! Restoring backup..."
  cp "$RESOLV_BACKUP" /etc/resolv.conf
  exit 1
fi

echo ""
echo "📋 Available DNS:"
for i in "${!VALID_DNS[@]}"; do
  echo "$((i+1))) ${VALID_DNS[$i]} (${DNS_MS[$i]} ms)"
done

read -p "👉 Select DNS: " DSEL
if ! [[ "$DSEL" =~ ^[0-9]+$ ]] || [ "$DSEL" -lt 1 ] || [ "$DSEL" -gt ${#VALID_DNS[@]} ]; then
  echo "❌ Invalid choice. Using fastest DNS."
  DSEL=1
fi

SELECTED_DNS=${VALID_DNS[$((DSEL-1))]}

echo "nameserver $SELECTED_DNS" | sudo tee /etc/resolv.conf >/dev/null

echo "🔥 DNS Applied: $SELECTED_DNS"

# ===================== APT BOOST =====================
echo 'Acquire::Retries "3";' | sudo tee /etc/apt/apt.conf.d/80-retries
echo 'Acquire::http::Pipeline-Depth "5";' | sudo tee /etc/apt/apt.conf.d/80-pipeline

echo ""
echo "😈 GOD MODE FIXED COMPLETE"
echo "Run: sudo apt update"
