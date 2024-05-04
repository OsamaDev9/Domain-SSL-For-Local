# Domain-SSL-For-Local
Setting a domain and SSL on the local XAMPP server 

## إنشاء `Domain` و تفعيل `SSL` على السيرفر المحلي Xampp 
- لتتمكن من البرمجة بشكل صحيح و تجربة ماتريد بدون قيود تمنعك من إختبار عملك وفحصة قبل رفعه ونشره على الانترنت يجب عليك تفعيل الخدمات المتوفرة على الاستضافة في سيرفر محلي يمكنك عمل ذلك بالخطوات التالية: 
1. حمل الملفات التالية:
   - [cert-template.conf](https://github.com/OsamaDev9/Domain-SSL-For-Local/blob/main/cert-template.conf)
   - [make-cert.bat](https://github.com/OsamaDev9/Domain-SSL-For-Local/blob/main/make-cert.bat)
2. ثم أنشئ مجلد بإسم `crt` في المسار : `xampp\apache\crt` ثم قم بإضافة الملفين الذي قمت بتحميلهما الى هذا المجلد .
ستكون الملفات بهذا الشكل : 

```pss
📂xampp\apache\crt
 ┗📜cert-template.conf
 ┗📜make-cert.bat
```
3. قم بتشغيل ملف `make-cert.bat` كمسؤول واتبع التعليمات التالية :
    - يمكنك كتابة النطاق الذي ترغب به وتخطي باقي البيانات بالضغط على `Enter` 
_________

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
Locality Name (eg, city) [New York]:sana'a
Organization Name (eg, company) [Example, LLC]:OsYE
Common Name (e.g. server FQDN or YOUR name) [Osama.net]:
Email Address [test@example.com]:admin@osama.net

-----
The certificate was provided.

Press any key to continue . . .
```
- هذه هي البيانات التي قمت بإدخالها في المثال اعلاه: 
- 1. النطاق الذي تريده كرابط لموقعك: Osama.net
- 2. إختصار دولتك : YE
- 3. الدولة: Yemen
- 4. المدينة : Sana'a
- 5. الشركة : OsYE
- 6. السيرفر : Osama.net
- 7. بريد : admin@osama.net

_________

اغلق شاشة `cmd` 

لاحظ انه تم إنشاء مجلد بإسم النطاق الذي اخترته `Osama.net` و يحتوي على ملفين 
```bash
📂xampp\apache\crt\Osama.net
 ┗📜server.crt
 ┗📜server.key
```
- الان قم بتشغيل ملف `server.crt`واتبع التعليمات التالية :

```
> Install Certificate
> Local Machine
> Next
> Place all certificates in the following store.
> Browse... 
> Trusted Root Certification Authorities Store
> OK
> Next
> Finish > OK > OK
```
بعد الانتهاء من التحديثات السابقة قم بفتح المشروع في محرر الأكواد الذي تستخدمه ثم افتح ملف `.env`

قم بتعديل الإعدادات التالية بما تتناسب مع مشروعك وضع النطاق الذي قمت بإنشائه في APP_URL

```php
APP_NAME="name-app"        | اسم المشروع
APP_URL=http://Osama.net   | نطاق المشروع
DB_DATABASE= "OsDB"        | قاعدة البيانات
```
- قم بحفظ الملف `.env`
- توجه الى المسار `xampp\apache\conf\extra\` و افتح ملف `httpd-vhosts.conf`
انسخ الكود التالي و الصق في نهاية الملف و قم بإجراء تعديل يناسب مشروعك:

```bash
<VirtualHost *:80>
  DocumentRoot "D:/xampp/htdocs/LaravelSite/name-app/public"
  ServerName Osama.net
</VirtualHost>

<VirtualHost *:443>
  DocumentRoot "D:/xampp/htdocs/LaravelSite/name-app/public"
  ServerName Osama.net
  SSLEngine on
  SSLCertificateFile "crt/Osama.net/server.crt"
  SSLCertificateKeyFile "crt/Osama.net/server.key"
  ErrorLog "logs/Osama.net-error.log"
  CustomLog "logs/Osama.net-access.log" common
</VirtualHost>
```
_____________ 


- إستبدل المسار `D:/xampp/htdocs/LaravelSite/name-app/public` بمسار مشروعك
- استبدل النطاق `Osama.net` بنطاق مشروعك

## ⚠️ تنبية :-
- تأكد من تطابق البورتات في `VirtualHost` مع إعدادات Apache في Xampp , يجب ان تكون متطابقة
بالشكل التالي


| httpd-vhosts.conf   |               Xampp|            |
|---------------------|----------------|----------------|
| `VirtualHost *:80`  | httpd-ssl.conf |  httpd.conf    |
| `VirtualHost *:443` | `Listen:443`   | `Listen:80`    |


_____________
