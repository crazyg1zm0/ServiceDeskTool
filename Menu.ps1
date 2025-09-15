function Show-Logo {
    Write-Host "
   _____                 _            _____            _      _              _ 
  / ____|               (_)          |  __ \          | |    | |            | |
 | (___   ___ _ ____   ___  ___ ___  | |  | | ___  ___| | __ | |_ ___   ___ | |
  \___ \ / _ \ '__\ \ / / |/ __/ _ \ | |  | |/ _ \/ __| |/ / | __/ _ \ / _ \| |
  ____) |  __/ |   \ V /| | (_|  __/ | |__| |  __/\__ \   <  | || (_) | (_) | |
 |_____/ \___|_|    \_/ |_|\___\___| |_____/ \___||___/_|\_\  \__\___/ \___/|_|                                                                              
                                                                            
" -ForegroundColor Yellow
Write-Host ""
}

# Load scripts
$scriptFolder = Join-Path $PSScriptRoot "Scripts"
$scripts = Get-ChildItem -Path $scriptFolder -Filter *.ps1

if ($scripts.Count -eq 0) {
    Write-Host "❌ No scripts found in: $scriptFolder" -ForegroundColor Red
    return
}

# Add a virtual "Exit" option
$scripts += [pscustomobject]@{ BaseName = "Exit"; FullName = $null }

do {
    Clear-Host
    Show-Logo
    # Display 3-column layout
    $columnCount = 3
    $columnWidth = 30
    for ($i = 0; $i -lt $scripts.Count; $i += $columnCount) {
        $line = ""
        for ($c = 0; $c -lt $columnCount; $c++) {
            $index = $i + $c
            if ($index -lt $scripts.Count) {
                $label = "[$($index + 1)] $($scripts[$index].BaseName)"
                $line += $label.PadRight($columnWidth)
            }
        }
        Write-Host $line
    }

    Write-Host ""
    $selection = Read-Host "Enter the number of the script to run"
    $index = [int]$selection - 1

    if ($index -ge 0 -and $index -lt $scripts.Count) {
        if ($scripts[$index].BaseName -eq "Exit") {
            Write-Host "👋 Exiting ServiceDeskTool menu..." -ForegroundColor Gray
            break
        }

        $selectedScript = $scripts[$index].FullName
        Write-Host "▶️ Running $($scripts[$index].BaseName).ps1..." -ForegroundColor Yellow
        try {
            & $selectedScript
        } catch {
            Write-Host "❌ Error running script: $_" -ForegroundColor Red
        }

        Read-Host "`n✅ Script finished. Press Enter to return to menu..."
    } else {
        Read-Host "❗ Invalid selection. Press Enter to try again..."
    }
} while ($true)
