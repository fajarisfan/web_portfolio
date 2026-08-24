@echo off
title IT SUPPORT TOOLKIT v2.3 UNIVERSAL
color 0A
mode con: cols=120 lines=40
powershell -NoProfile -Command "$w=(Get-Process -Id $PID).MainWindowHandle; if($w){Add-Type -TypeDefinition 'using System;using System.Runtime.InteropServices;public class W{[DllImport(\"user32.dll\")]public static extern bool ShowWindow(IntPtr h,int n);}'; [W]::ShowWindow($w,3)}" >nul 2>&1
powershell -NoProfile -ExecutionPolicy Bypass -File "%~dp0splash.ps1"

set "CURR_DIR=%~dp0"

for /f %%i in ('powershell -NoProfile -Command "Get-Date -Format yyyyMMdd"') do set "TODAY=%%i"

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
set "IS_ADMIN=N"
fltmc >nul 2>&1 && set "IS_ADMIN=Y"


:menu
cls
powershell -NoProfile -ExecutionPolicy Bypass -File "%~dp0menu.ps1" "%WINNAME%" "%WINMAJOR%" "%WINMINOR%" "%IS_ADMIN%"
echo.
set "pilih="
set /p "pilih=  pilih [1-36]: "
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
if "%pilih%"=="34" goto apps_menu
if "%pilih%"=="35" goto allcheck
if "%pilih%"=="36" goto keluar
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
echo  ========================================================
echo   CEK KONEKSI INTERNET - PING
echo  ========================================================
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
echo  ========================================================
echo   CEK IP ADDRESS
echo  ========================================================
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
echo  ========================================================
echo   CEK NETWORK INTERFACE
echo  ========================================================
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
echo  ========================================================
echo   FLUSH DNS + RENEW IP + RESET WINSOCK
echo  ========================================================
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
echo  ========================================================
echo   Selesai! Restart komputer jika perlu.
echo  ========================================================
echo.
pause
goto menu

:: ==========================================================
::  [5] ENABLE / DISABLE WIFI ADAPTER
:: ==========================================================
:wifi
cls
echo.
echo  ========================================================
echo   ENABLE / DISABLE WIFI ADAPTER
echo  ========================================================
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
::  [6] INFO OS & HARDWARE
:: ==========================================================
:sysinfo
cls
echo.
echo  ========================================================
echo   INFO OS DAN HARDWARE
echo  ========================================================
echo.
echo  --- OS Info ---
powershell -NoProfile -Command "=Get-WmiObject Win32_OperatingSystem; 'OS        : '+.Caption; 'Arsitektur: '+.OSArchitecture; 'Versi     : '+.Version+'  Build '+.BuildNumber; 'RAM Total : '+[math]::Round(.TotalVisibleMemorySize/1MB,1)+' GB'"
echo.
echo  --- CPU Info ---
powershell -NoProfile -Command "Get-WmiObject Win32_Processor | Select-Object Name,NumberOfCores,NumberOfLogicalProcessors,MaxClockSpeed | Format-List"
echo.
echo  --- RAM Info (per keping) ---
powershell -NoProfile -Command "Get-WmiObject Win32_PhysicalMemory | Select-Object Manufacturer,PartNumber,@{n='GB';e={[math]::Round(.Capacity/1GB,1)}},Speed | Format-Table -AutoSize"
echo.
echo  --- Disk Space ---
powershell -NoProfile -Command "Get-WmiObject Win32_LogicalDisk | Where-Object {.DriveType -eq 3} | Select-Object DeviceID,VolumeName,FileSystem,@{n='TotalGB';e={[math]::Round(.Size/1GB,1)}},@{n='FreeGB';e={[math]::Round(.FreeSpace/1GB,1)}} | Format-Table -AutoSize"
echo.
pause
goto menu

:: ==========================================================
::  [7] CEK SERIAL NUMBER CPU/MOBO/BIOS
:: ==========================================================
:serial
cls
echo.
echo  ========================================================
echo   CEK SERIAL NUMBER DAN INFO
echo  ========================================================
echo.
powershell -NoProfile -Command "'=== CPU ==='; Get-WmiObject Win32_Processor | Select-Object Name,ProcessorId | Format-List; '=== Motherboard ==='; Get-WmiObject Win32_BaseBoard | Select-Object Manufacturer,Product,SerialNumber | Format-List; '=== BIOS ==='; Get-WmiObject Win32_BIOS | Select-Object Manufacturer,SMBIOSBIOSVersion,SerialNumber | Format-List"
pause
goto menu

