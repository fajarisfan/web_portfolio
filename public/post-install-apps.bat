@echo off
:: ==========================================================
::  POST INSTALL APPS - Download & Install
::  Win 10/11: pakai winget (built-in)
::  Win 7/8:   fallback ke direct download + silent install
:: ==========================================================

:apps_menu
cls
echo.
echo  =========================================================
echo     P O S T   I N S T A L   A P P S
echo     Download ^& Install Otomatis
echo  =========================================================
echo.
echo   Detected: %WINNAME%
echo.

if "%IS_TEN%"=="Y" goto apps_winget_menu

:: ==========================================================
::  WIN 7/8 - Manual Download Mode
:: ==========================================================
echo   [MODE: Manual Download - Win 7/8]
echo.
echo   [1]  Google Chrome
echo   [2]  Mozilla Firefox
echo   [3]  WinRAR
echo   [4]  Microsoft Office 2013 (default)
echo   [5]  7-Zip
echo   [6]  Notepad++
echo   [7]  Adobe Acrobat Reader
echo   [8]  Google Earth Pro
echo   [9]  VLC Media Player
echo   [10] Kembali
echo.
set "appcho="
set /p "appcho=  Pilih [1-10]: "
if "%appcho%"=="1" goto dl_chrome
if "%appcho%"=="2" goto dl_firefox
if "%appcho%"=="3" goto dl_winrar
if "%appcho%"=="4" goto dl_office
if "%appcho%"=="5" goto dl_7zip
if "%appcho%"=="6" goto dl_npp
if "%appcho%"=="7" goto dl_acrobat
if "%appcho%"=="8" goto dl_earth
if "%appcho%"=="9" goto dl_vlc
goto menu

:: ==========================================================
::  WIN 10/11 - Winget Mode
:: ==========================================================
:apps_winget_menu
echo   [MODE: Winget - Win 10/11]
echo.
echo   [1]  Install SEMUA (Chrome, Firefox, WinRAR, 7-Zip, Notepad++, VLC)
echo   [2]  Google Chrome
echo   [3]  Mozilla Firefox
echo   [4]  WinRAR
echo   [5]  7-Zip
echo   [6]  Notepad++
echo   [7]  VLC Media Player
echo   [8]  Adobe Acrobat Reader
echo   [9]  Microsoft Office (2013/2010/2024)
echo   [10] Kembali
echo.
set "appcho="
set /p "appcho=  Pilih [1-10]: "
if "%appcho%"=="1" goto winget_all
if "%appcho%"=="2" goto winget_chrome
if "%appcho%"=="3" goto winget_firefox
if "%appcho%"=="4" goto winget_winrar
if "%appcho%"=="5" goto winget_7zip
if "%appcho%"=="6" goto winget_npp
if "%appcho%"=="7" goto winget_vlc
if "%appcho%"=="8" goto winget_acrobat
if "%appcho%"=="9" goto winget_office
goto menu

:: ==========================================================
::  WINGET - Install ALL
:: ==========================================================
:winget_all
cls
echo.
echo  =========================================================
echo   INSTALL SEMUA APPS VIA WINGET
echo  =========================================================
echo.
echo  [1/6] Google Chrome...
winget install --id Google.Chrome -e --accept-source-agreements --accept-package-agreements
echo.
echo  [2/6] Mozilla Firefox...
winget install --id Mozilla.Firefox -e --accept-source-agreements --accept-package-agreements
echo.
echo  [3/6] WinRAR...
winget install --id RARLab.WinRAR -e --accept-source-agreements --accept-package-agreements
echo.
echo  [4/6] 7-Zip...
winget install --id 7zip.7zip -e --accept-source-agreements --accept-package-agreements
echo.
echo  [5/6] Notepad++...
winget install --id Notepad++.Notepad++ -e --accept-source-agreements --accept-package-agreements
echo.
echo  [6/6] VLC Media Player...
winget install --id VideoLAN.VLC -e --accept-source-agreements --accept-package-agreements
echo.
echo  =========================================================
echo   SEMUA APPS TERINSTALL!
echo  =========================================================
echo.
pause
goto apps_menu

:: ==========================================================
::  WINGET - Individual Apps
:: ==========================================================
:winget_chrome
cls
echo.
echo  Installing Google Chrome via winget...
winget install --id Google.Chrome -e --accept-source-agreements --accept-package-agreements
echo.
pause
goto apps_menu

