# Ubuntu GOD MODE Mirror & DNS Selector

📌 **Ultimate Bash Script for Ubuntu 22.04+ (Jammy)**  

این اسکریپت به شما اجازه می‌دهد سریع‌ترین **mirror** و **دو DNS** برای سرور مجازی خود انتخاب کنید و APT را بهینه‌سازی کنید.  

---

## ⚡ ویژگی‌ها

- **Ping + TCP** برای تمامی mirror ها  
- انتخاب **Mirror** به صورت دستی با نمایش ms  
- انتخاب **دو DNS جداگانه** برای redundancy  
- فعال‌سازی **APT Boost**:
  - `Acquire::Retries "3";`
  - `Acquire::http::Pipeline-Depth "5";`
- ساده و امن، مناسب VPS و سرورهای cloud  
- قابل استفاده روی Ubuntu 22.04 (Jammy) و بالاتر  

---

## 🛠️ نصب و اجرا

1. دانلود اسکریپت:

```bash
wget -O ~/ubuntu-godmode.sh https://raw.githubusercontent.com/erfanesmizadh/mirrors.sh/main/install.sh