:: ==========================================================
::  [8] CEK HARDDISK (CHKDSK)
:: ==========================================================
:chkdsk
cls
echo.
echo  ========================================================
echo   CEK HARDDISK - CHKDSK
echo  ========================================================
echo.
echo  [1] Cek semua drive - read-only, aman
echo  [2] Cek drive C: saja - read-only
echo  [3] Fix error C: otomatis - /f /r
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
echo  ========================================================
echo   CLEAN TEMP FILES
echo  ========================================================
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
rd /s /q "C:\.Bin" >nul 2>&1
echo       Selesai.
echo.
echo  ========================================================
echo   Temp files dibersihkan!
echo  ========================================================
echo.
pause
goto menu

:: ==========================================================
::  [10] KILL PROCESS FROZEN
:: ==========================================================
:killproc
cls
echo.
echo  ========================================================
echo   KILL PROCESS FROZEN
echo  ========================================================
echo.
echo  --- Process yang NOT RESPONDING ---
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
set /p "pname=  Masukkan nama process: "
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
echo  ========================================================
echo   CEK WINDOWS ACTIVATION
echo  ========================================================
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
echo  ========================================================
echo   CEK SUHU CPU
echo  ========================================================
echo.
powershell -NoProfile -Command "=Get-WmiObject -Namespace 'root\wmi' -Class MSAcpi_ThermalZoneTemperature -ErrorAction SilentlyContinue; if(){ | ForEach-Object { '{0} : {1:N1} Celsius' -f .InstanceName, (.CurrentTemperature/10-273.15) }}else{'Sensor suhu tidak tersedia via WMI.'}"
echo.
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
echo  ========================================================
echo   SCAN HARDWARE TANPA DRIVER
echo  ========================================================
echo.
pnputil /scan-devices >nul 2>&1
echo  Scan perangkat sudah dicoba via pnputil.
echo.
start devmgmt.msc
pause
goto menu

:: ==========================================================
::  [14] UPDATE DRIVER OTOMATIS
:: ==========================================================
:driver_update
cls
echo.
echo  ========================================================
echo   UPDATE DRIVER OTOMATIS
echo  ========================================================
echo.
if "%IS_TEN%"=="Y" goto du_ten
wuauclt /detectnow 2>nul
start "" control /name Microsoft.WindowsUpdate
pause
goto menu

:du_ten
usoclient StartScan 2>nul
timeout /t 3 /nobreak >nul
start ms-settings:windowsupdate
pause
goto menu

:: ==========================================================
::  [15] RESET PASSWORD USER
:: ==========================================================
:resetpw
cls
echo.
echo  ========================================================
echo   RESET PASSWORD USER
echo  ========================================================
echo.
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
echo  ========================================================
echo   ENABLE / DISABLE ADMIN ACCOUNT
echo  ========================================================
echo.
powershell -NoProfile -Command "=Get-WmiObject Win32_UserAccount | Where-Object {.LocalAccount -and .Name -eq 'Administrator'}; if(){'Administrator ada. Status Disabled = '+.Disabled}else{'User Administrator tidak ada di sistem ini'}"
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
::  [17] REPAIR WINDOWS UPDATE
:: ==========================================================
:repairupdate
cls
echo.
echo  ========================================================
echo   REPAIR WINDOWS UPDATE - SFC + DISM
echo  ========================================================
echo.
if "%HAS_DISM%"=="Y" goto ru_dism
sfc /scannow
echo.
echo  ========================================================
echo   Repair selesai! Restart jika perlu.
echo  ========================================================
echo.
pause
goto menu

:ru_dism
echo  Proses bisa makan waktu 10-30 menit.
echo.
DISM /Online /Cleanup-Image /CheckHealth
echo.
DISM /Online /Cleanup-Image /RestoreHealth
echo.
sfc /scannow
echo.
echo  ========================================================
echo   Repair selesai! Restart jika perlu.
echo  ========================================================
echo.
pause
goto menu

:: ==========================================================
::  [18] REPAIR .NET FRAMEWORK
:: ==========================================================
:dotnet
cls
echo.
echo  ========================================================
echo   REPAIR .NET FRAMEWORK
echo  ========================================================
echo.
if "%HAS_DISM%"=="Y" goto dn_new
sfc /scannow
echo.
pause
goto menu

:dn_new
DISM /Online /Enable-Feature /FeatureName:NetFx3 /All
echo.
sfc /scannow
echo.
pause
goto menu

:: ==========================================================
::  [19] RESET WINDOWS FIREWALL
:: ==========================================================
:firewall
cls
echo.
echo  ========================================================
echo   RESET WINDOWS FIREWALL
echo  ========================================================
echo.
netsh advfirewall show allprofiles state
echo.
echo  [1] Reset Firewall ke default
echo  [2] Matikan Firewall
echo  [3] Nyalakan Firewall
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
echo  Firewall di-reset ke default.
pause
goto menu

:fw_off
netsh advfirewall set allprofiles state off
echo  Firewall dimatikan.
pause
goto menu

:fw_on
netsh advfirewall set allprofiles state on
echo  Firewall dinyalakan.
pause
goto menu

