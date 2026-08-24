@echo off
title IT SUPPORT TOOLKIT v2.2 UNIVERSAL
color 0B
mode con: cols=88 lines=45

set "CURR_DIR=%~dp0"

rem Tanggal hari ini format YYYYMMDD - aman untuk semua locale Windows
for /f %%i in ('powershell -NoProfile -Command "Get-Date -Format yyyyMMdd"') do set "TODAY=%%i"

rem Deteksi versi Windows: 6.1=Seven, 6.2=Eight, 6.3=8.1, 10.x=Ten/Eleven
set "WINMAJOR="
set "WINMINOR="
for /f "tokens=4-5 delims=.[] " %%a in ('ver') do (
    set "WINMAJOR=%%a"
    set "WINMINOR=%%b"
)
set /a VERNUM=%WINMAJOR%*100+%WINMINOR%
set "WINNAME=Tidak dikenali"
if "%VERNUM%"=="601" set "WINNAME=Windows 7"
if "%VERNUM%"=="602" set "WINNAME=Windows 8"
if "%VERNUM%"=="603" set "WINNAME=Windows 8.1"
if %VERNUM% GEQ 1000 set "WINNAME=Windows 10/11"
if %VERNUM% LSS 601 set "WINNAME=Vista/lebih lama"
set "HAS_DISM=N"
if %VERNUM% GEQ 602 set "HAS_DISM=Y"
set "IS_TEN=N"
if %VERNUM% GEQ 1000 set "IS_TEN=Y"

rem Cek hak admin, kalau belum minta elevate via UAC
fltmc >nul 2>&1
if errorlevel 1 (
    echo.
    echo  [!] Toolkit ini butuh hak Administrator.
    echo      Meminta izin lewat UAC... klik YES.
    powershell -NoProfile -Command "Start-Process -FilePath '%~f0' -Verb RunAs"
    exit /b
)
:menu
cls
echo.
echo  =========================================================
echo     I T   S U P P O R T   T O O L K I T   v2.2
echo        UNIVERSAL EDITION - WINDOWS 7 s/d WINDOWS 11
echo  =========================================================
echo.
echo   Terdeteksi : %WINNAME%  (kernel %WINMAJOR%.%WINMINOR%)
echo.
echo   [NETWORK]
echo   [1]  Cek Koneksi Internet - Ping
echo   [2]  Cek IP Address
echo   [3]  Cek Network Interface
echo   [4]  Flush DNS + Renew IP + Reset Winsock
echo   [5]  Enable / Disable WiFi Adapter
echo.
echo   [SYSTEM]
echo   [6]  Info OS dan Hardware
echo   [7]  Cek Serial Number CPU / Mobo / BIOS
echo   [8]  Cek Harddisk - chkdsk
echo   [9]  Clean Temp Files
echo   [10] Kill Process Frozen
echo   [11] Cek Windows Activation
echo   [12] Cek Suhu CPU
echo.
echo   [DRIVER]
echo   [13] Scan Hardware Tanpa Driver
echo   [14] Update Driver Otomatis
echo.
echo   [USER ACCOUNT]
echo   [15] Reset Password User
echo   [16] Enable / Disable Admin Account
echo.
echo   [WINDOWS REPAIR]
echo   [17] Repair Windows Update - SFC + DISM
echo   [18] Repair .NET Framework
echo   [19] Reset Windows Firewall
echo.
echo   [UTILITIES]
echo   [20] Enable / Disable Remote Desktop
echo   [21] Backup Registry
echo   [22] Uninstall Program
echo   [23] Shutdown / Restart Timer
echo.
echo   [PRINTER]
echo   [24] Download Driver Printer
echo   [25] Share / Unshare Printer
echo   [26] Connect ke Shared Printer - by IP
echo   [27] List Printer dan Status
echo   [28] Set Default Printer
echo   [29] Restart Print Spooler
echo   [30] Clear Print Queue
echo   [31] Backup / Restore Printer Settings
echo.
echo   [TOMCAT]
echo   [32] Install Tomcat Icha Print - Full
echo   [33] Uninstall Tomcat dan JRE - Clean
echo.
echo   [34] JALANKAN SEMUA CEK
echo   [35] KELUAR
echo.
echo  =========================================================
set "pilih="
set /p "pilih=  Pilih menu [1-35]: "
if not defined pilih goto menu

if "%pilih%"=="1" goto ping
if "%pilih%"=="2" goto ip
if "%pilih%"=="3" goto netsh
if "%pilih%"=="4" goto flushdns
if "%pilih%"=="5" goto wifi
if "%pilih%"=="6" goto sysinfo
if "%pilih%"=="7" goto serial
if "%pilih%"=="8" goto chkdsk
if "%pilih%"=="9" goto cleantemp
if "%pilih%"=="10" goto killproc
if "%pilih%"=="11" goto activation
if "%pilih%"=="12" goto cputemp
if "%pilih%"=="13" goto driver_scan
if "%pilih%"=="14" goto driver_update
if "%pilih%"=="15" goto resetpw
if "%pilih%"=="16" goto adminacc
if "%pilih%"=="17" goto repairupdate
if "%pilih%"=="18" goto dotnet
if "%pilih%"=="19" goto firewall
if "%pilih%"=="20" goto rdp
if "%pilih%"=="21" goto backupreg
if "%pilih%"=="22" goto uninstall
if "%pilih%"=="23" goto timermenu
if "%pilih%"=="24" goto downloaddriver
if "%pilih%"=="25" goto shareprinter
if "%pilih%"=="26" goto connectprinter
if "%pilih%"=="27" goto listprinter
if "%pilih%"=="28" goto defaultprinter
if "%pilih%"=="29" goto restartspooler
if "%pilih%"=="30" goto clearqueue
if "%pilih%"=="31" goto backupprinter
if "%pilih%"=="32" goto tomcat
if "%pilih%"=="33" goto uninstalltomcat
if "%pilih%"=="34" goto allcheck
if "%pilih%"=="35" goto keluar
echo.
echo  [!] Pilihan tidak valid!
timeout /t 2 /nobreak >nul
goto menu

:: ==========================================================
::  [1] CEK KONEKSI INTERNET (PING)
:: ==========================================================
:ping
cls
echo.
echo  ============================================
echo   CEK KONEKSI INTERNET - PING
echo  ============================================
echo.
echo  --- Ping Google DNS (8.8.8.8) ---
ping 8.8.8.8 -n 4
echo.
echo  --- Ping Google.com ---
ping google.com -n 4
echo.
pause
goto menu

:: ==========================================================
::  [2] CEK IP ADDRESS
:: ==========================================================
:ip
cls
echo.
echo  ============================================
echo   CEK IP ADDRESS
echo  ============================================
echo.
ipconfig /all
echo.
pause
goto menu

:: ==========================================================
::  [3] CEK NETWORK INTERFACE
:: ==========================================================
:netsh
cls
echo.
echo  ============================================
echo   CEK NETWORK INTERFACE
echo  ============================================
echo.
echo  --- Interface List ---
netsh interface ipv4 show interfaces
echo.
echo  --- Status Semua Interface ---
netsh interface show interface
echo.
pause
goto menu

:: ==========================================================
::  [4] FLUSH DNS + RENEW IP + RESET WINSOCK
:: ==========================================================
:flushdns
cls
echo.
echo  ============================================
echo   FLUSH DNS + RENEW IP + RESET WINSOCK
echo  ============================================
echo.
echo  [1/4] Flush DNS...
ipconfig /flushdns
echo.
echo  [2/4] Release IP...
ipconfig /release
echo.
echo  [3/4] Renew IP...
ipconfig /renew
echo.
echo  [4/4] Reset Winsock...
netsh winsock reset
echo.
echo  ============================================
echo   Selesai! Restart komputer jika perlu.
echo  ============================================
echo.
pause
goto menu

