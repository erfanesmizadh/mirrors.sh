# 🚀 Ubuntu Ultimate Mirror Selector

یک اسکریپت Bash حرفه‌ای برای انتخاب سریع‌ترین Ubuntu Mirror با تست Ping و انتخاب دستی.

---

## ✨ Features

✅ تست Ping تمام mirror ها  
✅ نمایش latency واقعی (ms)  
✅ نمایش فقط mirror های در دسترس  
✅ انتخاب دستی mirror با شماره  
✅ پشتیبانی از mirror های:

- 🇮🇷 ایران (IranServer, Asiatech, Shatel, Sindad, etc)
- ☁️ CDN (Cloudflare, ArvanCloud)
- 🌍 Global Fast Mirrors (Leaseweb, OVH, Kernel, Tsinghua, HuaweiCloud, etc)

✅ جایگزینی خودکار `/etc/apt/sources.list`

---

## 📦 Requirements

- Ubuntu 22.04 (Jammy)
- bash
- curl
- ping

---

## ⚡ Installation

دانلود و اجرا:

```bash
wget https://raw.githubusercontent.com/erfanesmizadh/install.sh
chmod +x install.sh
sudo ./install.sh