:: ==========================================================
::  [20] ENABLE / DISABLE REMOTE DESKTOP
:: ==========================================================
:rdp
cls
echo.
echo  ========================================================
echo   ENABLE / DISABLE REMOTE DESKTOP
echo  ========================================================
echo.
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
echo  Remote Desktop di-ENABLE.
pause
goto menu

:rdp_off
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Terminal Server" /v fDenyTSConnections /t REG_DWORD /d 1 /f >nul
echo  Remote Desktop di-DISABLE.
pause
goto menu

:: ==========================================================
::  [21] BACKUP REGISTRY
:: ==========================================================
:backupreg
cls
echo.
echo  ========================================================
echo   BACKUP REGISTRY
echo  ========================================================
echo.
set "BACKUPDIR=%CURR_DIR%RegistryBackup_%TODAY%"
mkdir "%BACKUPDIR%" 2>nul
echo  Folder backup: %BACKUPDIR%
echo.
echo  [1] Backup Full
echo  [2] Backup HKCU saja
echo  [3] Backup HKLM saja
echo  [4] Kembali
echo.
set "brp="
set /p "brp=  Pilih [1-4]: "
if "%brp%"=="1" goto br_full
if "%brp%"=="2" goto br_hkcu
if "%brp%"=="3" goto br_hklm
goto menu

:br_full
reg export "HKLM\SOFTWARE" "%BACKUPDIR%\HKLM_SOFTWARE.reg" /y
reg export "HKLM\SYSTEM" "%BACKUPDIR%\HKLM_SYSTEM.reg" /y
reg export HKCU "%BACKUPDIR%\HKCU.reg" /y
reg export HKCR "%BACKUPDIR%\HKCR.reg" /y
echo  Backup selesai!
pause
goto menu

:br_hkcu
reg export HKCU "%BACKUPDIR%\HKCU.reg" /y
echo  HKCU backup selesai!
pause
goto menu

:br_hklm
reg export "HKLM\SOFTWARE" "%BACKUPDIR%\HKLM_SOFTWARE.reg" /y
reg export "HKLM\SYSTEM" "%BACKUPDIR%\HKLM_SYSTEM.reg" /y
echo  HKLM backup selesai!
pause
goto menu

:: ==========================================================
::  [22] UNINSTALL PROGRAM
:: ==========================================================
:uninstall
cls
echo.
echo  ========================================================
echo   UNINSTALL PROGRAM
echo  ========================================================
echo.
echo  [1] List semua program
echo  [2] Uninstall by nama
echo  [3] Kembali
echo.
set "up="
set /p "up=  Pilih [1-3]: "
if "%up%"=="1" goto uni_list
if "%up%"=="2" goto uni_byname
goto menu

:uni_list
powershell -NoProfile -Command "Get-ItemProperty 'HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\*','HKLM:\SOFTWARE\WOW6432Node\Microsoft\Windows\CurrentVersion\Uninstall\*','HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\*' -ErrorAction SilentlyContinue | Where-Object {.DisplayName} | Sort-Object DisplayName | Select-Object DisplayName,DisplayVersion | Format-Table -AutoSize"
echo.
pause
goto menu

:uni_byname
echo.
set "progname="
set /p "progname=  Masukkan nama program: "
if not defined progname goto uninstall
powershell -NoProfile -Command "=@('HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\*','HKLM:\SOFTWARE\WOW6432Node\Microsoft\Windows\CurrentVersion\Uninstall\*','HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\*'); =Get-ItemProperty  -ErrorAction SilentlyContinue | Where-Object {.DisplayName -like '*%progname%*'} | Sort-Object {.DisplayName.Length} | Select-Object -First 1; if(-not ){Write-Host '[ERROR] Program tidak ditemukan'} else {Write-Host ('Target: '+.DisplayName); =.UninstallString; if(){=[regex]::Match(,'^\"([^\"]+)\"(.*)$'); if(.Success){Start-Process -FilePath .Groups[1].Value -ArgumentList .Groups[2].Value.Trim()} else {Start-Process cmd.exe -ArgumentList '/c', -Wait}; Write-Host 'Uninstaller dijalankan.'} else {Write-Host '[!] Program ini tidak punya UninstallString'}}"
echo.
pause
goto menu

:: ==========================================================
::  [23] SHUTDOWN / RESTART TIMER
:: ==========================================================
:timermenu
cls
echo.
echo  ========================================================
echo   SHUTDOWN / RESTART TIMER
echo  ========================================================
echo.
echo  [1] Shutdown sekarang
echo  [2] Restart sekarang
echo  [3] Shutdown dengan timer
echo  [4] Restart dengan timer
echo  [5] Batalkan shutdown/restart
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
shutdown /s /t 0
exit

:rs_now
shutdown /r /t 0
exit