:: ==========================================================
::  [5] ENABLE / DISABLE WIFI ADAPTER
:: ==========================================================
:wifi
cls
echo.
echo  ============================================
echo   ENABLE / DISABLE WIFI ADAPTER
echo  ============================================
echo.
echo  --- Daftar Interface ---
netsh interface show interface
echo.
echo  NOTE: Perintah ini pakai nama adapter "Wi-Fi".
echo  Kalau nama adapter lu beda, rename dulu di Network Connections.
echo.
echo  [1] Disable WiFi
echo  [2] Enable WiFi
echo  [3] Kembali
echo.
set "wp="
set /p "wp=  Pilih [1-3]: "
if "%wp%"=="1" goto wifi_off
if "%wp%"=="2" goto wifi_on
goto menu

:wifi_off
echo.
echo  Mematikan WiFi...
netsh interface set interface "Wi-Fi" disable
echo.
pause
goto menu

:wifi_on
echo.
echo  Menyalakan WiFi...
netsh interface set interface "Wi-Fi" enable
echo.
pause
goto menu

:: ==========================================================
::  [6] INFO OS & HARDWARE - via WMI, kompatibel Win7-11
:: ==========================================================
:sysinfo
cls
echo.
echo  ============================================
echo   INFO OS DAN HARDWARE
echo  ============================================
echo.
echo  --- OS Info ---
powershell -NoProfile -Command "$o=Get-WmiObject Win32_OperatingSystem; 'OS        : '+$o.Caption; 'Arsitektur: '+$o.OSArchitecture; 'Versi     : '+$o.Version+'  Build '+$o.BuildNumber; 'RAM Total : '+[math]::Round($o.TotalVisibleMemorySize/1MB,1)+' GB'"
echo.
echo  --- CPU Info ---
powershell -NoProfile -Command "Get-WmiObject Win32_Processor | Select-Object Name,NumberOfCores,NumberOfLogicalProcessors,MaxClockSpeed | Format-List"
echo.
echo  --- RAM Info (per keping) ---
powershell -NoProfile -Command "Get-WmiObject Win32_PhysicalMemory | Select-Object Manufacturer,PartNumber,@{n='GB';e={[math]::Round($_.Capacity/1GB,1)}},Speed | Format-Table -AutoSize"
echo.
echo  --- Disk Space ---
powershell -NoProfile -Command "Get-WmiObject Win32_LogicalDisk | Where-Object {$_.DriveType -eq 3} | Select-Object DeviceID,VolumeName,FileSystem,@{n='TotalGB';e={[math]::Round($_.Size/1GB,1)}},@{n='FreeGB';e={[math]::Round($_.FreeSpace/1GB,1)}} | Format-Table -AutoSize"
echo.
pause
goto menu

:: ==========================================================
::  [7] CEK SERIAL NUMBER CPU/MOBO/BIOS
:: ==========================================================
:serial
cls
echo.
echo  ============================================
echo   CEK SERIAL NUMBER DAN INFO
echo  ============================================
echo.
powershell -NoProfile -Command "'=== CPU ==='; Get-WmiObject Win32_Processor | Select-Object Name,ProcessorId | Format-List; '=== Motherboard ==='; Get-WmiObject Win32_BaseBoard | Select-Object Manufacturer,Product,SerialNumber | Format-List; '=== BIOS ==='; Get-WmiObject Win32_BIOS | Select-Object Manufacturer,SMBIOSBIOSVersion,SerialNumber | Format-List"
pause
goto menu

:: ==========================================================
::  [8] CEK HARDDISK (CHKDSK) - read-only loop aman semua versi
:: ==========================================================
:chkdsk
cls
echo.
echo  ============================================
echo   CEK HARDDISK - CHKDSK
echo  ============================================
echo.
echo  [1] Cek semua drive - read-only, aman
echo  [2] Cek drive C: saja - read-only
echo  [3] Fix error C: otomatis - /f /r - bisa minta restart
echo  [4] Kembali
echo.
set "cp="
set /p "cp=  Pilih [1-4]: "
if "%cp%"=="1" goto chk_scan_all
if "%cp%"=="2" goto chk_c_ro
if "%cp%"=="3" goto chk_c_fix
goto menu

:chk_scan_all
echo.
for %%D in (C D E F G H) do (
    if exist %%D:\ (
        echo  --- Drive %%D: ---
        chkdsk %%D:
        echo.
    )
)
pause
goto menu

:chk_c_ro
echo.
chkdsk C:
echo.
pause
goto menu

:chk_c_fix
echo.
echo  [!] Ini akan fix error di drive C:. Kalau drive terkunci,
echo  chkdsk bakal minta jadwalkan scan saat restart - ketik Y lalu Enter.
echo  CATATAN: /r bisa makan waktu lama di HDD besar.
echo.
chkdsk C: /f /r
echo.
pause
goto menu

:: ==========================================================
::  [9] CLEAN TEMP FILES
:: ==========================================================
:cleantemp
cls
echo.
echo  ============================================
echo   CLEAN TEMP FILES
echo  ============================================
echo.
echo  [1/4] Clean Temp user dan Windows...
del /q /f /s "%TEMP%\*.*" >nul 2>&1
del /q /f /s "C:\Windows\Temp\*.*" >nul 2>&1
echo        Selesai.
echo.
echo  [2/4] Clean Prefetch...
del /q /f /s "C:\Windows\Prefetch\*.*" >nul 2>&1
echo        Selesai.
echo.
echo  [3/4] Clean Recent Files...
del /q /f /s "%APPDATA%\Microsoft\Windows\Recent\*.*" >nul 2>&1
echo        Selesai.
echo.
echo  [4/4] Clean Recycle Bin...
rd /s /q "C:\$Recycle.Bin" >nul 2>&1
echo       Selesai.
echo.
echo  ============================================
echo   Temp files dibersihkan!
echo  ============================================
echo.
pause
goto menu

:: ==========================================================
::  [10] KILL PROCESS FROZEN
:: ==========================================================
:killproc
cls
echo.
echo  ============================================
echo   KILL PROCESS FROZEN
echo  ============================================
echo.
echo  --- Process yang NOT RESPONDING / freeze ---
tasklist /FI "STATUS eq NOT RESPONDING"
echo.
echo  [1] Kill by PID
echo  [2] Kill by Nama
echo  [3] List semua process
echo  [4] Kembali
echo.
set "kpp="
set /p "kpp=  Pilih [1-4]: "
if "%kpp%"=="1" goto kill_pid
if "%kpp%"=="2" goto kill_name
if "%kpp%"=="3" goto kill_list
goto menu

:kill_pid
set "pid="
set /p "pid=  Masukkan PID: "
if not defined pid goto killproc
taskkill /PID %pid% /F
echo.
pause
goto menu

:kill_name
set "pname="
set /p "pname=  Masukkan nama process, contoh notepad.exe: "
if not defined pname goto killproc
taskkill /IM %pname% /F
echo.
pause
goto menu

:kill_list
cls
tasklist
echo.
pause
goto killproc

:: ==========================================================
::  [11] CEK WINDOWS ACTIVATION
:: ==========================================================
:activation
cls
echo.
echo  ============================================
echo   CEK WINDOWS ACTIVATION
echo  ============================================
echo.
echo  Popup info lisensi akan muncul, tutup untuk lanjut.
echo.
slmgr /dli
echo.
slmgr /xpr
echo.
pause
goto menu

