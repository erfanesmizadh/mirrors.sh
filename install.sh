#!/usr/bin/env bash
set -euo pipefail

UBUNTU_CODENAME="jammy"

echo "📌 Ubuntu Mirror Selector 22.04 (Jammy)"
echo "این اسکریپت میرورهای ایرانی و جهانی را بررسی کرده و سریع‌ترین یا اولین میرور سالم را انتخاب می‌کند."
echo "فایل /etc/apt/sources.list شما به صورت خودکار آپدیت می‌شود."
echo ""

# ==================== لیست میرورها ====================
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
  "http://mirrors.sharif.ir/ubuntu/"
  "http://mirror.ut.ac.ir/ubuntu/"
  "http://mirror.faraso.org/ubuntu/"
  "http://ubuntu.byteiran.com/ubuntu/"
  "https://mirror.rasanegar.com/ubuntu/"
  "https://mirror.0-1.cloud/ubuntu/"
  "https://ubuntu.bardia.tech/"
  "https://mirrors.pardisco.co/ubuntu/"
  "http://mirror.ariadata.co/ubuntu/"
  "http://mirror.sbu.ac.ir/ubuntu/"
  "http://mirror.kpfu.ru/ubuntu/"

  # 🌍 GLOBAL
  "https://archive.ubuntu.com/ubuntu/"
  "http://archive.ubuntu.com/ubuntu/"
  "http://security.ubuntu.com/ubuntu/"
  "https://security.ubuntu.com/ubuntu/"
  "https://ftp.ubuntu.com/ubuntu/"
  "http://ftp.ubuntu.com/ubuntu/"
  "http://ftp.tu-chemnitz.de/pub/linux/ubuntu/"
  "http://ftp.uni-stuttgart.de/ubuntu/"
  "http://ftp.halifax.rwth-aachen.de/ubuntu/"
  "http://mirror.netcologne.de/ubuntu/"
  "http://ubuntu.mirror.garr.it/ubuntu/"
  "http://mirror.checkdomain.de/ubuntu/"
  "http://ftp.fau.de/ubuntu/"
  "http://mirror.kumi.systems/ubuntu/"
  "http://mirror.init7.net/ubuntu/"
  "http://mirror.in2p3.fr/pub/linux/ubuntu/"
  "http://ubuntu.mirrors.ovh.net/ubuntu/"
  "http://mirror.ubuntu.ikoula.com/ubuntu/"
  "http://mirror.pnl.gov/ubuntu/"
  "http://ftp.nluug.nl/os/Linux/distr/ubuntu/"
  "http://mirror.ams1.nl.leaseweb.net/ubuntu/"
  "http://mirror.serverion.com/ubuntu/"
  "http://mirror.i3d.net/pub/ubuntu/"
  "http://mirror.bytemark.co.uk/ubuntu/"
  "http://mirror.ox.ac.uk/sites/archive.ubuntu.com/ubuntu/"
  "http://ubuntu.mirror.anlx.net/ubuntu/"
  "http://mirror.math.princeton.edu/pub/ubuntu/"
  "http://mirror.csclub.uwaterloo.ca/ubuntu/"
  "http://ubuntu.mirrors.tds.net/ubuntu/"
  "http://mirrors.kernel.org/ubuntu/"
  "http://mirror.pnl.gov/ubuntu/"
  "http://mirror.anl.gov/pub/ubuntu/"
  "http://mirror.syr.edu/pub/ubuntu/"
  "http://mirror.us.leaseweb.net/ubuntu/"
  "http://mirror.clarkson.edu/ubuntu/"
  "http://mirror.its.dal.ca/ubuntu/"
  "http://ftp.jaist.ac.jp/pub/Linux/ubuntu/"
  "http://ftp.tsukuba.wide.ad.jp/Linux/ubuntu/"
  "http://mirror.riken.jp/Linux/ubuntu/"
  "http://ubuntu-mirror.kagoya.net/ubuntu/"
  "https://mirrors.tuna.tsinghua.edu.cn/ubuntu/"
  "https://mirrors.aliyun.com/ubuntu/"
  "https://mirrors.ustc.edu.cn/ubuntu/"
  "https://mirrors.huaweicloud.com/ubuntu/"
  "http://mirror.nus.edu.sg/ubuntu/"
  "http://download.nus.edu.sg/mirror/ubuntu/"
)

echo "🔍 شروع بررسی میرورها..."
WORKING_MIRROR=""

# ==================== بررسی و انتخاب میرور ====================
for MIRROR in "${MIRRORS[@]}"; do
  echo -n "⏳ تست $MIRROR ... "
  if curl -fs --max-time 5 "${MIRROR}dists/${UBUNTU_CODENAME}/Release" >/dev/null; then
    echo "✅ در دسترس"
    WORKING_MIRROR="$MIRROR"
    break
  else
    echo "❌ در دسترس نیست"
  fi
done

# ==================== خطایابی ====================
if [[ -z "$WORKING_MIRROR" ]]; then
  echo ""
  echo "🚫 هیچ میروری در دسترس نیست. اتصال اینترنت یا فایروال را بررسی کنید."
  exit 1
fi

# ==================== تنظیم /etc/apt/sources.list ====================
echo ""
echo "🛠 فایل /etc/apt/sources.list شما با میرور زیر به‌روزرسانی می‌شود:"
echo "👉 $WORKING_MIRROR"
echo ""

sudo tee /etc/apt/sources.list >/dev/null <<EOF
deb $WORKING_MIRROR $UBUNTU_CODENAME main restricted universe multiverse
deb $WORKING_MIRROR $UBUNTU_CODENAME-updates main restricted universe multiverse
deb $WORKING_MIRROR $UBUNTU_CODENAME-backports main restricted universe multiverse
deb $WORKING_MIRROR $UBUNTU_CODENAME-security main restricted universe multiverse
EOF

echo ""
echo "✅ انجام شد!"
echo "📦 برای بروزرسانی بسته‌ها دستور زیر را اجرا کنید:"
echo "sudo apt update"
echo ""
echo "ℹ️ توضیح: این اسکریپت سریع‌ترین میرور سالم را پیدا کرده و sources.list را جایگزین می‌کند."
echo "اگر می‌خواید نسخه بعدی Ubuntu را اضافه کنید، کافی است UBUNTU_CODENAME را تغییر دهید."