:sd_timer
set "stime="
set /p "stime=  Masukkan detik: "
shutdown /s /t %stime%
echo  Shutdown dijadwalkan dalam %stime% detik.
pause
goto menu

:rs_timer
set "rtime="
set /p "rtime=  Masukkan detik: "
shutdown /r /t %rtime%
echo  Restart dijadwalkan dalam %rtime% detik.
pause
goto menu

:sd_cancel
shutdown /a 2>nul && echo  Dibatalkan! || echo  Tidak ada yang terjadwal.
pause
goto menu

:: ==========================================================
::  [24] DOWNLOAD DRIVER PRINTER
:: ==========================================================
:downloaddriver
cls
echo.
echo  ========================================================
echo   DOWNLOAD DRIVER PRINTER
echo  ========================================================
echo.
echo  [1] Epson
echo  [2] Canon
echo  [3] HP
echo  [4] Brother
echo  [5] Google
echo  [6] Kembali
echo.
set "dlp="
set /p "dlp=  Pilih [1-6]: "
if "%dlp%"=="1" start "" "https://www.epson.com.vn/support/download"
if "%dlp%"=="2" start "" "https://www.canon.co.id/support"
if "%dlp%"=="3" start "" "https://support.hp.com/us-en/drivers"
if "%dlp%"=="4" start "" "https://www.brother.co.id/support"
if "%dlp%"=="5" start "" "https://www.google.com/search?q=download+driver+printer"
echo.
pause
goto menu

:: ==========================================================
::  [25] SHARE / UNSHARE PRINTER
:: ==========================================================
:shareprinter
cls
echo.
echo  ========================================================
echo   SHARE / UNSHARE PRINTER
echo  ========================================================
echo.
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
set /p "shname=  Masukkan nama printer: "
if not defined shname goto shareprinter
set "shalias="
set /p "shalias=  Masukkan nama share: "
if not defined shalias goto sh_do
powershell -NoProfile -Command "=Get-WmiObject Win32_Printer | Where-Object {.Name -eq '%shname%'}; if(){.Shared=True; .ShareName='%shalias%'; .Put() | Out-Null; Write-Host 'OK! Di-share sebagai \\%computername%\%shalias%'}else{Write-Host '[ERROR] Printer tidak ditemukan'}"
echo.
pause
goto menu

:sh_undo
set "unname="
set /p "unname=  Masukkan nama printer: "
if not defined unname goto shareprinter
powershell -NoProfile -Command "=Get-WmiObject Win32_Printer | Where-Object {.Name -eq '%unname%'}; if(){.Shared=False; .Put() | Out-Null; Write-Host 'OK! Printer di-unshare'}else{Write-Host '[ERROR] Printer tidak ditemukan'}"
echo.
pause
goto menu

:: ==========================================================
::  [26] CONNECT KE SHARED PRINTER (BY IP)
:: ==========================================================
:connectprinter
cls
echo.
echo  ========================================================
echo   CONNECT KE SHARED PRINTER - BY IP
echo  ========================================================
echo.
echo  [1] Connect by IP
echo  [2] Connect by Path
echo  [3] Kembali
echo.
set "cnp="
set /p "cnp=  Pilih [1-3]: "
if "%cnp%"=="1" goto cn_ip
if "%cnp%"=="2" goto cn_path
goto menu

:cn_ip
set "serverip="
set /p "serverip=  Masukkan IP server: "
if not defined serverip goto connectprinter
net view "\\%serverip%" 2>nul
set "printername="
set /p "printername=  Masukkan nama printer: "
if not defined printername goto cn_ip
rundll32 printui.dll,PrintUIEntry /in /n "\\%serverip%\%printername%"
echo.
pause
goto menu

:cn_path
set "printpath="
set /p "printpath=  Masukkan path lengkap: "
if not defined printpath goto connectprinter
rundll32 printui.dll,PrintUIEntry /in /n "%printpath%"
echo.
pause
goto menu

:: ==========================================================
::  [27] LIST PRINTER & STATUS
:: ==========================================================
:listprinter
cls
echo.
echo  ========================================================
echo   LIST PRINTER DAN STATUS
echo  ========================================================
echo.
powershell -NoProfile -Command "Get-WmiObject Win32_Printer | Select-Object Name,DriverName,PortName,Shared,Default,WorkOffline | Format-Table -AutoSize"
echo.
pause
goto menu

:: ==========================================================
::  [28] SET DEFAULT PRINTER
:: ==========================================================
:defaultprinter
cls
echo.
echo  ========================================================
echo   SET DEFAULT PRINTER
echo  ========================================================
echo.
powershell -NoProfile -Command "Get-WmiObject Win32_Printer | Select-Object Name,Default,PortName | Format-Table -AutoSize"
echo.
set "dfname="
set /p "dfname=  Masukkan nama printer: "
if not defined dfname goto defaultprinter
powershell -NoProfile -Command "(New-Object -ComObject WScript.Network).SetDefaultPrinter('%dfname%')" 2>nul
echo.
pause
goto menu

