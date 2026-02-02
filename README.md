# Ubuntu Mirror Auto Selector 🇮🇷🌍

![Language](https://img.shields.io/badge/language-Bash-blue)
![Ubuntu](https://img.shields.io/badge/Ubuntu-22.04-brightgreen)
![Status](https://img.shields.io/badge/status-Active-green)

اسکریپت Bash برای انتخاب خودکار سریع‌ترین میرور Ubuntu  
شامل میرورهای **ایرانی و خارجی** – مناسب VPS ایران و سرورهای خارجی

---

## ✨ ویژگی‌ها
- اسکن بیش از 100 میرور ایرانی و جهانی  
- اولویت با میرورهای ایرانی  
- تست واقعی فایل `Release`  
- آپدیت خودکار `/etc/apt/sources.list`  
- سازگار با Ubuntu 22.04 (Jammy)  
- نمایش توضیحات مرحله به مرحله هنگام اجرا  
- مناسب VPS و سرورهای اختصاصی  

---

## 🚀 نصب و اجرا

### روش 1: اجرای مستقیم از گیت‌هاب (ساده‌ترین روش)
برای اجرای مستقیم اسکریپت کافی است دستور زیر را در ترمینال خود کپی و اجرا کنید:

```bash
bash <(curl -fsSL https://raw.githubusercontent.com/erfanesmizadh/mirrors.sh/main/install.sh)



git clone https://github.com/erfanesmizadh/mirrors.sh.git
cd mirrors.sh
chmod +x install.sh
sudo ./install.sh