:: ==========================================================
::  [12] CEK SUHU CPU
:: ==========================================================
:cputemp
cls
echo.
echo  ============================================
echo   CEK SUHU CPU
echo  ============================================
echo.
echo  --- Suhu Thermal Zone ---
powershell -NoProfile -Command "$t=Get-WmiObject -Namespace 'root\wmi' -Class MSAcpi_ThermalZoneTemperature -ErrorAction SilentlyContinue; if($t){$t | ForEach-Object { '{0} : {1:N1} Celsius' -f $_.InstanceName, ($_.CurrentTemperature/10-273.15) }}else{'Sensor suhu tidak tersedia via WMI. Normal di banyak laptop/PC. Cek di BIOS atau aplikasi vendor.'}"
echo.
echo  --- Beban dan Clock CPU ---
powershell -NoProfile -Command "Get-WmiObject Win32_Processor | Select-Object Name,LoadPercentage,CurrentClockSpeed,MaxClockSpeed | Format-List"
echo.
pause
goto menu

:: ==========================================================
::  [13] SCAN HARDWARE TANPA DRIVER
:: ==========================================================
:driver_scan
cls
echo.
echo  ============================================
echo   SCAN HARDWARE TANPA DRIVER
echo  ============================================
echo.
pnputil /scan-devices >nul 2>&1
if errorlevel 1 pnputil -i >nul 2>&1
echo  Scan perangkat sudah dicoba via pnputil.
echo.
echo  Kalau device belum ke-detect, gua bukakan Device Manager.
echo  Klik menu Action - Scan for hardware changes di situ.
echo.
start devmgmt.msc
pause
goto menu

:: ==========================================================
::  [14] UPDATE DRIVER OTOMATIS - jalur beda utk Win7/8 vs 10/11
:: ==========================================================
:driver_update
cls
echo.
echo  ============================================
echo   UPDATE DRIVER OTOMATIS
echo  ============================================
echo.
if "%IS_TEN%"=="Y" goto du_ten
echo  Men-trigger deteksi update via wuauclt - Windows 7/8 path...
wuauclt /detectnow 2>nul
echo  Membuka Windows Update di Control Panel.
echo  Install update driver yang muncul di sana.
echo.
start "" control /name Microsoft.WindowsUpdate
pause
goto menu

:du_ten
echo  Men-trigger scan Windows Update - Windows 10/11 path...
usoclient StartScan 2>nul
timeout /t 3 /nobreak >nul
echo  Membuka Settings - Windows Update.
echo  Install update driver yang muncul di sana, restart kalau diminta.
echo.
start ms-settings:windowsupdate
pause
goto menu

:: ==========================================================
::  [15] RESET PASSWORD USER
:: ==========================================================
:resetpw
cls
echo.
echo  ============================================
echo   RESET PASSWORD USER
echo  ============================================
echo.
echo  --- List User ---
net user
echo.
set "uname="
set /p "uname=  Masukkan nama user: "
if not defined uname goto resetpw
echo.
echo  [1] Reset password ke "password123"
echo  [2] Input password baru
echo  [3] Batal
echo.
set "rpp="
set /p "rpp=  Pilih [1-3]: "
if "%rpp%"=="1" goto rp_def
if "%rpp%"=="2" goto rp_new
goto menu

:rp_def
net user "%uname%" password123
echo.
echo  Password "%uname%" direset ke "password123".
pause
goto menu

:rp_new
set "newpw="
set /p "newpw=  Masukkan password baru: "
if not defined newpw goto rp_new
net user "%uname%" "%newpw%"
echo.
echo  Password "%uname%" berhasil diubah.
pause
goto menu

:: ==========================================================
::  [16] ENABLE / DISABLE ADMIN ACCOUNT
:: ==========================================================
:adminacc
cls
echo.
echo  ============================================
echo   ENABLE / DISABLE ADMIN ACCOUNT
echo  ============================================
echo.
powershell -NoProfile -Command "$a=Get-WmiObject Win32_UserAccount | Where-Object {$_.LocalAccount -and $_.Name -eq 'Administrator'}; if($a){'Administrator ada. Status Disabled = '+$a.Disabled}else{'User Administrator tidak ada di sistem ini'}"
echo.
echo  [1] Enable Admin Account
echo  [2] Disable Admin Account
echo  [3] Kembali
echo.
set "aap="
set /p "aap=  Pilih [1-3]: "
if "%aap%"=="1" goto adm_on
if "%aap%"=="2" goto adm_off
goto menu

:adm_on
net user Administrator /active:yes
echo.
echo  Admin account di-ENABLE.
pause
goto menu

:adm_off
net user Administrator /active:no
echo.
echo  Admin account di-DISABLE.
pause
goto menu

:: ==========================================================
::  [17] REPAIR WINDOWS UPDATE - DISM hanya Win8+ (auto-deteksi)
:: ==========================================================
:repairupdate
cls
echo.
echo  ============================================
echo   REPAIR WINDOWS UPDATE - SFC + DISM
echo  ============================================
echo.
if "%HAS_DISM%"=="Y" goto ru_dism
echo  [INFO] DISM Cleanup-Image cuma ada di Windows 8 ke atas.
echo  Di Windows ini kita pakai SFC saja.
echo.
echo  Proses bisa makan waktu 10-30 menit. Jangan ditutup!
echo.
echo  [1/1] SFC /scannow...
sfc /scannow
echo.
echo  ============================================
echo   Repair selesai! Restart jika perlu.
echo  ============================================
echo.
pause
goto menu

:ru_dism
echo  Proses ini bisa makan waktu 10-30 menit. Jangan ditutup!
echo.
echo  [1/3] DISM CheckHealth...
DISM /Online /Cleanup-Image /CheckHealth
echo.
echo  [2/3] DISM RestoreHealth...
DISM /Online /Cleanup-Image /RestoreHealth
echo.
echo  [3/3] SFC /scannow...
sfc /scannow
echo.
echo  ============================================
echo   Repair selesai! Restart jika perlu.
echo  ============================================
echo.
pause
goto menu

:: ==========================================================
::  [18] REPAIR .NET FRAMEWORK - NetFx3 DISM hanya Win8+
:: ==========================================================
:dotnet
cls
echo.
echo  ============================================
echo   REPAIR .NET FRAMEWORK
echo  ============================================
echo.
if "%HAS_DISM%"=="Y" goto dn_new
echo  [INFO] Di Windows 7, .NET 3.5 sudah jadi bagian OS.
echo  Cukup jalankan SFC untuk perbaikan umum.
echo.
echo  [1/1] SFC /scannow...
sfc /scannow
echo.
echo  Selesai! Restart jika perlu.
echo.
pause
goto menu

:dn_new
echo  [1/2] Enable Feature NetFx3...
DISM /Online /Enable-Feature /FeatureName:NetFx3 /All
echo.
echo  [2/2] SFC /scannow...
sfc /scannow
echo.
echo  ============================================
echo   Repair selesai! Restart jika perlu.
echo  ============================================
echo.
pause
goto menu

:: ==========================================================
::  [19] RESET WINDOWS FIREWALL
:: ==========================================================
:firewall
cls
echo.
echo  ============================================
echo   RESET WINDOWS FIREWALL
echo  ============================================
echo.
echo  --- Status Firewall Saat Ini ---
netsh advfirewall show allprofiles state
echo.
echo  [1] Reset Firewall ke default
echo  [2] Matikan Firewall - semua profile
echo  [3] Nyalakan Firewall - semua profile
echo  [4] Kembali
echo.
set "fp="
set /p "fp=  Pilih [1-4]: "
if "%fp%"=="1" goto fw_reset
if "%fp%"=="2" goto fw_off
if "%fp%"=="3" goto fw_on
goto menu