:: ==========================================================
::  [29] RESTART PRINT SPOOLER
:: ==========================================================
:restartspooler
cls
echo.
echo  ========================================================
echo   RESTART PRINT SPOOLER
echo  ========================================================
echo.
net stop spooler
del /Q /F /S "%SystemRoot%\System32\spool\PRINTERS\*" >nul 2>&1
net start spooler
echo.
echo  Print Spooler berhasil direstart!
echo.
pause
goto menu

:: ==========================================================
::  [30] CLEAR PRINT QUEUE
:: ==========================================================
:clearqueue
cls
echo.
echo  ========================================================
echo   CLEAR PRINT QUEUE
echo  ========================================================
echo.
echo  [1] Lihat antrian
echo  [2] Hapus semua antrian
echo  [3] Kembali
echo.
set "clq="
set /p "clq=  Pilih [1-3]: "
if "%clq%"=="1" goto cq_view
if "%clq%"=="2" goto cq_all
goto menu

:cq_view
powershell -NoProfile -Command "=Get-WmiObject Win32_PrintJob; if(){ | Select-Object JobId,Name,Document,Owner,TotalPages,Status | Format-Table -AutoSize}else{'(antrian kosong)'}"
echo.
pause
goto menu

:cq_all
net stop spooler >nul 2>&1
del /Q /F /S "%SystemRoot%\System32\spool\PRINTERS\*" >nul 2>&1
net start spooler >nul 2>&1
echo  Semua antrian berhasil dihapus!
pause
goto menu

:: ==========================================================
::  [31] BACKUP / RESTORE PRINTER SETTINGS
:: ==========================================================
:backupprinter
cls
echo.
echo  ========================================================
echo   BACKUP / RESTORE PRINTER SETTINGS
echo  ========================================================
echo.
set "PBACKUP=%CURR_DIR%PrinterBackup_%TODAY%"
echo  [1] Backup printer settings
echo  [2] Restore printer settings
echo  [3] Export list ke TXT
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
powershell -NoProfile -Command "Get-WmiObject Win32_Printer | Select-Object Name,PortName,DriverName,Shared,ShareName | Export-Csv -Path '%PBACKUP%\printers.csv' -NoTypeInformation"
reg export "HKLM\SYSTEM\CurrentControlSet\Control\Print" "%PBACKUP%\print.reg" /y >nul 2>&1
echo  Backup selesai ke %PBACKUP%
pause
goto menu

:bp_restore
set "bpath="
set /p "bpath=  Masukkan path folder backup: "
if not defined bpath goto backupprinter
if not exist "%bpath%\print.reg" (
    echo  [!] File print.reg tidak ditemukan di %bpath%
    pause
    goto backupprinter
)
reg import "%bpath%\print.reg"
echo  Restore selesai! Restart Print Spooler mungkin diperlukan.
pause
goto menu

:bp_txt
mkdir "%PBACKUP%" 2>nul
powershell -NoProfile -Command "Get-WmiObject Win32_Printer | Select-Object Name,PortName,DriverName,Shared,Default | Format-Table -AutoSize | Out-File -FilePath '%PBACKUP%\printer_list.txt'"
echo  Export ke %PBACKUP%\printer_list.txt
pause
goto menu

:: ==========================================================
::  [32] INSTALL TOMCAT ICHA PRINT
:: ==========================================================
:tomcat
cls
echo.
echo  ========================================================
echo   INSTALL OTOMATIS TOMCAT ICHA PRINT
echo   Java + Tomcat + Config + Service + Browser
echo  ========================================================
echo.

call :detect_java
call :detect_tomcat

echo   [!] Java   : %JAVA_PATH%
echo   [!] Tomcat : %TOMCAT_PATH%
echo.

if defined JAVA_PATH goto tc_have_java
echo  ========================================================
echo   [1/6] INSTALL JAVA (JRE 8u281)
echo  ========================================================
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
echo  ========================================================
echo   [2/6] INSTALL TOMCAT 8.5.64
echo  ========================================================
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

echo  ========================================================
echo   [3/6] SET ENVIRONMENT VARIABLES
echo  ========================================================
setx JAVA_HOME "%JAVA_PATH%" /M >nul
setx CATALINA_HOME "%TOMCAT_PATH%" /M >nul
set "JAVA_HOME=%JAVA_PATH%"
set "CATALINA_HOME=%TOMCAT_PATH%"
echo   - JAVA_HOME     = %JAVA_PATH%
echo   - CATALINA_HOME = %TOMCAT_PATH%
echo.

echo  ========================================================
echo   [4/6] COPY FILE CONFIG
echo  ========================================================
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

