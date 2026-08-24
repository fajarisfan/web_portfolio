param($WINNAME, $WINMAJOR, $WINMINOR, $IS_ADMIN)

$sep = "=" * 118

# Header
Write-Host $sep -f DarkGray
Write-Host "  USER: " -f DarkGray -NoNewline
Write-Host "$env:USERNAME" -f Cyan -NoNewline
Write-Host "  |  COMPUTER: " -f DarkGray -NoNewline
Write-Host "$env:COMPUTERNAME" -f Cyan -NoNewline
Write-Host "  |  ADMIN: " -f DarkGray -NoNewline
if ($IS_ADMIN -eq 'Y') { Write-Host "YES" -f Green -NoNewline } else { Write-Host "NO  <-- RUN AS ADMIN" -f Red -NoNewline }
Write-Host "  |  OS: " -f DarkGray -NoNewline
Write-Host "$WINNAME" -f Magenta
Write-Host "  KERNEL: " -f DarkGray -NoNewline
Write-Host "$WINMAJOR.$WINMINOR" -f Cyan -NoNewline
Write-Host "  |  TOOLKIT: " -f DarkGray -NoNewline
Write-Host "IT-TOOLKIT v2.3 UNIVERSAL  WIN7 - WIN11" -f Yellow
Write-Host $sep -f DarkGray
Write-Host ""

# Kolom kiri & kanan
$kiri = @(
    @{ h="NETWORK"; hc="Yellow" },
    @{ n="[1] "; nc="Cyan"; t=" Cek Koneksi Internet - Ping" },
    @{ n="[2] "; nc="Cyan"; t=" Cek IP Address" },
    @{ n="[3] "; nc="Cyan"; t=" Cek Network Interface" },
    @{ n="[4] "; nc="Cyan"; t=" Flush DNS + Renew IP + Reset Winsock" },
    @{ n="[5] "; nc="Cyan"; t=" Enable / Disable WiFi Adapter" },
    @{ h=""; hc="DarkGray" },
    @{ h="SYSTEM"; hc="Yellow" },
    @{ n="[6] "; nc="Cyan"; t=" Info OS dan Hardware" },
    @{ n="[7] "; nc="Cyan"; t=" Cek Serial Number CPU / Mobo / BIOS" },
    @{ n="[8] "; nc="Cyan"; t=" Cek Harddisk - chkdsk" },
    @{ n="[9] "; nc="Cyan"; t=" Clean Temp Files" },
    @{ n="[10]"; nc="Cyan"; t=" Kill Process Frozen" },
    @{ n="[11]"; nc="Cyan"; t=" Cek Windows Activation" },
    @{ n="[12]"; nc="Cyan"; t=" Cek Suhu CPU" },
    @{ h=""; hc="DarkGray" },
    @{ h="DRIVER"; hc="Yellow" },
    @{ n="[13]"; nc="Cyan"; t=" Scan Hardware Tanpa Driver" },
    @{ n="[14]"; nc="Cyan"; t=" Update Driver Otomatis" },
    @{ h=""; hc="DarkGray" },
    @{ h="USER ACCOUNT"; hc="Yellow" },
    @{ n="[15]"; nc="Cyan"; t=" Reset Password User" },
    @{ n="[16]"; nc="Cyan"; t=" Enable / Disable Admin Account" },
    @{ h=""; hc="DarkGray" },
    @{ h="WINDOWS REPAIR"; hc="Yellow" },
    @{ n="[17]"; nc="Cyan"; t=" Repair Windows Update - SFC + DISM" },
    @{ n="[18]"; nc="Cyan"; t=" Repair .NET Framework" },
    @{ n="[19]"; nc="Cyan"; t=" Reset Windows Firewall" },
    @{ h=""; hc="DarkGray" },
    @{ h="UTILITIES"; hc="Yellow" },
    @{ n="[20]"; nc="Cyan"; t=" Enable / Disable Remote Desktop" },
    @{ n="[21]"; nc="Cyan"; t=" Backup Registry" },
    @{ n="[22]"; nc="Cyan"; t=" Uninstall Program" },
    @{ n="[23]"; nc="Cyan"; t=" Shutdown / Restart Timer" }
)

$kanan = @(
    @{ h="PRINTER"; hc="Red" },
    @{ n="[24]"; nc="Red"; t=" Download Driver Printer" },
    @{ n="[25]"; nc="Red"; t=" Share / Unshare Printer" },
    @{ n="[26]"; nc="Red"; t=" Connect ke Shared Printer by IP" },
    @{ n="[27]"; nc="Red"; t=" List Printer dan Status" },
    @{ n="[28]"; nc="Red"; t=" Set Default Printer" },
    @{ n="[29]"; nc="Red"; t=" Restart Print Spooler" },
    @{ n="[30]"; nc="Red"; t=" Clear Print Queue" },
    @{ n="[31]"; nc="Red"; t=" Backup / Restore Printer Settings" },
    @{ h=""; hc="DarkGray" },
    @{ h="TOMCAT"; hc="Magenta" },
    @{ n="[32]"; nc="Magenta"; t=" Install Tomcat Icha Print - Full" },
    @{ n="[33]"; nc="Magenta"; t=" Uninstall Tomcat + JRE - Clean" },
    @{ h=""; hc="DarkGray" },
    @{ h="POST INSTALL"; hc="Magenta" },
    @{ n="[34]"; nc="Magenta"; t=" Install Apps - Chrome, Firefox, Office, WinRAR, dll" }
)

$maxRows = [Math]::Max($kiri.Count, $kanan.Count)
$leftWidth = 55

for ($i = 0; $i -lt $maxRows; $i++) {
    # --- kiri ---
    $leftText = ""
    if ($i -lt $kiri.Count) {
        $item = $kiri[$i]
        if ($item.ContainsKey('h')) {
            if ($item.h -ne "") {
                $label = "  " + $item.h
                Write-Host $label.PadRight($leftWidth) -f $item.hc -NoNewline
            } else {
                Write-Host ("  " + ("-" * 48)).PadRight($leftWidth) -f DarkGray -NoNewline
            }
        } else {
            Write-Host "  " -NoNewline
            Write-Host $item.n -f $item.nc -NoNewline
            $t = $item.t
            $full = ("  " + $item.n + $t)
            Write-Host $t.PadRight($leftWidth - 2 - $item.n.Length) -f White -NoNewline
        }
    } else {
        Write-Host (" " * $leftWidth) -NoNewline
    }

    # --- kanan ---
    if ($i -lt $kanan.Count) {
        $item = $kanan[$i]
        if ($item.ContainsKey('ascii')) {
            Write-Host "  " -NoNewline
            Write-Host $item.ascii -f DarkYellow
        } elseif ($item.ContainsKey('h')) {
            if ($item.h -ne "") {
                Write-Host "  $($item.h)" -f $item.hc
            } else {
                Write-Host ("  " + ("-" * 48)) -f DarkGray
            }
        } else {
            Write-Host "  " -NoNewline
            Write-Host $item.n -f $item.nc -NoNewline
            Write-Host $item.t -f White
        }
    } else {
        Write-Host ""
    }
}

Write-Host ""
Write-Host $sep -f DarkGray
Write-Host "  " -NoNewline
Write-Host "[35] RUN ALL CHECKS" -f Green -NoNewline
Write-Host "                                                              " -NoNewline
Write-Host "[36] EXIT" -f DarkRed
Write-Host $sep -f DarkGray
Write-Host "  root@IT-TOOLKIT # _" -f Cyan
Write-Host $sep -f DarkGray
Write-Host ""
