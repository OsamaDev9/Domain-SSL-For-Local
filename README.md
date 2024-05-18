<div style="direction: rtl;">

# إعداد `نطاق(Domain)` و `شهادة(SSL)` على السيرفر المحلي XAMPP

لتتمكن من البرمجة بشكل صحيح وتجربة ما تريد بدون قيود تمنعك من اختبار عملك وفحصه قبل رفعه ونشره على الإنترنت، يمكنك تفعيل الخدمات المتوفرة على الاستضافة في سيرفر محلي باتباع الخطوات التالية:

### 1: تحميل الملفات الضرورية
- [cert-template.conf](https://github.com/OsamaDev9/Domain-SSL-For-Local/blob/main/cert-template.conf)
- [make-cert.bat](https://github.com/OsamaDev9/Domain-SSL-For-Local/blob/main/make-cert.bat)

### 2: إنشاء مجلد للملفات
أنشئ مجلد باسم `crt` في المسار: `xampp\apache\` ثم قم بإضافة الملفين اللذين قمت بتحميلهما إلى هذا المجلد. ستكون الملفات بالشكل التالي:

```
📂xampp\apache\crt
 ┗📜cert-template.conf
 ┗📜make-cert.bat
```

### 3: تشغيل ملف `make-cert.bat`
قم بتشغيل ملف `make-cert.bat` **كمسؤول** واتبع التعليمات التالية:
- يمكنك كتابة النطاق الذي ترغب به وتخطي باقي البيانات بالضغط على `Enter`.

#### مثال :
```
Enter Domain: Osama.net
You are about to be asked to enter information that will be incorporated into your certificate request.
What you are about to enter is what is called a Distinguished Name or a DN.
There are quite a few fields but you can leave some blank
For some fields there will be a default value,
If you enter '.', the field will be left blank.
-----
Country Name (2 letter code) [US]:YE
State or Province Name (full name) [NY]:Yemen
Locality Name (eg, city) [New York]:Sana'a
Organization Name (eg, company) [Example, LLC]:OsYE
Common Name (e.g. server FQDN or YOUR name) [Osama.net]:
Email Address [test@example.com]:admin@osama.net

-----
The certificate was provided.

Press any key to continue . . .
```

### البيانات المستخدمة في المثال:
1. النطاق: Osama.net
2. اختصار الدولة: YE
3. الدولة: Yemen
4. المدينة: Sana'a
5. الشركة: OsYE
6. السيرفر: Osama.net
7. البريد الإلكتروني: admin@osama.net

### 4: إعداد الشهادة
لاحظ أنه تم إنشاء مجلد باسم النطاق الذي اخترته `Osama.net` ويحتوي على ملفين:

```
📂xampp\apache\crt\Osama.net
 ┗📜server.crt
 ┗📜server.key
```

قم بتشغيل ملف `server.crt` واتبع التعليمات التالية:

1. Install Certificate
2. Local Machine
3. Next
4. Place all certificates in the following store.
5. Browse...
6. Trusted Root Certification Authorities Store
7. OK
8. Next
9. Finish > OK > OK

### 5: تعديل إعدادات Apache
توجه إلى المسار `xampp\apache\conf\extra\` وافتح ملف `httpd-vhosts.conf`. انسخ الكود التالي والصقه في نهاية الملف وأجرِ التعديلات المناسبة لمشروعك:

```bash
<VirtualHost *:80>
  DocumentRoot "D:/xampp/htdocs/TestSite/name-app/"
  ServerName Osama.net
</VirtualHost>

<VirtualHost *:443>
  DocumentRoot "D:/xampp/htdocs/TestSite/name-app/"
  ServerName Osama.net
  SSLEngine on
  SSLCertificateFile "crt/Osama.net/server.crt"
  SSLCertificateKeyFile "crt/Osama.net/server.key"
  ErrorLog "logs/Osama.net-error.log"
  CustomLog "logs/Osama.net-access.log" common
</VirtualHost>
```

استبدل المسار `D:/xampp/htdocs/TestSite/name-app/` بمسار مشروعك واستبدل النطاق `Osama.net` بنطاق مشروعك.

### 6: اخيرا تعيين النطاق في بيئة الجهاز
توجه الى المسار التالي `C:\Windows\System32\drivers\etc` و افتح ملف `hosts` وقم بإضافة النطاق مع IP الافتراضي لـ XAMPP بالشكل التالي :

```
127.0.0.1      Osama.net
```

---------------
## تنبيه مهم
تأكد من البورتات في `VirtualHost` وانها متطابقه مع إعدادات Apache في XAMPP يجب أن تكون متطابقة بالشكل التالي:

| httpd-vhosts.conf   |           Xampp|                |
|---------------------|----------------|----------------|
| `VirtualHost *:80`  | httpd-ssl.conf |  httpd.conf    |
| `VirtualHost *:443` | `Listen:443`   | `Listen:80`    |


---------------
### ملاحظه :

إذا كنت تعمل على مشروع Laravel فتأكد من عمل هذا الإجراء :

### تعديل إعدادات المشروع
بعد الانتهاء من النقاط السابقة، افتح ملف `.env` وقم بتعديل الإعدادات التالية بما يتناسب مع مشروعك:

```php
APP_NAME="name-app"        // اسم المشروع
APP_URL=http://Osama.net   // نطاق المشروع
DB_DATABASE= "OsDB"        // قاعدة البيانات
```
احفظ الملف `.env`.

____

الآن قم بإيقاف تشغيل `Apache` في `Xampp` واعد تشغيله مره اخرى
ثم افتح المتصفح واكتب نطاقك لتصفحك موقعك 