echo  ========================================================
echo   [5/6] START SERVICE TOMCAT (AUTO)
echo  ========================================================
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

echo  ========================================================
echo   [6/6] BUKA BROWSER
echo  ========================================================
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
echo  ========================================================
echo   INSTALL TOMCAT ICHA PRINT SELESAI!
echo  ========================================================
echo.
pause
goto menu

:: ==========================================================
::  [33] UNINSTALL TOMCAT DAN JRE - CLEAN
:: ==========================================================
:uninstalltomcat
cls
echo.
echo  ========================================================
echo   UNINSTALL BERSIH APACHE TOMCAT + JAVA
echo  ========================================================
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
powershell -NoProfile -Command "$keys=@('HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\*','HKLM:\SOFTWARE\WOW6432Node\Microsoft\Windows\CurrentVersion\Uninstall\*','HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\*','HKCU:\SOFTWARE\WOW6432Node\Microsoft\Windows\CurrentVersion\Uninstall\*'); Get-ItemProperty $keys -ErrorAction SilentlyContinue | Where-Object { $_.DisplayName -match 'Apache Tomcat|Tomcat' } | ForEach-Object { $us=$_.UninstallString; if($us){ if($us -match '^\"([^\"]+)\"\s*(.*)'){ $exe=$Matches[1]; $arg=$Matches[2] } else { $exe=$us; $arg='' }; if(Test-Path -LiteralPath $exe){ Write-Host '    - menjalankan uninstaller:' $exe $arg; Start-Process -FilePath $exe -ArgumentList ($arg+' /S') -Wait -NoNewWindow } }; Remove-Item -LiteralPath $_.PSPath -Recurse -Force -ErrorAction SilentlyContinue; Write-Host '    - entri appwiz Tomcat dihapus' }"
echo.

echo  [3/6] Uninstall Java dan hapus entri appwiz.cpl...
powershell -NoProfile -Command "$keys=@('HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\*','HKLM:\SOFTWARE\WOW6432Node\Microsoft\Windows\CurrentVersion\Uninstall\*','HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\*','HKCU:\SOFTWARE\WOW6432Node\Microsoft\Windows\CurrentVersion\Uninstall\*'); Get-ItemProperty $keys -ErrorAction SilentlyContinue | Where-Object { $_.DisplayName -match 'Java' -and $_.DisplayName -notmatch 'Auto Updater' } | ForEach-Object { $code=$_.PSChildName; if($code -match '^\{[0-9A-Fa-f\-]+\}$'){ Write-Host '    - menjalankan MsiExec untuk:' $_.DisplayName; Start-Process msiexec.exe -ArgumentList @('/x',$code,'/qn') -Wait -NoNewWindow -ErrorAction SilentlyContinue } else { $us=$_.UninstallString; if($us){ Write-Host '    - menjalankan uninstaller:' $us; Start-Process cmd.exe -ArgumentList '/c',$us -Wait -NoNewWindow -ErrorAction SilentlyContinue } }; Remove-Item -LiteralPath $_.PSPath -Recurse -Force -ErrorAction SilentlyContinue; Write-Host '    - entri appwiz Java dihapus' }"
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
echo  ========================================================
echo   UNINSTALL BERSIH SELESAI! SIAP INSTALL ULANG.
echo  ========================================================
echo.
pause
goto menu

:: ==========================================================
::  [34] POST INSTALL APPS
:: ==========================================================
:apps_menu
cls
echo.
echo  ========================================================
echo   POST INSTALL APPS
echo  ========================================================
echo.
echo  Install aplikasi untuk Windows baru.
echo.
if "%IS_TEN%"=="N" goto apps_legacy

echo  Windows 10/11 terdeteksi - pakai winget.
echo.
echo  [1] Install Chrome + Firefox + WinRAR + 7-Zip
echo  [2] Install Notepad++ + VLC + Acrobat Reader
echo  [3] Install Office 2024 (via winget)
echo  [4] Install Office 2013 (via ODT)
echo  [5] Install SEMUA (Chrome, Firefox, Office, dll)
echo  [6] Kembali
echo.
set "ap="
set /p "ap=  Pilih [1-6]: "
if "%ap%"=="1" goto apps_browsers
if "%ap%"=="2" goto apps_utils
if "%ap%"=="3" goto apps_office24
if "%ap%"=="4" goto apps_office13
if "%ap%"=="5" goto apps_all
goto menu

:apps_browsers
echo.
echo  Install Chrome...
winget install --id Google.Chrome --accept-package-agreements --accept-source-agreements -e 2>nul
echo.
echo  Install Firefox...
winget install --id Mozilla.Firefox --accept-package-agreements --accept-source-agreements -e 2>nul
echo.
echo  Install WinRAR...
winget install --id RARLab.WinRAR --accept-package-agreements --accept-source-agreements -e 2>nul
echo.
echo  Install 7-Zip...
winget install --id 7zip.7zip --accept-package-agreements --accept-source-agreements -e 2>nul
echo.
echo  ========================================================
echo   Selesai install browsers + archivers!
echo  ========================================================
pause
goto apps_menu

