@echo off
set /p domain="Enter Domain: "
set OPENSSL_CONF=../conf/openssl.cnf

REM
REM Read the "cert-template.conf" file and replace all {{DOMAIN}} placeholders by the entered domain.
REM Write the result into a new file called "cert.conf".
REM
REM @see https://stackoverflow.com/questions/5273937/how-to-replace-substrings-in-windows-batch-file#20227248
REM
setlocal enabledelayedexpansion
set INTEXTFILE=cert-template.conf
set OUTTEXTFILE=cert.conf
set SEARCHTEXT={{DOMAIN}}
set REPLACETEXT=%domain%

if exist %OUTTEXTFILE% del /F %OUTTEXTFILE%
for /f "tokens=1,* delims=¶" %%A in ( '"findstr /n ^^ %INTEXTFILE%"') do (
   SET string=%%A
   for /f "delims=: tokens=1,*" %%a in ("!string!") do set "string=%%b"
   if  "!string!" == "" (
       echo.>>%OUTTEXTFILE%
   ) else (
      SET modified=!string:%SEARCHTEXT%=%REPLACETEXT%!
      echo !modified! >> %OUTTEXTFILE%
  )
)


REM
REM Create the target directory.
REM
if not exist .\%domain% mkdir .\%domain%


REM
REM Create the certificate and key files.
REM
..\bin\openssl req -config %OUTTEXTFILE% -new -sha256 -newkey rsa:2048 -nodes -keyout %domain%\server.key -x509 -days 365 -out %domain%\server.crt


REM
REM Delete the written file "cert.conf" as this file would only be used to create the certificate.
REM
if exist %OUTTEXTFILE% del /F %OUTTEXTFILE%


echo.
echo -----
echo The certificate was provided.
echo.
pause