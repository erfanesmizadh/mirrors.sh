#!/usr/bin/env bash
set -euo pipefail

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

  # 🇩🇪 GERMANY
  "http://ftp.tu-chemnitz.de/pub/linux/ubuntu/"
  "http://ftp.uni-stuttgart.de/ubuntu/"
  "http://ftp.halifax.rwth-aachen.de/ubuntu/"
  "http://mirror.netcologne.de/ubuntu/"
  "http://ubuntu.mirror.garr.it/ubuntu/"
  "http://mirror.checkdomain.de/ubuntu/"
  "http://ftp.fau.de/ubuntu/"
  "http://mirror.kumi.systems/ubuntu/"
  "http://mirror.init7.net/ubuntu/"

  # 🇫🇷 FRANCE
  "http://mirror.in2p3.fr/pub/linux/ubuntu/"
  "http://ubuntu.mirrors.ovh.net/ubuntu/"
  "http://mirror.ubuntu.ikoula.com/ubuntu/"
  "http://mirror.pnl.gov/ubuntu/"

  # 🇳🇱 NETHERLANDS
  "http://ftp.nluug.nl/os/Linux/distr/ubuntu/"
  "http://mirror.ams1.nl.leaseweb.net/ubuntu/"
  "http://mirror.serverion.com/ubuntu/"
  "http://mirror.i3d.net/pub/ubuntu/"

  # 🇬🇧 UK
  "http://mirror.bytemark.co.uk/ubuntu/"
  "http://mirror.ox.ac.uk/sites/archive.ubuntu.com/ubuntu/"
  "http://ubuntu.mirror.anlx.net/ubuntu/"

  # 🇺🇸 USA
  "http://mirror.math.princeton.edu/pub/ubuntu/"
  "http://mirror.csclub.uwaterloo.ca/ubuntu/"
  "http://ubuntu.mirrors.tds.net/ubuntu/"
  "http://mirrors.kernel.org/ubuntu/"
  "http://mirror.pnl.gov/ubuntu/"
  "http://mirror.anl.gov/pub/ubuntu/"
  "http://mirror.syr.edu/pub/ubuntu/"
  "http://mirror.us.leaseweb.net/ubuntu/"
  "http://mirror.clarkson.edu/ubuntu/"

  # 🇨🇦 CANADA
  "http://mirror.its.dal.ca/ubuntu/"
  "http://mirror.csclub.uwaterloo.ca/ubuntu/"

  # 🇯🇵 JAPAN
  "http://ftp.jaist.ac.jp/pub/Linux/ubuntu/"
  "http://ftp.tsukuba.wide.ad.jp/Linux/ubuntu/"
  "http://mirror.riken.jp/Linux/ubuntu/"
  "http://ubuntu-mirror.kagoya.net/ubuntu/"

  # 🇨🇳 CHINA
  "https://mirrors.tuna.tsinghua.edu.cn/ubuntu/"
  "https://mirrors.aliyun.com/ubuntu/"
  "https://mirrors.ustc.edu.cn/ubuntu/"
  "https://mirrors.huaweicloud.com/ubuntu/"

  # 🇸🇬 SINGAPORE
  "http://mirror.nus.edu.sg/ubuntu/"
  "http://download.nus.edu.sg/mirror/ubuntu/"
)

echo "🔍 اسکن میرورهای Ubuntu 22.04 ($UBUNTU_CODENAME)..."
echo ""

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
  echo ""
  echo "🚫 هیچ میروری در دسترس نیست"
  exit 1
fi

echo ""
echo "🛠 تنظیم /etc/apt/sources.list با میرور:"
echo "👉 $WORKING_MIRROR"
echo ""

sudo tee /etc/apt/sources.list >/dev/null <<EOF
deb $WORKING_MIRROR $UBUNTU_CODENAME main restricted universe multiverse
deb $WORKING_MIRROR $UBUNTU_CODENAME-updates main restricted universe multiverse
deb $WORKING_MIRROR $UBUNTU_CODENAME-backports main restricted universe multiverse
deb $WORKING_MIRROR $UBUNTU_CODENAME-security main restricted universe multiverse
EOF

echo "✅ انجام شد"
echo "📦 حالا اجرا کن:"
echo "sudo apt update"