:apps_utils
echo.
echo  Install Notepad++...
winget install --id Notepad++.Notepad++ --accept-package-agreements --accept-source-agreements -e 2>nul
echo.
echo  Install VLC...
winget install --id VideoLAN.VLC --accept-package-agreements --accept-source-agreements -e 2>nul
echo.
echo  Install Acrobat Reader...
winget install --id Adobe.Acrobat.Reader --accept-package-agreements --accept-source-agreements -e 2>nul
echo.
echo  ========================================================
echo   Selesai install utilities!
echo  ========================================================
pause
goto apps_menu

:apps_office24
echo.
echo  Install Microsoft Office 2024...
winget install --id Microsoft.Office --accept-package-agreements --accept-source-agreements -e 2>nul
echo.
echo  ========================================================
echo   Office 2024 install dimulai.
echo   Tunggu hingga selesai.
echo  ========================================================
pause
goto apps_menu

:apps_office13
echo.
echo  Download Office Deployment Tool...
set "ODT_URL=https://download.microsoft.com/download/2/7/A/27AF1BE3-DD20-4CB4-B154-EBAB8A7D4A7E/officedeploymenttool_15928-20218.exe"
set "ODT_EXE=%TEMP%\odt_setup.exe"
set "ODT_DIR=%TEMP%\odt"

powershell -NoProfile -Command "[Net.ServicePointManager]::SecurityProtocol=[Net.SecurityProtocolType]::Tls12; Invoke-WebRequest -Uri '%ODT_URL%' -OutFile '%ODT_EXE%' -UseBasicParsing" 2>nul
if not exist "%ODT_EXE%" (
    echo  [!] Gagal download ODT.
    pause
    goto apps_menu
)

echo  Extract ODT...
mkdir "%ODT_DIR%" 2>nul
"%ODT_EXE%" /quiet /extract:"%ODT_DIR%" 2>nul
timeout /t 5 /nobreak >nul

echo  Download Office 2013 files...
set "CONFIG_PATH=%ODT_DIR%\config.xml"
(
echo ^<Configuration^>
echo   ^<Add OfficeClientEdition="64" SourcePath="%ODT_DIR%\Office"^>
echo     ^<Product ID="HomeStudentR2013Volume"^^>
echo       ^<Language ID="id-ID" /^>
echo     ^/Product^>
echo   ^/Add^>
echo   ^<Display Level="None" AcceptEULA="TRUE" /^>
echo   ^<Property Name="SharedComputerLicensing" Value="0" /^>
echo ^/Configuration^>
) > "%CONFIG_PATH%"

"%ODT_DIR%\setup.exe" /download "%CONFIG_PATH%" 2>nul
echo  Download selesai. Install Office 2013...
"%ODT_DIR%\setup.exe" /configure "%CONFIG_PATH%" 2>nul

echo.
echo  ========================================================
echo   Office 2013 install dimulai.
echo  ========================================================
pause
goto apps_menu

:apps_all
echo.
echo  Installing semua aplikasi...
echo.
echo --- Browsers ^& Archivers ---
winget install --id Google.Chrome --accept-package-agreements --accept-source-agreements -e 2>nul
winget install --id Mozilla.Firefox --accept-package-agreements --accept-source-agreements -e 2>nul
winget install --id RARLab.WinRAR --accept-package-agreements --accept-source-agreements -e 2>nul
winget install --id 7zip.7zip --accept-package-agreements --accept-source-agreements -e 2>nul
echo.
echo  --- Utilities ---
winget install --id Notepad++.Notepad++ --accept-package-agreements --accept-source-agreements -e 2>nul
winget install --id VideoLAN.VLC --accept-package-agreements --accept-source-agreements -e 2>nul
winget install --id Adobe.Acrobat.Reader --accept-package-agreements --accept-source-agreements -e 2>nul
echo.
echo  --- Office ---
winget install --id Microsoft.Office --accept-package-agreements --accept-source-agreements -e 2>nul
echo.
echo  ========================================================
echo   Semua aplikasi sedang diinstall!
echo   Tunggu hingga selesai.
echo  ========================================================
pause
goto apps_menu

:apps_legacy
echo.
echo  Windows 7/8 terdeteksi. winget tidak tersedia.
echo.
echo  [1] Buka link download manual
echo  [2] Kembali
echo.
set "al="
set /p "al=  Pilih [1-2]: "
if "%al%"=="1" goto apps_manual
goto menu