:fw_reset
netsh advfirewall reset
echo.
echo  Firewall di-reset ke default.
pause
goto menu

:fw_off
netsh advfirewall set allprofiles state off
echo.
echo  Firewall dimatikan untuk semua profile.
pause
goto menu

:fw_on
netsh advfirewall set allprofiles state on
echo.
echo  Firewall dinyalakan untuk semua profile.
pause
goto menu

:: ==========================================================
::  [20] ENABLE / DISABLE REMOTE DESKTOP
:: ==========================================================
:rdp
cls
echo.
echo  ============================================
echo   ENABLE / DISABLE REMOTE DESKTOP
echo  ============================================
echo.
echo  Catatan: Windows Home tidak support jadi RDP server.
echo.
echo  Status RDP saat ini - fDenyTSConnections:
reg query "HKLM\SYSTEM\CurrentControlSet\Control\Terminal Server" /v fDenyTSConnections 2>nul
echo.
echo  [1] Enable Remote Desktop
echo  [2] Disable Remote Desktop
echo  [3] Kembali
echo.
set "rdpc="
set /p "rdpc=  Pilih [1-3]: "
if "%rdpc%"=="1" goto rdp_on
if "%rdpc%"=="2" goto rdp_off
goto menu

:rdp_on
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Terminal Server" /v fDenyTSConnections /t REG_DWORD /d 0 /f >nul
netsh advfirewall firewall set rule group="Remote Desktop" new enable=yes >nul
echo.
echo  Remote Desktop di-ENABLE.
pause
goto menu

:rdp_off
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Terminal Server" /v fDenyTSConnections /t REG_DWORD /d 1 /f >nul
echo.
echo  Remote Desktop di-DISABLE.
pause
goto menu

:: ==========================================================
::  [21] BACKUP REGISTRY
:: ==========================================================
:backupreg
cls
echo.
echo  ============================================
echo   BACKUP REGISTRY
echo  ============================================
echo.
set "BACKUPDIR=%CURR_DIR%RegistryBackup_%TODAY%"
mkdir "%BACKUPDIR%" 2>nul
echo  Folder backup: %BACKUPDIR%
echo.
echo  [1] Backup Full - HKLM SOFTWARE+SYSTEM, HKCU, HKCR
echo  [2] Backup HKCU saja
echo  [3] Backup HKLM saja - SOFTWARE + SYSTEM
echo  [4] Kembali
echo.
set "brp="
set /p "brp=  Pilih [1-4]: "
if "%brp%"=="1" goto br_full
if "%brp%"=="2" goto br_hkcu
if "%brp%"=="3" goto br_hklm
goto menu

:br_full
echo.
echo  Exporting HKLM\SOFTWARE...
reg export "HKLM\SOFTWARE" "%BACKUPDIR%\HKLM_SOFTWARE.reg" /y
echo  Exporting HKLM\SYSTEM...
reg export "HKLM\SYSTEM" "%BACKUPDIR%\HKLM_SYSTEM.reg" /y
echo  Exporting HKCU...
reg export HKCU "%BACKUPDIR%\HKCU.reg" /y
echo  Exporting HKCR - bisa lambat karena filenya besar...
reg export HKCR "%BACKUPDIR%\HKCR.reg" /y
echo.
echo  Backup selesai!
pause
goto menu

:br_hkcu
echo.
reg export HKCU "%BACKUPDIR%\HKCU.reg" /y
echo  HKCU backup selesai!
pause
goto menu

:br_hklm
echo.
echo  Exporting HKLM\SOFTWARE...
reg export "HKLM\SOFTWARE" "%BACKUPDIR%\HKLM_SOFTWARE.reg" /y
echo  Exporting HKLM\SYSTEM...
reg export "HKLM\SYSTEM" "%BACKUPDIR%\HKLM_SYSTEM.reg" /y
echo  HKLM backup selesai!
pause
goto menu

:: ==========================================================
::  [22] UNINSTALL PROGRAM - via registry, kompatibel semua versi
:: ==========================================================
:uninstall
cls
echo.
echo  ============================================
echo   UNINSTALL PROGRAM
echo  ============================================
echo.
echo  [1] List semua program yang terinstall
echo  [2] Uninstall by nama
echo  [3] Kembali
echo.
set "up="
set /p "up=  Pilih [1-3]: "
if "%up%"=="1" goto uni_list
if "%up%"=="2" goto uni_byname
goto menu

:uni_list
echo.
echo  --- Installed Programs ---
powershell -NoProfile -Command "Get-ItemProperty 'HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\*','HKLM:\SOFTWARE\WOW6432Node\Microsoft\Windows\CurrentVersion\Uninstall\*','HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\*' -ErrorAction SilentlyContinue | Where-Object {$_.DisplayName} | Sort-Object DisplayName | Select-Object DisplayName,DisplayVersion | Format-Table -AutoSize"
echo.
pause
goto menu

:uni_byname
echo.
set "progname="
set /p "progname=  Masukkan nama program - boleh sebagian kata: "
if not defined progname goto uninstall
echo.
powershell -NoProfile -Command "$k=@('HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\*','HKLM:\SOFTWARE\WOW6432Node\Microsoft\Windows\CurrentVersion\Uninstall\*','HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\*'); $a=Get-ItemProperty $k -ErrorAction SilentlyContinue | Where-Object {$_.DisplayName -like '*%progname%*'} | Sort-Object {$_.DisplayName.Length} | Select-Object -First 1; if(-not $a){Write-Host '[ERROR] Program tidak ditemukan'} else {Write-Host ('Target: '+$a.DisplayName); $u=$a.UninstallString; if($u){$m=[regex]::Match($u,'^\"([^\"]+)\"(.*)$'); if($m.Success){Start-Process -FilePath $m.Groups[1].Value -ArgumentList $m.Groups[2].Value.Trim()} else {Start-Process cmd.exe -ArgumentList '/c',$u -Wait}; Write-Host 'Uninstaller dijalankan. Ikuti wizard-nya kalau muncul.'} else {Write-Host '[!] Program ini tidak punya UninstallString'}}"
echo.
pause
goto menu

:: ==========================================================
::  [23] SHUTDOWN / RESTART TIMER
:: ==========================================================
:timermenu
cls
echo.
echo  ============================================
echo   SHUTDOWN / RESTART TIMER
echo  ============================================
echo.
echo  [1] Shutdown sekarang
echo  [2] Restart sekarang
echo  [3] Shutdown dengan timer
echo  [4] Restart dengan timer
echo  [5] Batalkan shutdown/restart yang terjadwal
echo  [6] Kembali
echo.
set "sdp="
set /p "sdp=  Pilih [1-6]: "
if "%sdp%"=="1" goto sd_now
if "%sdp%"=="2" goto rs_now
if "%sdp%"=="3" goto sd_timer
if "%sdp%"=="4" goto rs_timer
if "%sdp%"=="5" goto sd_cancel
goto menu

:sd_now
echo.
echo  Shutdown komputer...
shutdown /s /t 0
exit

:rs_now
echo.
echo  Restart komputer...
shutdown /r /t 0
exit

:sd_timer
set "stime="
set /p "stime=  Masukkan detik - contoh 60 = 1 menit: "
shutdown /s /t %stime%
echo.
echo  Shutdown dijadwalkan dalam %stime% detik.
echo  Untuk batal: pilih menu 5.
pause
goto menu

