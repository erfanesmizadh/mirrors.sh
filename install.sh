#!/usr/bin/env bash

set -e

UBUNTU_CODENAME="jammy"

echo "🔥 NETWORK BOOSTER GOD MODE MAX++"
echo ""

####################################
# MIRROR MASTER LIST (FULL GLOBAL)
####################################

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

####################################
# DNS MASTER LIST (FULL)
####################################

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

####################################
# FAST PING FUNCTION
####################################

ping_test() {
ping -c1 -W1 $1 2>/dev/null | grep time= | sed -E 's/.*time=([0-9\.]+).*/\1/'
}

####################################
# MIRROR SCAN
####################################

echo "⚡ Scanning Mirrors..."

RESULTS=$(for M in "${MIRRORS[@]}"; do
DOMAIN=$(echo $M | awk -F/ '{print $3}')
MS=$(ping_test $DOMAIN)
[ ! -z "$MS" ] && echo "$MS|$M"
done | sort -n)

FASTEST=$(echo "$RESULTS" | head -n1 | cut -d'|' -f2)

echo "🔥 Fastest Mirror:"
echo "$FASTEST"

sudo tee /etc/apt/sources.list >/dev/null <<EOF
deb $FASTEST $UBUNTU_CODENAME main restricted universe multiverse
deb $FASTEST $UBUNTU_CODENAME-updates main restricted universe multiverse
deb $FASTEST $UBUNTU_CODENAME-security main restricted universe multiverse
EOF

####################################
# DNS SCAN
####################################

echo ""
echo "⚡ Scanning DNS..."

DNS_SORT=$(for D in "${DNS_LIST[@]}"; do
MS=$(ping_test $D)
[ ! -z "$MS" ] && echo "$MS|$D"
done | sort -n)

FASTEST_DNS=$(echo "$DNS_SORT" | head -n1 | cut -d'|' -f2)

echo "🔥 Fastest DNS: $FASTEST_DNS"

echo "nameserver $FASTEST_DNS" | sudo tee /etc/resolv.conf >/dev/null

####################################
# APT BOOST
####################################

echo 'Acquire::Retries "3";' | sudo tee /etc/apt/apt.conf.d/80-retries
echo 'Acquire::http::Pipeline-Depth "5";' | sudo tee /etc/apt/apt.conf.d/80-pipeline

echo ""
echo "😈 GOD MODE MAX++ COMPLETE"
echo "Run: sudo apt update"