:apps_manual
echo.
echo  Membuka browser ke halaman download...
start "" "https://www.google.com/search?q=download+chrome+offline+installer"
start "" "https://www.google.com/search?q=download+firefox+offline+installer"
start "" "https://www.google.com/search?q=download+winrar+64bit"
start "" "https://www.google.com/search?q=download+7zip"
echo.
echo  Buka link satu per satu dan download manual.
pause
goto menu

:: ==========================================================
::  [35] JALANKAN SEMUA CEK
:: ==========================================================
:allcheck
cls
echo.
echo  ========================================================
echo   JALANKAN SEMUA CEK
echo  ========================================================
echo.
echo  Menjalankan semua pengecekan secara berurutan...
echo  (Tekan Ctrl+C untuk berhenti)
echo.

echo  ========================================================
echo   [1/6] CEK KONEKSI INTERNET
echo  ========================================================
ping 8.8.8.8 -n 2 >nul
if errorlevel 1 (
    echo   [FAIL] Tidak ada koneksi internet
) else (
    echo   [OK] Koneksi internet aktif
)
echo.

echo  ========================================================
echo   [2/6] CEK IP ADDRESS
echo  ========================================================
ipconfig | findstr /i "IPv4"
echo.

echo  ========================================================
echo   [3/6] INFO OS
echo  ========================================================
powershell -NoProfile -Command "=Get-WmiObject Win32_OperatingSystem; .Caption+'  Build '+.BuildNumber+'  '+[math]::Round(.TotalVisibleMemorySize/1MB,1)+' GB RAM'"
echo.

echo  ========================================================
echo   [4/6] CEK HARDISK
echo  ========================================================
powershell -NoProfile -Command "Get-WmiObject Win32_LogicalDisk | Where-Object {.DriveType -eq 3} | ForEach-Object { .DeviceID+' '+[math]::Round(.FreeSpace/1GB,1)+'GB free / '+[math]::Round(.Size/1GB,1)+'GB' }"
echo.

echo  ========================================================
echo   [5/6] CEK PRINTER
echo  ========================================================
powershell -NoProfile -Command "=Get-WmiObject Win32_Printer; if(){ | ForEach-Object { '  '+.Name+' ('+.DriverName+')' }}else{'  Tidak ada printer'}"
echo.

echo  ========================================================
echo   [6/6] CEK WINDOWS ACTIVATION
echo  ========================================================
slmgr /xpr 2>nul
echo.

echo  ========================================================
echo   SEMUA CEK SELESAI!
echo  ========================================================
echo.
pause
goto menu

:: ==========================================================
::  [36] KELUAR
:: ==========================================================
:keluar
cls
echo.
echo                  _          _
echo              _/^|    _   ^|\_
echo            _/_ ^|   _^|\\\ ^| _\
echo          _/_/^| /  /   \^|\ ^|\_\_
echo        _/_/  ^|/  /  _  \/\^|  \_\_
echo      _/_/    ^|^|  ^| ^| \o/ ^|^|    \_\_
echo     /_/  ^| ^| ^|\ ^| \_ V  /^| ^| ^|  \_\
echo    //    ^|^|^| ^| \_/   \__/ ^| ^|^|^|    \\
echo   // __^| ^|^\  \          /  /^|^| ^|__ \\
echo  //_/ \^|^|^|^| \/\\        //\/ ^|^|^|^|/ \_\\
echo ///    \\\\\/   /        \   \////    \\\
echo ^|/      \/    ^|    ^|    ^|     \/      \^|
echo               /_^|  ^| ^|_  \
echo              ///_^| ^|_^|^|\_\ \
echo              ^|//^|^|/^|^|\/^|^|\^|
echo               / \/^|^|^|/^|^|/\/          'LEGENDS ARE NOT BORN OR
echo                 /^|/\^| \/               MADE, THEY JUST ARE'
echo                 \/  ^|
echo                                                -CLIVE BARKER
echo.
echo   ========================================================
echo     Session terminated. Goodbye, root.
echo   ========================================================
echo.
timeout /t 2 >nul
exit

:: ==========================================================
::  SUBROUTINES
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

:detect_tomcat
set "TOMCAT_PATH="
if exist "C:\Program Files (x86)\Apache Software Foundation\Tomcat 8.5" set "TOMCAT_PATH=C:\Program Files (x86)\Apache Software Foundation\Tomcat 8.5"
if exist "C:\Program Files (x86)\Apache Software Foundation\Tomcat" set "TOMCAT_PATH=C:\Program Files (x86)\Apache Software Foundation\Tomcat"
if exist "C:\Program Files\Apache Software Foundation\Tomcat 8.5" set "TOMCAT_PATH=C:\Program Files\Apache Software Foundation\Tomcat 8.5"
if exist "C:\Program Files\Apache Software Foundation\Tomcat" set "TOMCAT_PATH=C:\Program Files\Apache Software Foundation\Tomcat"
exit /b