:rs_timer
set "rtime="
set /p "rtime=  Masukkan detik - contoh 60 = 1 menit: "
shutdown /r /t %rtime%
echo.
echo  Restart dijadwalkan dalam %rtime% detik.
echo  Untuk batal: pilih menu 5.
pause
goto menu

:sd_cancel
echo.
shutdown /a 2>nul && echo  Shutdown/restart dibatalkan! || echo  Tidak ada shutdown/restart yang terjadwal.
pause
goto menu

:: ==========================================================
::  [24] DOWNLOAD DRIVER PRINTER
:: ==========================================================
:downloaddriver
cls
echo.
echo  ============================================
echo   DOWNLOAD DRIVER PRINTER
echo  ============================================
echo.
echo  [1] Epson - LX-310, LQ-310, L3110, L3210, dsb
echo  [2] Canon - G2010, MP287, dsb
echo  [3] HP - LaserJet P1102, M12a, dsb
echo  [4] Brother - HL-T4000DW, dsb
echo  [5] Link Umum - Google
echo  [6] Kembali
echo.
set "dlp="
set /p "dlp=  Pilih [1-6]: "
if "%dlp%"=="1" goto dl_epson
if "%dlp%"=="2" goto dl_canon
if "%dlp%"=="3" goto dl_hp
if "%dlp%"=="4" goto dl_brother
if "%dlp%"=="5" goto dl_google
goto menu

:dl_epson
start "" "https://www.epson.com.vn/support/download"
echo.
echo  Website Epson dibuka. Cari model printer, pilih OS, download driver.
echo  Jalankan setup.exe hasil download untuk install.
pause
goto menu

:dl_canon
start "" "https://www.canon.co.id/support"
echo.
echo  Website Canon dibuka. Cari model printer, pilih OS, download driver.
echo  Jalankan setup.exe hasil download untuk install.
pause
goto menu

:dl_hp
start "" "https://support.hp.com/us-en/drivers"
echo.
echo  Website HP dibuka. Masukkan model printer, pilih OS, download driver.
echo  Jalankan setup.exe hasil download untuk install.
pause
goto menu

:dl_brother
start "" "https://www.brother.co.id/support"
echo.
echo  Website Brother dibuka. Cari model printer, pilih OS, download driver.
echo  Jalankan setup.exe hasil download untuk install.
pause
goto menu

:dl_google
start "" "https://www.google.com/search?q=download+driver+printer"
pause
goto menu

:: ==========================================================
::  [25] SHARE / UNSHARE PRINTER - via WMI, kompatibel Win7-11
:: ==========================================================
:shareprinter
cls
echo.
echo  ============================================
echo   SHARE / UNSHARE PRINTER
echo  ============================================
echo.
echo  --- List Printer Terinstall ---
powershell -NoProfile -Command "Get-WmiObject Win32_Printer | Select-Object Name,PortName,DriverName,Shared,ShareName | Format-Table -AutoSize"
echo.
echo  [1] Share Printer
echo  [2] Unshare Printer
echo  [3] Kembali
echo.
set "shp="
set /p "shp=  Pilih [1-3]: "
if "%shp%"=="1" goto sh_do
if "%shp%"=="2" goto sh_undo
goto menu

:sh_do
set "shname="
set /p "shname=  Masukkan nama printer - persis kayak di list atas: "
if not defined shname goto shareprinter
set "shalias="
set /p "shalias=  Masukkan nama share - contoh PrinterKantor: "
if not defined shalias goto sh_do
echo.
powershell -NoProfile -Command "$p=Get-WmiObject Win32_Printer | Where-Object {$_.Name -eq '%shname%'}; if($p){$p.Shared=$true; $p.ShareName='%shalias%'; $p.Put() | Out-Null; Write-Host 'OK! Di-share sebagai \\%computername%\%shalias%'}else{Write-Host '[ERROR] Printer tidak ditemukan - nama harus persis'}"
echo.
pause
goto menu

:sh_undo
set "unname="
set /p "unname=  Masukkan nama printer yang mau di-unshare: "
if not defined unname goto shareprinter
echo.
powershell -NoProfile -Command "$p=Get-WmiObject Win32_Printer | Where-Object {$_.Name -eq '%unname%'}; if($p){$p.Shared=$false; $p.Put() | Out-Null; Write-Host 'OK! Printer sudah di-unshare'}else{Write-Host '[ERROR] Printer tidak ditemukan - nama harus persis'}"
echo.
echo  Printer berhasil di-unshare.
pause
goto menu

:: ==========================================================
::  [26] CONNECT KE SHARED PRINTER (BY IP)
:: ==========================================================
:connectprinter
cls
echo.
echo  ============================================
echo   CONNECT KE SHARED PRINTER - BY IP
echo  ============================================
echo.
echo  [1] Connect by IP / Hostname
echo  [2] Connect by Path - contoh \\192.168.1.100\PrinterKantor
echo  [3] Kembali
echo.
set "cnp="
set /p "cnp=  Pilih [1-3]: "
if "%cnp%"=="1" goto cn_ip
if "%cnp%"=="2" goto cn_path
goto menu

:cn_ip
set "serverip="
set /p "serverip=  Masukkan IP server - contoh 192.168.1.100: "
if not defined serverip goto connectprinter
echo.
echo  --- Shared resource yang ketemu di %serverip% ---
net view "\\%serverip%" 2>nul
echo.
set "printername="
set /p "printername=  Masukkan nama printer-nya: "
if not defined printername goto cn_ip
echo.
echo  Connecting ke \\%serverip%\%printername% ...
rundll32 printui.dll,PrintUIEntry /in /n "\\%serverip%\%printername%"
echo.
echo  Selesai! Cek di Devices and Printers.
pause
goto menu

:cn_path
set "printpath="
set /p "printpath=  Masukkan path lengkap: "
if not defined printpath goto connectprinter
echo.
echo  Connecting ke %printpath% ...
rundll32 printui.dll,PrintUIEntry /in /n "%printpath%"
echo.
echo  Selesai! Cek di Devices and Printers.
pause
goto menu

:: ==========================================================
::  [27] LIST PRINTER & STATUS
:: ==========================================================
:listprinter
cls
echo.
echo  ============================================
echo   LIST PRINTER DAN STATUS
echo  ============================================
echo.
powershell -NoProfile -Command "'=== SEMUA PRINTER ==='; Get-WmiObject Win32_Printer | Select-Object Name,DriverName,PortName,Shared,ShareName | Format-Table -AutoSize; ''; '=== STATUS ==='; Get-WmiObject Win32_Printer | Select-Object Name,Default,WorkOffline,PrinterState,PrinterStatus | Format-Table -AutoSize; ''; '=== YANG DI-SHARE ==='; Get-WmiObject Win32_Printer | Where-Object {$_.Shared} | Select-Object Name,ShareName | Format-Table -AutoSize"
echo.
pause
goto menu

:: ==========================================================
::  [28] SET DEFAULT PRINTER - via WScript, jalan di semua versi
:: ==========================================================
:defaultprinter
cls
echo.
echo  ============================================
echo   SET DEFAULT PRINTER
echo  ============================================
echo.
echo  --- List Printer - kolom Default = True berarti default sekarang ---
powershell -NoProfile -Command "Get-WmiObject Win32_Printer | Select-Object Name,Default,PortName | Format-Table -AutoSize"
echo.
set "dfname="
set /p "dfname=  Masukkan nama printer untuk dijadikan default: "
if not defined dfname goto defaultprinter
echo.
powershell -NoProfile -Command "(New-Object -ComObject WScript.Network).SetDefaultPrinter('%dfname%')" 2>nul
if errorlevel 1 (
    echo  [ERROR] Gagal set default. Nama printer harus persis!
) else (
    echo  Default printer berhasil diubah ke "%dfname%".
)
echo.
pause
goto menu

