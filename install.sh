#!/bin/bash
set -e

UBUNTU_CODENAME="jammy"

MIRRORS=(
  # 🇮🇷 IRAN
  "https://ir.archive.ubuntu.com/ubuntu/"
  "https://mirror.iranserver.com/ubuntu/"
  "http://mirror.iranserver.com/ubuntu/"
  "https://ubuntu.shatel.ir/ubuntu/"
  "http://mirror.asiatech.ir/ubuntu/"
  "https://ubuntu-mirror.kimiahost.com/"
  "https://ubuntu.hostiran.ir/ubuntuarchive/"
  "https://archive.ubuntu.petiak.ir/ubuntu/"
  "https://ir.ubuntu.sindad.cloud/ubuntu/"
  "http://linuxmirrors.ir/pub/ubuntu/"
  "http://repo.iut.ac.ir/repo/ubuntu/"
  "http://repo.iut.ac.ir/repo/Ubuntu/"
  "http://mirrors.sharif.ir/ubuntu/"
  "http://mirror.ut.ac.ir/ubuntu/"
  "http://mirror.faraso.org/ubuntu/"
  "http://ubuntu.byteiran.com/ubuntu/"
  "https://mirror.rasanegar.com/ubuntu/"
  "https://mirror.0-1.cloud/ubuntu/"
  "https://ubuntu.bardia.tech/"
  "https://mirrors.pardisco.co/ubuntu/"

  # 🌍 GLOBAL
  "http://archive.ubuntu.com/ubuntu/"
  "https://archive.ubuntu.com/ubuntu/"
  "http://security.ubuntu.com/ubuntu/"
  "https://ftp.ubuntu.com/ubuntu/"
  "http://ftp.ubuntu.com/ubuntu/"
  "http://ftp.tu-chemnitz.de/pub/linux/ubuntu/"
  "http://ftp.uni-stuttgart.de/ubuntu/"
  "http://mirror.math.princeton.edu/pub/ubuntu/"
  "http://ubuntu.mirrors.tds.net/ubuntu/"
  "http://mirror.csclub.uwaterloo.ca/ubuntu/"
)

echo "🔍 اسکن میرورهای Ubuntu 22.04 ($UBUNTU_CODENAME)..."

WORKING_MIRROR=""

for MIRROR in "${MIRRORS[@]}"; do
  echo -n "⏳ تست $MIRROR ... "
  if curl -fs --max-time 5 "${MIRROR}dists/${UBUNTU_CODENAME}/Release" >/dev/null; then
    echo "✅ OK"
    WORKING_MIRROR="$MIRROR"
    break
  else
    echo "❌ Fail"
  fi
done

if [[ -z "$WORKING_MIRROR" ]]; then
  echo "🚫 هیچ میروری در دسترس نیست"
  exit 1
fi

echo ""
echo "🛠 تنظیم sources.list با میرور:"
echo "👉 $WORKING_MIRROR"

sudo tee /etc/apt/sources.list >/dev/null <<EOF
deb $WORKING_MIRROR $UBUNTU_CODENAME main restricted universe multiverse
deb $WORKING_MIRROR $UBUNTU_CODENAME-updates main restricted universe multiverse
deb $WORKING_MIRROR $UBUNTU_CODENAME-backports main restricted universe multiverse
deb $WORKING_MIRROR $UBUNTU_CODENAME-security main restricted universe multiverse
EOF

echo ""
echo "✅ انجام شد"
echo "📦 حالا اجرا کن:"
echo "sudo apt update"