:winget_firefox
cls
echo.
echo  Installing Mozilla Firefox via winget...
winget install --id Mozilla.Firefox -e --accept-source-agreements --accept-package-agreements
echo.
pause
goto apps_menu

:winget_winrar
cls
echo.
echo  Installing WinRAR via winget...
winget install --id RARLab.WinRAR -e --accept-source-agreements --accept-package-agreements
echo.
pause
goto apps_menu

:winget_7zip
cls
echo.
echo  Installing 7-Zip via winget...
winget install --id 7zip.7zip -e --accept-source-agreements --accept-package-agreements
echo.
pause
goto apps_menu

:winget_npp
cls
echo.
echo  Installing Notepad++ via winget...
winget install --id Notepad++.Notepad++ -e --accept-source-agreements --accept-package-agreements
echo.
pause
goto apps_menu

:winget_vlc
cls
echo.
echo  Installing VLC via winget...
winget install --id VideoLAN.VLC -e --accept-source-agreements --accept-package-agreements
echo.
pause
goto apps_menu

:winget_acrobat
cls
echo.
echo  Installing Adobe Acrobat Reader via winget...
winget install --id Adobe.Acrobat.Reader.64-bit -e --accept-source-agreements --accept-package-agreements
echo.
pause
goto apps_menu

:winget_office
cls
echo.
echo  =========================================================
echo   MICROSOFT OFFICE
echo  =========================================================
echo.
echo  Pilih versi Office yang mau diinstall:
echo.
echo  [1] Office 2013 Pro Plus (rekomendasi)
echo  [2] Office 2010
echo  [3] Office 2024 (latest)
echo  [4] Kembali
echo.
set "offcho="
set /p "offcho=  Pilih [1-4]: "
if "%offcho%"=="1" goto office_2013_odt
if "%offcho%"=="2" goto winget_office_2010
if "%offcho%"=="3" goto winget_office_2024
goto apps_menu

:: ==========================================================
::  OFFICE 2013 via ODT (Office Deployment Tool)
::  Download ODT kecil (~3MB), dia yang download Office full
:: ==========================================================
:office_2013_odt
cls
echo.
echo  =========================================================
echo   OFFICE 2013 PRO PLUS - VIA ODT
echo  =========================================================
echo.
echo  Pakai Office Deployment Tool (ODT).
echo  File ODT cuma ~3MB, nanti dia download Office 2013
echo  secara otomatis dan install silent.
echo.
echo  [!] BUTUH KONEKSI INTERNET
echo.
echo  [1] Install Office 2013 Pro Plus (32-bit)
echo  [2] Install Office 2013 Pro Plus (64-bit)
echo  [3] Kembali
echo.
set "odtcho="
set /p "odtcho=  Pilih [1-3]: "
if "%odtcho%"=="1" goto odt_2013_x86
if "%odtcho%"=="2" goto odt_2013_x64
goto apps_menu

:odt_2013_x86
echo.
echo  [1/4] Download ODT...
mkdir "%TEMP%\office_odt" 2>nul
powershell -NoProfile -Command "Invoke-WebRequest -Uri 'https://download.microsoft.com/download/2/7/A/27AF1BE6-DD20-4CB4-B154-EBAB8A7D4A7E/officedeploymenttool_4471-1236_x264-21696.exe' -OutFile '%TEMP%\office_odt\odt.exe'"
if not exist "%TEMP%\office_odt\odt.exe" (
    echo  [ERROR] Gagal download ODT. Cek koneksi internet.
    pause
    goto apps_menu
)
echo       ODT downloaded.
echo.

echo  [2/4] Extract ODT...
pushd "%TEMP%\office_odt"
echo Y | odt.exe /quiet /extract:"%TEMP%\office_odt\extracted"
popd
echo       Extracted.
echo.

echo  [3/4] Download Office 2013 Pro Plus (32-bit)...
echo       Ini bisa makan waktu 10-30 menit tergantung koneksi.
echo.
if not exist "%TEMP%\office_odt\extracted\setup.exe" (
    echo  [ERROR] setup.exe tidak ditemukan setelah extract.
    pause
    goto apps_menu
)

