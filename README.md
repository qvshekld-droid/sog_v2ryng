SOG Panel — X-UI (Heimdall) + Nginx Reverse Proxy + Subscription Page

برای آموزش کار با پنل لطفا این ویدیو تماشا شود 
https://m.youtube.com/watch?v=xp-FuS5LTk4
لایک و فالو و کامنت فراموش نشه

پنل مدیریت کاربران Heimdall (نسخه‌ی بهبودیافته‌ی 3x-ui) به همراه پروکسی معکوس Nginx و صفحه‌ی اشتراک اختصاصی، همگی در یک کانتینر Docker با برند SOG.
پنل، ساب‌اسکریپشن و اینباند VLESS/WebSocket از طریق یک پورت واحد (همان 3000 که Nginx روی آن گوش می‌دهد) در دسترس قرار می‌گیرند.

ویژگی‌ها

· پنل ادمین با برند SOG روی پورت ۳۰۰۰
· جایگزینی خودکار نام‌ها و لینک‌های Heimdall با SOG
· تشخیص هوشمند کلاینت‌های VPN و تحویل لینک خام ساب به آن‌ها
· صفحه‌ی گرافیکی زیبا با فونت فارسی وزیرمتن، QR کد، نوار مصرف، تاریخ تمدید شمسی و تفکیک پروتکل‌ها برای مرورگر
· پشتیبانی از VLESS، VMESS، Trojan، Shadowsocks، Hysteria2 و TUIC
· تنظیم خودکار Timezone روی Asia/Tehran
· لینک‌های پشتیبانی تلگرام: ادمین @shanduzgil و کانال @sog_v2ryng

درباره‌ی دیتابیس

پنل به‌صورت پیش‌فرض از SQLite استفاده می‌کند (نیازی به Postgres نیست). این نسخه با همان تنظیم ساده و بدون وابستگی اضافی ارائه شده است.

مراحل دیپلوی روی Railway

۱. ساخت ریپازیتوری

یک ریپازیتوری جدید در گیت‌هاب بسازید و این چهار فایل را در ریشه‌ی آن قرار دهید:

· Dockerfile
· nginx.conf.template
· start.sh
· sub-view.html

۲. دیپلوی در Railway

1. New Project → Deploy from GitHub repo و ریپازیتوری خود را انتخاب کنید.
2. Railway به‌طور خودکار Dockerfile را تشخیص داده و ایمیج را بیلد می‌کند.
3. پس از پایان بیلد، به Settings → Networking بروید و Generate Domain بزنید.
4. دقت کنید که Target Port روی 3000 تنظیم شده باشد (Nginx روی این پورت گوش می‌دهد).

۳. اولین ورود به پنل

```
https://دامنه‌شما.up.railway.app/managepanel/
```

نام کاربری و رمز عبور پیش‌فرض admin / admin است. حتماً در اولین ورود آن را تغییر دهید.

۴. ساخت Inbound

فیلد مقدار
Protocol VLESS
Listen Port 8080 (این عدد ثابت است)
Listen IP خالی یا 0.0.0.0
Network ws
Security none
Path هر مسیر دلخواه، مثلاً /cdn

۵. ساخت لینک کلاینت

```
vless://UUID@دامنه‌شما.up.railway.app:443?encryption=none&security=tls&sni=دامنه‌شما.up.railway.app&fp=chrome&type=ws&host=دامنه‌شما.up.railway.app&path=%2Fcdn#MyConfig
```

۶. لینک ساب‌اسکریپشن

مسیر ساب به‌صورت خودکار زیر همین دامنه در دسترس است:

```
https://دامنه‌شما.up.railway.app/sub/USER_SUB_ID
```

· کلاینت‌های VPN لینک خام دریافت می‌کنند.
· مرورگرها صفحه‌ی گرافیکی SOG را با QR، مصرف و تاریخ تمدید می‌بینند.

تست سریع

```
https://دامنه‌شما.up.railway.app/managepanel/   ← باید پنل را نشان دهد
https://دامنه‌شما.up.railway.app/cdn            ← باید "Bad Request" بدهد (یعنی به Xray رسیده)
https://دامنه‌شما.up.railway.app/sub/test       ← صفحه‌ی ساب (در صورت وجود کانفیگ)
```

نکات مهم

· تمام تنظیمات پنل (کاربران، اینباندها) درون کانتینر و روی فایل‌سیستم ذخیره می‌شود. برای حفظ داده‌ها پس از Redeploy، از بخش Volumes در Railway یک Volume به مسیر /etc/x-ui متصل کنید.
· این نسخه فقط با SQLite کار می‌کند. در صورت نیاز به Postgres باید Dockerfile و start.sh را سفارشی کنید.
· برای شخصی‌سازی بیشتر (مثلاً تغییر نام برند یا لینک‌های پشتیبانی)، فایل sub-view.html را ویرایش کنید.

---

SOG Panel — ساخته‌شده برای عملکرد پایدار و تجربه‌ی کاربری بهتر.
