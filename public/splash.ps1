cls

$dragon = @"

                                                                    ___
                                                                   / /\
              \                                                   / /  \
               \\                    __---^^^---__              / / /\ \
                \\                _-~             ~-_          / / /  \ \
                 \\             _-~     TOOLKIT      ~-_      | | |    \/
                  \\           /  _---___                \    | | |
                  / \         / _/       \___---~~~       \   \ \ \
                 / / \       / /  /\     /                 \   \ \ \__
                / /   \     / /  /  \   /         ___       \   \ \   \
               /  \    \   /  /__/   \ /         /   \       \   \/   /
              /    \    \ /           V          /  /\ \      /       /
             /      \    /            \         /  /  \ \    /       /
            / \      \  /              \       /  /    \ \  /       /
           /   \      \/                \     /  /      \ \/       /
          /     \      \                 \   /  /   /\   \        /
         /       \      \                 \ /  /   /  \   \      /
        /         \      \_____           /   /   /    \   \    /
       /           \          /\_________/   /   /   /\ \   \  /
      /             \        /              /   /   /  \ \   \/
     /_______________\______/_______________\__/___/    \ \
"@

$punk = @"

                          |
                       \  |  /
                  .     \ | /    .
                   '-.__|\|/|_.-'
                 .__  \  V  /
                    '-</     \
                 ----<|       _|
                  _.-<|  _   o(
                 '    / (.     >
                   .-'`. `    -
                  '    `   __.`
                        _)___(
                       //    \\
            jgs/VK    | |    | \
                      | |    |  \
"@

$sep = "=" * 118

Clear-Host
Write-Host ""
Write-Host $sep -f DarkGray
Write-Host ("  " + " " * 46 + "IT-TOOLKIT v2.3") -f Cyan
Write-Host ("  " + " " * 42 + "UNIVERSAL  WIN7 - WIN11") -f DarkCyan
Write-Host $sep -f DarkGray
Write-Host ""

# tampilkan naga di kiri, punk di kanan sejajar
$dragonLines = $dragon -split "`n"
$punkLines   = $punk   -split "`n"
$maxL = [Math]::Max($dragonLines.Count, $punkLines.Count)
$leftW = 72

for ($i = 0; $i -lt $maxL; $i++) {
    $l = if ($i -lt $dragonLines.Count) { $dragonLines[$i] } else { "" }
    $p = if ($i -lt $punkLines.Count)   { $punkLines[$i]   } else { "" }
    Write-Host $l.PadRight($leftW) -f DarkYellow -NoNewline
    Write-Host $p -f DarkYellow
}

Write-Host ""
Write-Host $sep -f DarkGray
Write-Host ("  " + " " * 30 + "'LEGENDS ARE NOT BORN OR MADE, THEY JUST ARE'  -Clive Barker") -f DarkGray
Write-Host $sep -f DarkGray
Write-Host ""
Write-Host "  " -NoNewline
Write-Host "Tekan ENTER untuk masuk menu..." -f Green
$null = Read-Host