:: Create config XML for Office 2013
(
echo ^<Configuration^>
echo   ^<Add OfficeClientEdition="32"^>
echo     ^<Product ID="ProPlusRetail"^>
echo       ^<Language ID="id-ID" /^>
echo       ^<Language ID="en-us" /^>
echo     ^/Product^>
echo   ^/Add^>
echo   ^<Display Level="None" AcceptEULA="TRUE" /^>
echo   ^<Property Name="SharedComputerLicensing" Value="0" /^>
echo   ^/Configuration^>
) > "%TEMP%\office_odt\config_2013.xml"

"%TEMP%\office_odt\extracted\setup.exe" /download "%TEMP%\office_odt\config_2013.xml"
echo       Download selesai.
echo.

echo  [4/4] Install Office 2013...
"%TEMP%\office_odt\extracted\setup.exe" /configure "%TEMP%\office_odt\config_2013.xml"
echo.
echo  =========================================================
echo   Office 2013 terinstall!
echo   Buka Word/Excel, masukkan product key untuk aktivasi.
echo  =========================================================
echo.
pause
goto apps_menu

:odt_2013_x64
echo.
echo  [1/4] Download ODT...
mkdir "%TEMP%\office_odt" 2>nul
powershell -NoProfile -Command "Invoke-WebRequest -Uri 'https://download.microsoft.com/download/2/7/A/27AF1BE6-DD20-4CB4-B154-EBAB8A7D4A7E/officedeploymenttool_4471-1236_x264-21696.exe' -OutFile '%TEMP%\office_odt\odt.exe'"
if not exist "%TEMP%\office_odt\odt.exe" (
    echo  [ERROR] Gagal download ODT. Cek koneksi internet.
    pause
    goto apps_menu
)
echo       ODT downloaded.
echo.

echo  [2/4] Extract ODT...
pushd "%TEMP%\office_odt"
echo Y | odt.exe /quiet /extract:"%TEMP%\office_odt\extracted"
popd
echo       Extracted.
echo.

echo  [3/4] Download Office 2013 Pro Plus (64-bit)...
echo       Ini bisa makan waktu 10-30 menit tergantung koneksi.
echo.
if not exist "%TEMP%\office_odt\extracted\setup.exe" (
    echo  [ERROR] setup.exe tidak ditemukan setelah extract.
    pause
    goto apps_menu
)

:: Create config XML for Office 2013 x64
(
echo ^<Configuration^>
echo   ^<Add OfficeClientEdition="64"^>
echo     ^<Product ID="ProPlusRetail"^>
echo       ^<Language ID="id-ID" /^>
echo       ^<Language ID="en-us" /^>
echo     ^/Product^>
echo   ^/Add^>
echo   ^<Display Level="None" AcceptEULA="TRUE" /^>
echo   ^<Property Name="SharedComputerLicensing" Value="0" /^>
echo   ^/Configuration^>
) > "%TEMP%\office_odt\config_2013_x64.xml"

"%TEMP%\office_odt\extracted\setup.exe" /download "%TEMP%\office_odt\config_2013_x64.xml"
echo       Download selesai.
echo.

echo  [4/4] Install Office 2013...
"%TEMP%\office_odt\extracted\setup.exe" /configure "%TEMP%\office_odt\config_2013_x64.xml"
echo.
echo  =========================================================
echo   Office 2013 terinstall!
echo   Buka Word/Excel, masukkan product key untuk aktivasi.
echo  =========================================================
echo.
pause
goto apps_menu

:winget_office_2010
cls
echo.
echo  =========================================================
echo   OFFICE 2010
echo  =========================================================
echo.
echo  [!] Office 2010 sudah EOL (End of Life).
echo  Support resmi udah berhenti. Tapi masih bisa dipake.
echo.
echo  [1] Pakai installer lokal
echo  [2] Download dari Google
echo  [3] Kembali
echo.
set "off10="
set /p "off10=  Pilih [1-3]: "
if "%off10%"=="1" goto office_2010_local
if "%off10%"=="2" goto office_2010_dl
goto apps_menu