:: ==========================================================
::  [29] RESTART PRINT SPOOLER
:: ==========================================================
:restartspooler
cls
echo.
echo  ============================================
echo   RESTART PRINT SPOOLER
echo  ============================================
echo.
echo  [1/3] Stop Print Spooler...
net stop spooler
echo.
echo  [2/3] Bersihkan file print queue macet...
del /Q /F /S "%SystemRoot%\System32\spool\PRINTERS\*" >nul 2>&1
echo       Selesai.
echo.
echo  [3/3] Start Print Spooler...
net start spooler
echo.
echo  ============================================
echo   Print Spooler berhasil direstart!
echo  ============================================
echo.
pause
goto menu

:: ==========================================================
::  [30] CLEAR PRINT QUEUE - via WMI Win32_PrintJob
:: ==========================================================
:clearqueue
cls
echo.
echo  ============================================
echo   CLEAR PRINT QUEUE
echo  ============================================
echo.
echo  [1] Lihat antrian print saat ini
echo  [2] Hapus semua antrian
echo  [3] Hapus antrian printer tertentu
echo  [4] Kembali
echo.
set "clq="
set /p "clq=  Pilih [1-4]: "
if "%clq%"=="1" goto cq_view
if "%clq%"=="2" goto cq_all
if "%clq%"=="3" goto cq_one
goto menu

:cq_view
echo.
powershell -NoProfile -Command "$j=Get-WmiObject Win32_PrintJob; if($j){$j | Select-Object JobId,Name,Document,Owner,TotalPages,Status | Format-Table -AutoSize}else{'(antrian kosong)'}"
echo.
pause
goto menu

:cq_all
echo.
echo  Menghapus semua antrian...
net stop spooler >nul 2>&1
del /Q /F /S "%SystemRoot%\System32\spool\PRINTERS\*" >nul 2>&1
net start spooler >nul 2>&1
echo  Semua antrian berhasil dihapus!
pause
goto menu

:cq_one
set "cqname="
set /p "cqname=  Masukkan nama printer: "
if not defined cqname goto clearqueue
echo.
powershell -NoProfile -Command "Get-WmiObject Win32_PrintJob | Where-Object {$_.Name -like '%cqname%,*'} | Remove-WmiObject"
echo  Antrian "%cqname%" sudah dibersihkan.
pause
goto menu

:: ==========================================================
::  [31] BACKUP / RESTORE PRINTER SETTINGS
:: ==========================================================
:backupprinter
cls
echo.
echo  ============================================
echo   BACKUP / RESTORE PRINTER SETTINGS
echo  ============================================
echo.
set "PBACKUP=%CURR_DIR%PrinterBackup_%TODAY%"
echo  Folder backup default: %PBACKUP%
echo.
echo  [1] Backup printer settings
echo  [2] Restore printer settings dari backup
echo  [3] Export list printer ke TXT
echo  [4] Kembali
echo.
set "bkp="
set /p "bkp=  Pilih [1-4]: "
if "%bkp%"=="1" goto bp_do
if "%bkp%"=="2" goto bp_restore
if "%bkp%"=="3" goto bp_txt
goto menu

:bp_do
mkdir "%PBACKUP%" 2>nul
echo.
echo  Backup ke: %PBACKUP%
echo.
echo  [1/3] Export list printer...
powershell -NoProfile -Command "Get-WmiObject Win32_Printer | Select-Object Name,PortName,DriverName,Shared,ShareName | Export-Csv -Path '%PBACKUP%\printers.csv' -NoTypeInformation"
echo       Selesai.
echo.
echo  [2/3] Export driver printer...
powershell -NoProfile -Command "Get-WmiObject Win32_PrinterDriver | Export-Csv -Path '%PBACKUP%\drivers.csv' -NoTypeInformation"
echo       Selesai.
echo.
echo  [3/3] Export registry printer...
reg export "HKLM\SYSTEM\CurrentControlSet\Control\Print" "%PBACKUP%\print.reg" /y >nul 2>&1
echo       Selesai.
echo.
echo  Backup selesai!
pause
goto menu

:bp_restore
echo.
echo  [!] WARNING: Ini akan me-restore printer settings dari backup.
echo  Pastikan folder backup valid dan printer masih terhubung!
echo.
set "bpath="
set /p "bpath=  Masukkan path folder backup: "
if not defined bpath goto backupprinter
if not exist "%bpath%\print.reg" (
    echo  [ERROR] File print.reg tidak ditemukan di folder itu!
    pause
    goto menu
)
echo.
echo  Restoring registry...
reg import "%bpath%\print.reg"
echo.
echo  Restart Print Spooler...
net stop spooler >nul 2>&1
net start spooler >nul 2>&1
echo.
echo  Restore selesai!
pause
goto menu

:bp_txt
echo.
set "txpath="
set /p "txpath=  Path untuk save - contoh C:\printer_list.txt: "
if not defined txpath goto backupprinter
echo.
powershell -NoProfile -Command "Get-WmiObject Win32_Printer | Select-Object Name,PortName,DriverName,Shared,ShareName,Default | Format-List" > "%txpath%"
echo  Berhasil di-export ke %txpath%
pause
goto menu

:: ==========================================================
::  [32] INSTALL TOMCAT ICHA PRINT
:: ==========================================================
:tomcat
cls
echo.
echo  ============================================================
echo   INSTALL OTOMATIS TOMCAT ICHA PRINT
echo   Java + Tomcat + Config + Service + Browser
echo  ============================================================
echo.

call :detect_java
call :detect_tomcat

echo   [!] Java   : %JAVA_PATH%
echo   [!] Tomcat : %TOMCAT_PATH%
echo.

if defined JAVA_PATH goto tc_have_java
echo ==========================================
echo   [1/6] INSTALL JAVA (JRE 8u281)
echo ==========================================
if not exist "%CURR_DIR%jre-8u281-windows-x64.exe" (
    echo   [ERROR] File jre-8u281-windows-x64.exe tidak ada di folder yang sama dengan script ini!
    echo   [INFO] Untuk PC 32-bit pakai installer jre-8u281-windows-i586.exe.
    pause
    goto menu
)
start /wait "" "%CURR_DIR%jre-8u281-windows-x64.exe"
set "JAVA_PATH="
for /l %%i in (1,1,180) do (
    if not defined JAVA_PATH (
        call :detect_java
        if not defined JAVA_PATH timeout /t 1 /nobreak >nul
    )
)
:tc_have_java
if defined JAVA_PATH goto tc_java_ok
echo   [ERROR] Folder Java tidak terdeteksi setelah install.
pause
goto menu

:tc_java_ok
echo   [1/6] Java OK: %JAVA_PATH%

if defined TOMCAT_PATH goto tc_have_tomcat
echo.
echo ==========================================
echo   [2/6] INSTALL TOMCAT 8.5.64
echo ==========================================
if not exist "%CURR_DIR%apache-tomcat-8.5.64.exe" (
    echo   [ERROR] File apache-tomcat-8.5.64.exe tidak ada di folder yang sama dengan script ini!
    pause
    goto menu
)
start /wait "" "%CURR_DIR%apache-tomcat-8.5.64.exe"
set "TOMCAT_PATH="
for /l %%i in (1,1,180) do (
    if not defined TOMCAT_PATH (
        call :detect_tomcat
        if not defined TOMCAT_PATH timeout /t 1 /nobreak >nul
    )
)
:tc_have_tomcat
if defined TOMCAT_PATH goto tc_tomcat_ok
echo   [ERROR] Folder Tomcat tidak terdeteksi setelah install.
pause
goto menu