:office_2010_local
echo.
echo  Cari setup.exe Office 2010 di folder ini:
echo  %CURR_DIR%
echo.
if exist "%CURR_DIR%setup.exe" (
    echo  Menjalankan Office 2010 installer...
    start /wait "" "%CURR_DIR%setup.exe"
    echo  Install selesai!
) else (
    echo  [ERROR] setup.exe tidak ditemukan.
    echo  Taruh installer di folder yang sama dengan script.
    start explorer "%CURR_DIR%"
)
echo.
pause
goto apps_menu

:office_2010_dl
start "" "https://www.google.com/search?q=microsoft+office+2010+offline+installer+download"
echo  Browser dibuka. Cari "Office 2010 offline installer".
echo.
echo  Tips:
echo  - Cari file .img atau .iso Office 2010
echo  - Mount file, jalankan setup.exe
echo  - Butuh product key untuk aktivasi
echo.
pause
goto apps_menu

:winget_office_2024
cls
echo.
echo  =========================================================
echo   MICROSOFT OFFICE 2024 (Latest)
echo  =========================================================
echo.
echo  [!] Office 2024 adalah versi click-to-run terbaru.
echo  Setelah install, login akun Microsoft untuk aktivasi.
echo.
echo  [1] Install Office Home ^& Business 2024
echo  [2] Install Office LTSC Professional Plus 2024
echo  [3] Kembali
echo.
set "offcho24="
set /p "offcho24=  Pilih [1-3]: "
if "%offcho24%"=="1" goto winget_office_hb
if "%offcho24%"=="2" goto winget_office_ltsc
goto apps_menu

:winget_office_hb
echo.
echo  Installing Office Home ^& Business 2024...
winget install --id Microsoft.Office.HomeAndBusiness2024Retail -e --accept-source-agreements --accept-package-agreements
echo.
echo  =========================================================
echo   Install selesai! Buka Word/Excel untuk aktivasi.
echo   Login akun Microsoft atau masukkan product key.
echo  =========================================================
echo.
pause
goto apps_menu

:winget_office_ltsc
echo.
echo  Installing Office LTSC Professional Plus 2024...
winget install --id Microsoft.Office.ProPlus2024Volume -e --accept-source-agreements --accept-package-agreements
echo.
echo  =========================================================
echo   Install selesai! 
echo   Aktivasi: pakai KMS host atau product key.
echo  =========================================================
echo.
pause
goto apps_menu

:: ==========================================================
::  WIN 7/8 - Manual Download (buka browser)
:: ==========================================================
:dl_chrome
start "" "https://www.google.com/chrome/"
echo  Browser dibuka. Download Chrome dari situ.
pause
goto apps_menu

:dl_firefox
start "" "https://www.mozilla.org/firefox/new/"
echo  Browser dibuka. Download Firefox dari situ.
pause
goto apps_menu

:dl_winrar
start "" "https://www.win-rar.com/download.html"
echo  Browser dibuka. Download WinRAR dari situ.
pause
goto apps_menu

:dl_office
cls
echo.
echo  =========================================================
echo   OFFICE 2013 - INSTALL VIA ODT
echo  =========================================================
echo.
echo  Pakai Office Deployment Tool (ODT).
echo  File ODT cuma ~3MB, nanti dia download Office 2013
echo  secara otomatis. Butuh koneksi internet.
echo.
echo  [1] Install Office 2013 Pro Plus (32-bit)
echo  [2] Install Office 2013 Pro Plus (64-bit)
echo  [3] Kembali
echo.
set "dloff="
set /p "dloff=  Pilih [1-3]: "
if "%dloff%"=="1" goto odt_2013_x86
if "%dloff%"=="2" goto odt_2013_x64
goto apps_menu

:dl_7zip
start "" "https://www.7-zip.org/download.html"
echo  Browser dibuka. Download 7-Zip dari situ.
pause
goto apps_menu

:dl_npp
start "" "https://notepad-plus-plus.org/downloads/"
echo  Browser dibuka. Download Notepad++ dari situ.
pause
goto apps_menu

:dl_acrobat
start "" "https://get.adobe.com/reader/"
echo  Browser dibuka. Download Adobe Reader dari situ.
pause
goto apps_menu

:dl_earth
start "" "https://www.google.com/earth/versions/#earth-pro"
echo  Browser dibuka. Download Google Earth Pro dari situ.
pause
goto apps_menu

:dl_vlc
start "" "https://www.videolan.org/vlc/"
echo  Browser dibuka. Download VLC dari situ.
pause
goto apps_menu