:tc_tomcat_ok
echo   [2/6] Tomcat OK: %TOMCAT_PATH%
echo.

echo ==========================================
echo   [3/6] SET ENVIRONMENT VARIABLES
echo ==========================================
setx JAVA_HOME "%JAVA_PATH%" /M >nul
setx CATALINA_HOME "%TOMCAT_PATH%" /M >nul
set "JAVA_HOME=%JAVA_PATH%"
set "CATALINA_HOME=%TOMCAT_PATH%"
echo   - JAVA_HOME     = %JAVA_PATH%
echo   - CATALINA_HOME = %TOMCAT_PATH%
echo.

echo ==========================================
echo   [4/6] COPY FILE CONFIG
echo ==========================================
if exist "%CURR_DIR%server.xml" (
    copy /Y "%CURR_DIR%server.xml" "%TOMCAT_PATH%\conf\" >nul
    powershell -NoProfile -Command "$p='%TOMCAT_PATH%\conf\server.xml'; $c=Get-Content -LiteralPath $p -Raw; $c=$c.Replace('C:\Program Files\Apache Software Foundation\Tomcat 8.5','%TOMCAT_PATH%'); Set-Content -LiteralPath $p -Value $c -Encoding ASCII"
    echo   - server.xml
) else (
    echo   [!] server.xml tidak ada, dilewati.
)
if exist "%CURR_DIR%icha-print.war" (
    copy /Y "%CURR_DIR%icha-print.war" "%TOMCAT_PATH%\webapps\" >nul
    echo   - icha-print.war
) else (
    echo   [!] icha-print.war tidak ada, dilewati.
)
if exist "%CURR_DIR%keystore" (
    copy /Y "%CURR_DIR%keystore" "%TOMCAT_PATH%\" >nul
    echo   - keystore
) else (
    echo   [!] keystore tidak ada, dilewati.
)
echo.

echo ==========================================
echo   [5/6] START SERVICE TOMCAT (AUTO)
echo ==========================================
sc stop Tomcat8 >nul 2>&1
sc stop Tomcat >nul 2>&1
timeout /t 3 /nobreak >nul
set "SVC="
sc query Tomcat8 >nul 2>&1
if not errorlevel 1 set "SVC=Tomcat8"
sc query Tomcat >nul 2>&1
if not errorlevel 1 set "SVC=Tomcat"
if defined SVC goto tc_svc_found
echo   Service belum ada. Menginstall service Tomcat...
pushd "%TOMCAT_PATH%\bin"
call service.bat install
popd
set "SVC=Tomcat8"
sc query Tomcat8 >nul 2>&1
if errorlevel 1 set "SVC=Tomcat"
:tc_svc_found
sc config "%SVC%" start= auto
echo   - Service: %SVC%
net start "%SVC%"
set "RUNNING="
for /l %%i in (1,1,30) do (
    if not defined RUNNING (
        sc query "%SVC%" | findstr /C:"RUNNING" >nul
        if not errorlevel 1 set "RUNNING=1"
        if not defined RUNNING (
            timeout /t 3 /nobreak >nul
            net start "%SVC%" >nul 2>&1
        )
    )
)
if defined RUNNING (
    echo   Service RUNNING.
) else (
    echo   [WARNING] Service tidak RUNNING. Cek log di folder Tomcat.
)
echo.

echo ==========================================
echo   [6/6] BUKA BROWSER
echo ==========================================
set "PORT_OK="
for /l %%i in (1,1,60) do (
    if not defined PORT_OK (
        powershell -NoProfile -Command "try{$c=New-Object Net.Sockets.TcpClient;$c.Connect('127.0.0.1',8443);$c.Close();exit 0}catch{exit 1}" >nul 2>&1
        if not errorlevel 1 set "PORT_OK=1"
        if not defined PORT_OK timeout /t 2 /nobreak >nul
    )
)
if defined PORT_OK (
    echo   Tomcat aktif di https://localhost:8443
) else (
    echo   [WARNING] Port 8443 belum merespon. Cek log Tomcat.
)
start "" "https://localhost:8443"
echo.
echo  ============================================================
echo   INSTALL TOMCAT SELESAI!
echo  ============================================================
echo.
pause
goto menu

:: ==========================================================
::  [33] UNINSTALL TOMCAT & JRE (CLEAN)
:: ==========================================================
:uninstalltomcat
cls
echo.
echo  ============================================================
echo   UNINSTALL BERSIH APACHE TOMCAT + JAVA
echo  ============================================================
echo.
echo  [!] PERINGATAN: Ini akan menghapus Tomcat dan Java sepenuhnya!
echo  Pastikan tidak ada aplikasi lain yang butuh Java/Tomcat.
echo.
echo  [1] Lanjutkan Uninstall
echo  [2] Batal
echo.
set "utcp="
set /p "utcp=  Pilih [1-2]: "
if "%utcp%"=="2" goto menu
if not "%utcp%"=="1" goto uninstalltomcat

echo.
echo  [1/6] Mematikan service Tomcat dan menghapusnya...
taskkill /IM Tomcat8w.exe /F >nul 2>&1
net stop Tomcat8 >nul 2>&1
net stop Tomcat >nul 2>&1
sc delete Tomcat8 >nul 2>&1
sc delete Tomcat >nul 2>&1
for /l %%i in (1,1,10) do (
    sc query Tomcat8 >nul 2>&1
    if not errorlevel 1 (
        timeout /t 2 /nobreak >nul
        sc delete Tomcat8 >nul 2>&1
    )
    sc query Tomcat >nul 2>&1
    if not errorlevel 1 (
        timeout /t 2 /nobreak >nul
        sc delete Tomcat >nul 2>&1
    )
)
echo       Service Tomcat8/Tomcat sudah dihapus.
echo.

echo  [2/6] Uninstall Apache Tomcat dan hapus entri appwiz.cpl...
powershell -NoProfile -Command "$keys=@('HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\*','HKLM:\SOFTWARE\WOW6432Node\Microsoft\Windows\CurrentVersion\Uninstall\*','HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\*','HKCU:\SOFTWARE\WOW6432Node\Microsoft\Windows\CurrentVersion\Uninstall\*'); Get-ItemProperty $keys -ErrorAction SilentlyContinue | Where-Object { $_.DisplayName -match 'Apache Tomcat' } | ForEach-Object { $us=$_.UninstallString; if($us){ if($us -match '^\"([^\"]+)\"'){ $exe=$Matches[1] } else { $exe=$us }; if(Test-Path -LiteralPath $exe){ Write-Host '    - menjalankan uninstaller:' $exe; Start-Process -FilePath $exe -ArgumentList '/S' -Wait -NoNewWindow } }; Remove-Item -LiteralPath $_.PSPath -Recurse -Force -ErrorAction SilentlyContinue; Write-Host '    - entri appwiz Tomcat dihapus' }"
echo.

echo  [3/6] Uninstall Java dan hapus entri appwiz.cpl...
powershell -NoProfile -Command "$keys=@('HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\*','HKLM:\SOFTWARE\WOW6432Node\Microsoft\Windows\CurrentVersion\Uninstall\*','HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\*','HKCU:\SOFTWARE\WOW6432Node\Microsoft\Windows\CurrentVersion\Uninstall\*'); Get-ItemProperty $keys -ErrorAction SilentlyContinue | Where-Object { $_.DisplayName -match '^Java' } | ForEach-Object { $code=$_.PSChildName; if($code -match '^\{[0-9A-Fa-f\-]+\}$'){ Write-Host '    - menjalankan MsiExec untuk:' $_.DisplayName; Start-Process msiexec.exe -ArgumentList @('/x',$code,'/qn') -Wait -NoNewWindow -ErrorAction SilentlyContinue }; Remove-Item -LiteralPath $_.PSPath -Recurse -Force -ErrorAction SilentlyContinue; Write-Host '    - entri appwiz Java dihapus' }"
echo.

echo  [4/6] Menghapus sisa folder residual...
timeout /t 2 /nobreak >nul
takeown /F "C:\Program Files\Apache Software Foundation" /R /D Y >nul 2>&1
takeown /F "C:\Program Files (x86)\Apache Software Foundation" /R /D Y >nul 2>&1
takeown /F "C:\Program Files\Java" /R /D Y >nul 2>&1
takeown /F "C:\Program Files (x86)\Java" /R /D Y >nul 2>&1
icacls "C:\Program Files\Apache Software Foundation" /reset /T /C /Q >nul 2>&1
icacls "C:\Program Files (x86)\Apache Software Foundation" /reset /T /C /Q >nul 2>&1
icacls "C:\Program Files\Java" /reset /T /C /Q >nul 2>&1
icacls "C:\Program Files (x86)\Java" /reset /T /C /Q >nul 2>&1
for %%F in ("C:\Program Files\Apache Software Foundation" "C:\Program Files (x86)\Apache Software Foundation" "C:\Program Files\Java" "C:\Program Files (x86)\Java") do (
    for /l %%i in (1,1,10) do (
        if exist %%F (
            rmdir /s /q %%F >nul 2>&1
            timeout /t 2 /nobreak >nul
        )
    )
    if exist %%F echo   [WARNING] Gagal hapus folder %%F
)
echo       Folder residual sudah diproses.
echo.

echo  [5/6] Menghapus Environment Variable JAVA_HOME dan CATALINA_HOME...
reg delete "HKLM\SYSTEM\CurrentControlSet\Session Manager\Environment" /v JAVA_HOME /f >nul 2>&1
reg delete "HKLM\SYSTEM\CurrentControlSet\Session Manager\Environment" /v CATALINA_HOME /f >nul 2>&1
echo       Environment variables sudah dihapus.
echo.

echo  [6/6] Selesai!
echo.
echo  ============================================================
echo   UNINSTALL BERSIH SELESAI! SIAP INSTALL ULANG.
echo  ============================================================
echo.
pause
goto menu

:: ==========================================================
::  [34] JALANKAN SEMUA CEK
:: ==========================================================
:allcheck
cls
echo.
echo  ============================================================
echo   JALANKAN SEMUA CEK
echo  ============================================================
echo.

echo  [1/8] Ping Google DNS...
ping 8.8.8.8 -n 2 >nul 2>&1 && echo       OK || echo       GAGAL
echo.

echo  [2/8] Cek IP konfigurasi...
ipconfig >nul 2>&1 && echo       OK || echo       GAGAL
echo.

echo  [3/8] Cek Network Interface...
netsh interface ipv4 show interfaces >nul 2>&1 && echo       OK || echo       GAGAL
echo.

echo  [4/8] Cek disk space...
powershell -NoProfile -Command "Get-WmiObject Win32_LogicalDisk | Where-Object {$_.DriveType -eq 3} | Select-Object DeviceID,@{n='TotalGB';e={[math]::Round($_.Size/1GB,1)}},@{n='FreeGB';e={[math]::Round($_.FreeSpace/1GB,1)}} | Format-Table -AutoSize"
echo.

echo  [5/8] Cek Serial Number...
powershell -NoProfile -Command "(Get-WmiObject Win32_BIOS).SerialNumber" 2>nul
echo.

echo  [6/8] Info OS...
powershell -NoProfile -Command "(Get-WmiObject Win32_OperatingSystem).Caption+'  Build '+(Get-WmiObject Win32_OperatingSystem).BuildNumber"
echo.

echo  [7/8] Cek Windows Activation...
cscript //nologo %windir%\system32\slmgr.vbs /dli
echo.

echo  [8/8] Cek Printer...
powershell -NoProfile -Command "Get-WmiObject Win32_Printer | Select-Object Name,DriverName,Shared | Format-Table -AutoSize"
echo.

echo  ============================================================
echo   Semua cek selesai! Jalankan menu 1-33 untuk lihat detail.
echo  ============================================================
echo.
pause
goto menu

:: ==========================================================
::  [35] KELUAR
:: ==========================================================
:keluar
cls
echo.
echo.
echo  ============================================
echo    TERIMA KASIH TELAH MENGGUNAKAN
echo    IT SUPPORT TOOLKIT v2.2 UNIVERSAL
echo  ============================================
echo.
timeout /t 3 >nul
exit


:: ==========================================================
::  SUBROUTINE - DETEKSI JAVA
::  Dipanggil via "call", JANGAN dijalankan langsung.
::  Ditaruh di paling bawah supaya alur utama tidak jatuh
::  masuk ke sini dan mati di exit /b.
:: ==========================================================
:detect_java
set "JAVA_PATH="
if exist "C:\Program Files\Java\jre1.8.0_281" set "JAVA_PATH=C:\Program Files\Java\jre1.8.0_281"
if exist "C:\Program Files\Java\jre1.8.0_281_x64" set "JAVA_PATH=C:\Program Files\Java\jre1.8.0_281_x64"
if exist "C:\Program Files (x86)\Java\jre1.8.0_281" set "JAVA_PATH=C:\Program Files (x86)\Java\jre1.8.0_281"
if exist "C:\Program Files\Java\jre1.8.0_281_x86" set "JAVA_PATH=C:\Program Files\Java\jre1.8.0_281_x86"
if not defined JAVA_PATH for /d %%D in ("C:\Program Files\Java\jre*") do set "JAVA_PATH=%%D"
if not defined JAVA_PATH for /d %%D in ("C:\Program Files (x86)\Java\jre*") do set "JAVA_PATH=%%D"
if not defined JAVA_PATH for /d %%D in ("C:\Program Files\Java\jdk*") do set "JAVA_PATH=%%D"
if not defined JAVA_PATH for /d %%D in ("C:\Program Files (x86)\Java\jdk*") do set "JAVA_PATH=%%D"
exit /b

:: ==========================================================
::  SUBROUTINE - DETEKSI TOMCAT
:: ==========================================================
:detect_tomcat
set "TOMCAT_PATH="
if exist "C:\Program Files (x86)\Apache Software Foundation\Tomcat 8.5" set "TOMCAT_PATH=C:\Program Files (x86)\Apache Software Foundation\Tomcat 8.5"
if exist "C:\Program Files (x86)\Apache Software Foundation\Tomcat" set "TOMCAT_PATH=C:\Program Files (x86)\Apache Software Foundation\Tomcat"
if exist "C:\Program Files\Apache Software Foundation\Tomcat 8.5" set "TOMCAT_PATH=C:\Program Files\Apache Software Foundation\Tomcat 8.5"
if exist "C:\Program Files\Apache Software Foundation\Tomcat" set "TOMCAT_PATH=C:\Program Files\Apache Software Foundation\Tomcat"
exit /b