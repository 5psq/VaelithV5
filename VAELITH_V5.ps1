<#
    ██╗   ██╗ █████╗ ███████╗██╗     ██╗████████╗██╗  ██╗
    ██║   ██║██╔══██╗██╔════╝██║     ██║╚══██╔══╝██║  ██║
    ██║   ██║███████║█████╗  ██║     ██║   ██║   ███████║
    ╚██╗ ██╔╝██╔══██║██╔══╝  ██║     ██║   ██║   ██╔══██║
     ╚████╔╝ ██║  ██║███████╗███████╗██║   ██║   ██║  ██║
      ╚═══╝  ╚═╝  ╚═╝╚══════╝╚══════╝╚═╝   ╚═╝   ╚═╝  ╚═╝
    Forensic Scanner — V4 [discord.gg/vaelithh]
    Run from an ELEVATED (Admin) PowerShell session.
#>

# ==========================================
# --- ELEVATION CHECK ---
# ==========================================
$id = [System.Security.Principal.WindowsIdentity]::GetCurrent()
$p  = New-Object System.Security.Principal.WindowsPrincipal($id)
if (-not $p.IsInRole([System.Security.Principal.WindowsBuiltInRole]::Administrator)) {
    Write-Warning "VAELITH requirements Administrator privileges."
    Write-Warning "Right-click and choose 'Run as Administrator'."
    Read-Host "Press Enter to exit..."; exit
}

# ==========================================
# --- GLOBAL COLORS ---
# ==========================================
$C_Found   = "Red"
$C_Clean   = "Green"
$C_Info    = "Cyan"
$C_Warn    = "Yellow"
$C_Dim     = "DarkGray"
$C_White   = "White"
$C_Magenta = "Magenta"

# ==========================================
# --- MENU INTERFACE LOOP ---
# ==========================================
while ($true) {
    Clear-Host
    Write-Host ""
    Write-Host "  ██╗   ██╗ █████╗ ███████╗██╗     ██╗████████╗██╗  ██╗" -ForegroundColor $C_Info
    Write-Host "  ██║   ██║██╔══██╗██╔════╝██║     ██║╚══██╔══╝██║  ██║" -ForegroundColor $C_Info
    Write-Host "  ██║   ██║███████║█████╗  ██║     ██║   ██║   ███████║" -ForegroundColor $C_Info
    Write-Host "  ╚██╗ ██╔╝██╔══██║██╔══╝  ██║     ██║   ██║   ██╔══██║" -ForegroundColor $C_Info
    Write-Host "   ╚████╔╝ ██║  ██║███████╗███████╗██║   ██║   ██║  ██║" -ForegroundColor $C_Info
    Write-Host "    ╚═══╝  ╚═╝  ╚═╝╚══════╝╚══════╝╚═╝   ╚═╝   ╚═╝  ╚═╝" -ForegroundColor $C_Info
    Write-Host "  =======================================================" -ForegroundColor $C_Dim
    Write-Host "                   discord.gg/vaelithh                   " -ForegroundColor $C_White
    Write-Host "  =======================================================" -ForegroundColor $C_Dim
    Write-Host "    [7] PC SPECS + RESET DATE"  -ForegroundColor $C_Info
    Write-Host "    [6] LAST ACTIVITY VIEWER"   -ForegroundColor $C_Magenta
    Write-Host "    [5] PROCESS EXPLORER"       -ForegroundColor $C_Magenta
    Write-Host "    [4] PREFETCH VIEWER"        -ForegroundColor $C_Magenta
    Write-Host "    [3] SCANNER LOGS (Deep 20-Module Term Scan)" -ForegroundColor $C_Info
    Write-Host "    [2] BAM KEYS VIEWER"        -ForegroundColor $C_Magenta
    Write-Host "    [1] SYSTEM CHECK"           -ForegroundColor $C_Magenta
    Write-Host "    [0] EXIT"                   -ForegroundColor $C_Found
    Write-Host "  =======================================================" -ForegroundColor $C_Dim
    Write-Host ""
    
    $choice = Read-Host "  Select an option"

    switch ($choice) {

        "7" {
            # =========================================================
            # --- [7] PC SPECS + RESET DATE ---------------------------
            # =========================================================
            Clear-Host
            Write-Host ""
            Write-Host "  ==========================================" -ForegroundColor $C_Info
            Write-Host "        PC SPECS + RESET DATE VIEWER        " -ForegroundColor $C_White
            Write-Host "  ==========================================" -ForegroundColor $C_Dim
            Write-Host ""

            # --- OS & Identity ---
            $os      = Get-WmiObject Win32_OperatingSystem
            $cs      = Get-WmiObject Win32_ComputerSystem
            $bios    = Get-WmiObject Win32_BIOS
            $mb      = Get-WmiObject Win32_BaseBoard
            $cpu     = Get-WmiObject Win32_Processor | Select-Object -First 1
            $gpus    = Get-WmiObject Win32_VideoController | Where-Object { $_.Name -notmatch "Microsoft" }
            $disks   = Get-WmiObject Win32_DiskDrive
            $monitors = Get-WmiObject Win32_DesktopMonitor -ErrorAction SilentlyContinue

            $totalRamBytes = ($cs.TotalPhysicalMemory)
            $totalRamGB    = [math]::Round($totalRamBytes / 1GB, 2)
            $freeRamGB     = [math]::Round($os.FreePhysicalMemory / 1MB, 2)
            $usedRamGB     = [math]::Round($totalRamGB - $freeRamGB, 2)

            # --- SECTION: IDENTITY ---
            Write-Host "  [ IDENTITY ]" -ForegroundColor $C_Info
            Write-Host "  ──────────────────────────────────────────" -ForegroundColor $C_Dim
            Write-Host "  Computer Name   : " -NoNewline -ForegroundColor $C_Dim
            Write-Host "$env:COMPUTERNAME" -ForegroundColor $C_White
            Write-Host "  Current User    : " -NoNewline -ForegroundColor $C_Dim
            Write-Host "$env:USERNAME" -ForegroundColor $C_White
            Write-Host "  Domain / Wkgrp  : " -NoNewline -ForegroundColor $C_Dim
            Write-Host "$($cs.Domain)" -ForegroundColor $C_White
            Write-Host ""

            # --- SECTION: OPERATING SYSTEM ---
            Write-Host "  [ OPERATING SYSTEM ]" -ForegroundColor $C_Info
            Write-Host "  ──────────────────────────────────────────" -ForegroundColor $C_Dim
            Write-Host "  OS              : " -NoNewline -ForegroundColor $C_Dim
            Write-Host "$($os.Caption) ($($os.OSArchitecture))" -ForegroundColor $C_White
            Write-Host "  Build           : " -NoNewline -ForegroundColor $C_Dim
            Write-Host "$($os.BuildNumber)" -ForegroundColor $C_White
            Write-Host "  Version         : " -NoNewline -ForegroundColor $C_Dim
            Write-Host "$($os.Version)" -ForegroundColor $C_White
            Write-Host "  Install Date    : " -NoNewline -ForegroundColor $C_Dim
            try {
                $installDate = [Management.ManagementDateTimeConverter]::ToDateTime($os.InstallDate)
                Write-Host "$($installDate.ToString('dd/MM/yyyy  HH:mm:ss'))" -ForegroundColor $C_Warn
            } catch {
                Write-Host "N/A" -ForegroundColor $C_Dim
            }
            Write-Host "  Last Boot       : " -NoNewline -ForegroundColor $C_Dim
            try {
                $bootTime = [Management.ManagementDateTimeConverter]::ToDateTime($os.LastBootUpTime)
                $uptime   = (Get-Date) - $bootTime
                Write-Host "$($bootTime.ToString('dd/MM/yyyy  HH:mm:ss'))  (Up: $($uptime.Days)d $($uptime.Hours)h $($uptime.Minutes)m)" -ForegroundColor $C_White
            } catch {
                Write-Host "N/A" -ForegroundColor $C_Dim
            }
            Write-Host ""

            # --- SECTION: RESET / REINSTALL HISTORY ---
            Write-Host "  [ RESET / REINSTALL HISTORY ]" -ForegroundColor $C_Info
            Write-Host "  ──────────────────────────────────────────" -ForegroundColor $C_Dim

            # Method 1: Registry InstallDate (Unix timestamp)
            $regInstall = $null
            try {
                $regTS = (Get-ItemProperty "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion" -Name "InstallDate" -ErrorAction Stop).InstallDate
                $regInstall = (Get-Date "1970-01-01 00:00:00").AddSeconds($regTS).ToLocalTime()
                Write-Host "  Registry Install: " -NoNewline -ForegroundColor $C_Dim
                Write-Host "$($regInstall.ToString('dd/MM/yyyy  HH:mm:ss'))" -ForegroundColor $C_Warn
            } catch {
                Write-Host "  Registry Install: N/A" -ForegroundColor $C_Dim
            }

            # Method 2: InstallTime (newer Win10/11 field, 100ns intervals since 1601)
            try {
                $installTime = (Get-ItemProperty "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion" -Name "InstallTime" -ErrorAction Stop).InstallTime
                if ($installTime) {
                    $installTimeDate = [datetime]::FromFileTime($installTime)
                    Write-Host "  InstallTime     : " -NoNewline -ForegroundColor $C_Dim
                    Write-Host "$($installTimeDate.ToString('dd/MM/yyyy  HH:mm:ss'))" -ForegroundColor $C_Warn
                }
            } catch { }

            # Method 3: setupact.log — last reset/upgrade action
            $setupLog = "$env:WINDIR\Panther\setupact.log"
            $resetDetected = $false
            if (Test-Path $setupLog) {
                try {
                    $setupLines = Get-Content $setupLog -ErrorAction SilentlyContinue -TotalCount 30
                    $resetLine  = $setupLines | Select-String -Pattern "Reset|Upgrade|Install" | Select-Object -First 1
                    if ($resetLine) {
                        Write-Host "  Setup Action    : " -NoNewline -ForegroundColor $C_Dim
                        Write-Host "$($resetLine.Line.Trim())" -ForegroundColor $C_Warn
                        $resetDetected = $true
                    }
                } catch { }
            }

            # Method 4: Event Log — System reset events (IDs 1074, 6006, 6009)
            Write-Host ""
            Write-Host "  Scanning Event Log for reset/shutdown events..." -ForegroundColor $C_Dim
            try {
                $resetEvents = Get-WinEvent -FilterHashtable @{
                    LogName = 'System'
                    Id      = @(1074, 6006, 6009, 41)
                } -MaxEvents 10 -ErrorAction SilentlyContinue

                if ($resetEvents) {
                    Write-Host "  Recent System Events:" -ForegroundColor $C_Info
                    foreach ($evt in ($resetEvents | Sort-Object TimeCreated -Descending)) {
                        $label = switch ($evt.Id) {
                            1074  { "Shutdown/Restart" }
                            6006  { "Clean Shutdown" }
                            6009  { "System Boot" }
                            41    { "Unexpected Shutdown / Crash" }
                            default { "Event $($evt.Id)" }
                        }
                        Write-Host "    [$label] " -NoNewline -ForegroundColor $C_Warn
                        Write-Host "$($evt.TimeCreated.ToString('dd/MM/yyyy  HH:mm:ss'))" -ForegroundColor $C_White
                    }
                } else {
                    Write-Host "  No recent shutdown/reset events found in log." -ForegroundColor $C_Dim
                }
            } catch {
                Write-Host "  [SKIP] Cannot read System event log." -ForegroundColor $C_Dim
            }

            # Method 5: Windows.old detection
            Write-Host ""
            if (Test-Path "C:\Windows.old") {
                $wOld = Get-Item "C:\Windows.old" -ErrorAction SilentlyContinue
                Write-Host "  Windows.old     : " -NoNewline -ForegroundColor $C_Dim
                Write-Host "FOUND — Previous Windows at C:\Windows.old (Created: $($wOld.CreationTime.ToString('dd/MM/yyyy')))" -ForegroundColor $C_Found
            } else {
                Write-Host "  Windows.old     : " -NoNewline -ForegroundColor $C_Dim
                Write-Host "Not found (no recent reset/upgrade detected via this method)" -ForegroundColor $C_Clean
            }

            Write-Host ""

            # --- SECTION: MOTHERBOARD & BIOS ---
            Write-Host "  [ MOTHERBOARD & BIOS ]" -ForegroundColor $C_Info
            Write-Host "  ──────────────────────────────────────────" -ForegroundColor $C_Dim
            Write-Host "  Manufacturer    : " -NoNewline -ForegroundColor $C_Dim
            Write-Host "$($cs.Manufacturer)" -ForegroundColor $C_White
            Write-Host "  Model           : " -NoNewline -ForegroundColor $C_Dim
            Write-Host "$($cs.Model)" -ForegroundColor $C_White
            Write-Host "  Motherboard     : " -NoNewline -ForegroundColor $C_Dim
            Write-Host "$($mb.Manufacturer) $($mb.Product) (S/N: $($mb.SerialNumber))" -ForegroundColor $C_White
            Write-Host "  BIOS Version    : " -NoNewline -ForegroundColor $C_Dim
            Write-Host "$($bios.Manufacturer) — $($bios.SMBIOSBIOSVersion)" -ForegroundColor $C_White
            Write-Host "  BIOS Date       : " -NoNewline -ForegroundColor $C_Dim
            try {
                $biosDate = [Management.ManagementDateTimeConverter]::ToDateTime($bios.ReleaseDate)
                Write-Host "$($biosDate.ToString('dd/MM/yyyy'))" -ForegroundColor $C_White
            } catch {
                Write-Host "$($bios.ReleaseDate)" -ForegroundColor $C_White
            }
            Write-Host ""

            # --- SECTION: CPU ---
            Write-Host "  [ CPU ]" -ForegroundColor $C_Info
            Write-Host "  ──────────────────────────────────────────" -ForegroundColor $C_Dim
            Write-Host "  Processor       : " -NoNewline -ForegroundColor $C_Dim
            Write-Host "$($cpu.Name.Trim())" -ForegroundColor $C_White
            Write-Host "  Cores / Threads : " -NoNewline -ForegroundColor $C_Dim
            Write-Host "$($cpu.NumberOfCores) cores / $($cpu.NumberOfLogicalProcessors) threads" -ForegroundColor $C_White
            Write-Host "  Base Clock      : " -NoNewline -ForegroundColor $C_Dim
            Write-Host "$([math]::Round($cpu.MaxClockSpeed / 1000, 2)) GHz" -ForegroundColor $C_White
            Write-Host "  Architecture    : " -NoNewline -ForegroundColor $C_Dim
            Write-Host "$($cpu.AddressWidth)-bit" -ForegroundColor $C_White
            Write-Host ""

            # --- SECTION: RAM ---
            Write-Host "  [ MEMORY (RAM) ]" -ForegroundColor $C_Info
            Write-Host "  ──────────────────────────────────────────" -ForegroundColor $C_Dim
            Write-Host "  Total RAM       : " -NoNewline -ForegroundColor $C_Dim
            Write-Host "$totalRamGB GB" -ForegroundColor $C_White
            Write-Host "  Used / Free     : " -NoNewline -ForegroundColor $C_Dim
            Write-Host "$usedRamGB GB used / $freeRamGB GB free" -ForegroundColor $C_White

            $ramSticks = Get-WmiObject Win32_PhysicalMemory -ErrorAction SilentlyContinue
            if ($ramSticks) {
                $stickNum = 0
                foreach ($stick in $ramSticks) {
                    $stickNum++
                    $stickGB   = [math]::Round($stick.Capacity / 1GB, 0)
                    $stickMHz  = $stick.Speed
                    $stickType = switch ($stick.MemoryType) {
                        20 { "DDR" } 21 { "DDR2" } 24 { "DDR3" } 26 { "DDR4" } 34 { "DDR5" } default { "Unknown" }
                    }
                    if ($stickType -eq "Unknown" -and $stick.SMBIOSMemoryType) {
                        $stickType = switch ($stick.SMBIOSMemoryType) {
                            26 { "DDR4" } 34 { "DDR5" } 24 { "DDR3" } default { "RAM" }
                        }
                    }
                    Write-Host "  Stick #$stickNum         : " -NoNewline -ForegroundColor $C_Dim
                    Write-Host "$stickGB GB  $stickType  @ $stickMHz MHz  [Slot: $($stick.DeviceLocator)]" -ForegroundColor $C_White
                }
            }
            Write-Host ""

            # --- SECTION: GPU ---
            Write-Host "  [ GPU ]" -ForegroundColor $C_Info
            Write-Host "  ──────────────────────────────────────────" -ForegroundColor $C_Dim
            $gpuNum = 0
            foreach ($gpu in $gpus) {
                $gpuNum++
                $vramMB = [math]::Round($gpu.AdapterRAM / 1MB, 0)
                $vramGB = [math]::Round($gpu.AdapterRAM / 1GB, 1)
                Write-Host "  GPU #$gpuNum          : " -NoNewline -ForegroundColor $C_Dim
                Write-Host "$($gpu.Name)" -ForegroundColor $C_White
                Write-Host "  VRAM            : " -NoNewline -ForegroundColor $C_Dim
                if ($vramGB -ge 1) {
                    Write-Host "$vramGB GB" -ForegroundColor $C_White
                } else {
                    Write-Host "$vramMB MB" -ForegroundColor $C_White
                }
                Write-Host "  Driver Version  : " -NoNewline -ForegroundColor $C_Dim
                Write-Host "$($gpu.DriverVersion)" -ForegroundColor $C_White
                Write-Host "  Resolution      : " -NoNewline -ForegroundColor $C_Dim
                Write-Host "$($gpu.CurrentHorizontalResolution) x $($gpu.CurrentVerticalResolution) @ $($gpu.CurrentRefreshRate) Hz" -ForegroundColor $C_White
            }
            if ($gpuNum -eq 0) {
                Write-Host "  No dedicated GPU detected." -ForegroundColor $C_Dim
            }
            Write-Host ""

            # --- SECTION: STORAGE ---
            Write-Host "  [ STORAGE ]" -ForegroundColor $C_Info
            Write-Host "  ──────────────────────────────────────────" -ForegroundColor $C_Dim
            $diskNum = 0
            foreach ($disk in $disks) {
                $diskNum++
                $diskGB = [math]::Round($disk.Size / 1GB, 1)
                $mediaType = if ($disk.MediaType) { $disk.MediaType } else { "Unknown" }
                Write-Host "  Disk #$diskNum         : " -NoNewline -ForegroundColor $C_Dim
                Write-Host "$($disk.Model.Trim())  [$diskGB GB]" -ForegroundColor $C_White
                Write-Host "  Interface       : " -NoNewline -ForegroundColor $C_Dim
                Write-Host "$($disk.InterfaceType)  |  Serial: $($disk.SerialNumber.Trim())" -ForegroundColor $C_White
            }

            Write-Host ""
            Write-Host "  Logical Drives:" -ForegroundColor $C_Dim
            Get-PSDrive -PSProvider FileSystem -ErrorAction SilentlyContinue | ForEach-Object {
                $usedGB = [math]::Round(($_.Used) / 1GB, 1)
                $freeGB = [math]::Round(($_.Free) / 1GB, 1)
                $totalGB = [math]::Round(($_.Used + $_.Free) / 1GB, 1)
                Write-Host "    Drive $($_.Name):\ — Total: $totalGB GB  |  Used: $usedGB GB  |  Free: $freeGB GB" -ForegroundColor $C_White
            }
            Write-Host ""

            # --- SECTION: NETWORK ---
            Write-Host "  [ NETWORK ADAPTERS ]" -ForegroundColor $C_Info
            Write-Host "  ──────────────────────────────────────────" -ForegroundColor $C_Dim
            $nics = Get-WmiObject Win32_NetworkAdapterConfiguration -ErrorAction SilentlyContinue |
                Where-Object { $_.IPEnabled -eq $true }
            foreach ($nic in $nics) {
                Write-Host "  Adapter         : " -NoNewline -ForegroundColor $C_Dim
                Write-Host "$($nic.Description)" -ForegroundColor $C_White
                Write-Host "  IP Address      : " -NoNewline -ForegroundColor $C_Dim
                Write-Host "$($nic.IPAddress -join ', ')" -ForegroundColor $C_White
                Write-Host "  MAC Address     : " -NoNewline -ForegroundColor $C_Dim
                Write-Host "$($nic.MACAddress)" -ForegroundColor $C_White
                Write-Host ""
            }

            Write-Host "  ==========================================" -ForegroundColor $C_Dim
            Read-Host "`nPress Enter to return to menu..."
        }

        "1" {
            # =========================================================
            # --- [1] SYSTEM CHECK ------------------------------------
            # =========================================================
            Clear-Host
            
            $os = Get-WmiObject Win32_OperatingSystem
            $cpu = Get-WmiObject Win32_Processor
            $gpu = Get-WmiObject Win32_VideoController
            $totalRam = [math]::round($os.TotalVisibleMemorySize / 1024 / 1024, 0)
            
            Write-Host "=========================================" -ForegroundColor $C_Dim
            Write-Host "              SYSTEM CHECK               " -ForegroundColor $C_White
            Write-Host "=========================================" -ForegroundColor $C_Dim
            
            Write-Host "Computer Name : " -NoNewline -ForegroundColor $C_Info
            Write-Host "$env:COMPUTERNAME" -ForegroundColor $C_White
            
            Write-Host "Current User  : " -NoNewline -ForegroundColor $C_Info
            Write-Host "$env:USERNAME" -ForegroundColor $C_White
            
            Write-Host "OS Version    : " -NoNewline -ForegroundColor $C_Info
            Write-Host "$($os.Caption)" -ForegroundColor $C_White
            
            Write-Host "Processor     : " -NoNewline -ForegroundColor $C_Info
            Write-Host "$($cpu.Name)" -ForegroundColor $C_White
            
            Write-Host "Video Card    : " -NoNewline -ForegroundColor $C_Info
            Write-Host "$($gpu.Name)" -ForegroundColor $C_White
            
            Write-Host "Total Memory  : " -NoNewline -ForegroundColor $C_Info
            Write-Host "$totalRam GB RAM" -ForegroundColor $C_White
            
            try {
                $bootTime = [Management.ManagementDateTimeConverter]::ToDateTime($os.LastBootUpTime)
                $uptime = (Get-Date) - $bootTime
                Write-Host "System Uptime : " -NoNewline -ForegroundColor $C_Info
                Write-Host "$($uptime.Days) days, $($uptime.Hours) hours, $($uptime.Minutes) minutes" -ForegroundColor $C_White
            } catch {}
            
            Write-Host "=========================================" -ForegroundColor $C_Dim
            Read-Host "`nPress Enter to return to menu..."
        }
        
        "3" {
            # =========================================================
            # --- [3] SCANNER LOGS (20 MODULES) -----------------------
            # =========================================================
            Clear-Host
            Write-Host ""
            Write-Host "  ██╗   ██╗ █████╗ ███████╗██╗     ██╗████████╗██╗  ██╗" -ForegroundColor $C_Info
            Write-Host "  ██║   ██║██╔══██╗██╔════╝██║     ██║╚══██╔══╝██║  ██║" -ForegroundColor $C_Info
            Write-Host "  ██║   ██║███████║█████╗  ██║     ██║   ██║   ███████║" -ForegroundColor $C_Info
            Write-Host "  ╚██╗ ██╔╝██╔══██║██╔══╝  ██║     ██║   ██║   ██╔══██║" -ForegroundColor $C_Info
            Write-Host "   ╚████╔╝ ██║  ██║███████╗███████╗██║   ██║   ██║  ██║" -ForegroundColor $C_Info
            Write-Host "    ╚═══╝  ╚═╝  ╚═╝╚══════╝╚══════╝╚═╝   ╚═╝   ╚═╝  ╚═╝" -ForegroundColor $C_Info
            Write-Host "  Forensic Scanner V4  —  READ ONLY. NOTHING IS DELETED." -ForegroundColor DarkCyan
            Write-Host "  20 scan modules | Archives | Defender | Event Logs | Browser" -ForegroundColor $C_Dim
            Write-Host ""

            $userInput = Read-Host "  Enter the name/term to scan for (e.g., matcha)"

            if ([string]::IsNullOrWhiteSpace($userInput)) {
                Write-Host "  No search term provided. Returning to menu..." -ForegroundColor $C_Found
                Read-Host "`nPress Enter to continue..."
                continue
            }

            $searchTerm = "*$userInput*"
            $regexTerm  = [regex]::Escape($userInput)
            $scanStart  = Get-Date
            Write-Host ""
            Write-Host "  Scan started at: $($scanStart.ToString('HH:mm:ss'))" -ForegroundColor $C_Dim

            $results = [System.Collections.Generic.List[PSCustomObject]]::new()

            function Add-Result {
                param($Category, $Location, $Detail)
                $results.Add([PSCustomObject]@{
                    Category = $Category
                    Location = $Location
                    Detail   = $Detail
                    Time     = (Get-Date).ToString("HH:mm:ss")
                })
                Write-Host "    [FOUND] [$Category] $Location" -ForegroundColor $C_Found
                if ($Detail) {
                    Write-Host "            $Detail" -ForegroundColor $C_Warn
                }
            }

            Write-Host ""
            Write-Host "  ==========================================" -ForegroundColor $C_Info
            Write-Host "   SCANNING FOR: $($userInput.ToUpper())" -ForegroundColor $C_White
            Write-Host "  ==========================================" -ForegroundColor $C_Info

            $userSIDs = Get-ChildItem "Registry::HKEY_USERS" -ErrorAction SilentlyContinue |
                Where-Object { $_.PSChildName -match "^S-1-5-21-\d+-\d+-\d+-\d+$" } |
                Select-Object -ExpandProperty PSChildName

            # --- [1] FILE SYSTEM ---
            Write-Host "`n  [1/20] File System Scan" -ForegroundColor $C_White
            Write-Host "  ──────────────────────────────────────────" -ForegroundColor $C_Dim

            $knownPaths = @(
                "C:\$userInput",
                (Join-Path $env:APPDATA         $userInput),
                (Join-Path $env:LOCALAPPDATA    $userInput),
                (Join-Path $env:APPDATA         "Microsoft\Windows\Recent\$userInput.lnk"),
                (Join-Path $env:APPDATA         "Microsoft\Windows\Recent\$userInput (2).lnk"),
                (Join-Path $env:APPDATA         "Microsoft\Windows\Recent\$userInput.sln.lnk"),
                (Join-Path $env:LOCALAPPDATA    "Microsoft\VisualStudio\BackupFiles\$userInput")
            )

            $scanRoots = @(
                "$env:APPDATA\Microsoft\Windows\Recent",
                "$env:LOCALAPPDATA\Microsoft\VisualStudio\BackupFiles",
                "$env:LOCALAPPDATA\CrashDumps",
                "$env:WINDIR\Prefetch",
                "$env:TEMP",
                "$env:LOCALAPPDATA\Temp",
                "$env:USERPROFILE\Desktop",
                "$env:USERPROFILE\Documents",
                "$env:USERPROFILE\Downloads"
            )

            $scannedPaths = @()

            foreach ($path in $knownPaths) {
                if (Test-Path $path) {
                    Add-Result "FILE" $path $null
                    $scannedPaths += $path
                }
            }

            foreach ($root in $scanRoots) {
                if (Test-Path $root) {
                    Get-ChildItem -Path $root -Force -ErrorAction SilentlyContinue |
                        Where-Object { $_.Name -match $regexTerm } |
                        ForEach-Object {
                            if ($_.FullName -notin $scannedPaths) {
                                Add-Result "FILE" $_.FullName "Size: $([math]::Round($_.Length/1KB,1)) KB | Modified: $($_.LastWriteTime)"
                                $scannedPaths += $_.FullName
                            }
                        }
                }
            }

            if ($scannedPaths.Count -eq 0) {
                Write-Host "    [CLEAN] No file traces found." -ForegroundColor $C_Clean
            }

            # --- [2] SHIMCACHE ---
            Write-Host "`n  [2/20] ShimCache / AppCompatCache" -ForegroundColor $C_White
            Write-Host "  ──────────────────────────────────────────" -ForegroundColor $C_Dim
            Write-Host "    (Execution history — survives reboots)" -ForegroundColor $C_Dim

            $shimPath = "HKLM:\SYSTEM\CurrentControlSet\Control\Session Manager\AppCompatCache"
            if (Test-Path $shimPath) {
                try {
                    $shimRaw = (Get-ItemProperty -Path $shimPath -Name "AppCompatCache" -ErrorAction Stop).AppCompatCache
                    $shimStr = [System.Text.Encoding]::Unicode.GetString($shimRaw)
                    if ($shimStr -match $regexTerm) {
                        Add-Result "SHIMCACHE" $shimPath "Binary data contains '$userInput' path(s)."
                    } else {
                        Write-Host "    [CLEAN] '$userInput' not found in ShimCache." -ForegroundColor $C_Clean
                    }
                } catch {
                    Write-Host "    [ERROR] Cannot read ShimCache: $($_.Exception.Message)" -ForegroundColor Red
                }
            } else {
                Write-Host "    [SKIP] ShimCache path not found." -ForegroundColor $C_Dim
            }

            # --- [3] BAM ---
            Write-Host "`n  [3/20] BAM — Background Activity Monitor" -ForegroundColor $C_White
            Write-Host "  ──────────────────────────────────────────" -ForegroundColor $C_Dim
            Write-Host "    (Tracks every executed binary with timestamp)" -ForegroundColor $C_Dim

            $bamRoots = @(
                "HKLM:\SYSTEM\ControlSet001\Services\bam\State\UserSettings",
                "HKLM:\SYSTEM\CurrentControlSet\Services\bam\State\UserSettings"
            )
            $bamFound = $false
            foreach ($bamRoot in $bamRoots) {
                foreach ($sid in $userSIDs) {
                    $bamPath = "$bamRoot\$sid"
                    if (Test-Path $bamPath) {
                        $props = Get-ItemProperty -Path $bamPath -ErrorAction SilentlyContinue
                        if ($null -ne $props) {
                            foreach ($prop in $props.PSObject.Properties) {
                                if ($prop.Name -notmatch "^PS" -and ($prop.Name -like $searchTerm)) {
                                    Add-Result "BAM" $bamPath "Value: $($prop.Name)"
                                    $bamFound = $true
                                }
                            }
                        }
                    }
                }
            }
            if (-not $bamFound) { Write-Host "    [CLEAN] No BAM entries found for '$userInput'." -ForegroundColor $C_Clean }

            # --- [4] REGISTRY ---
            Write-Host "`n  [4/20] Registry — Execution Artifacts" -ForegroundColor $C_White
            Write-Host "  ──────────────────────────────────────────" -ForegroundColor $C_Dim

            $regPaths = @(
                @{ Path = "HKCU:\Software\Classes\Local Settings\Software\Microsoft\Windows\Shell\MuiCache"; Label = "MuiCache (HKCU)" },
                @{ Path = "HKCR:\Local Settings\Software\Microsoft\Windows\Shell\MuiCache"; Label = "MuiCache (HKCR)" },
                @{ Path = "HKCU:\Software\Microsoft\Windows NT\CurrentVersion\AppCompatFlags\Compatibility Assistant\Store"; Label = "AppCompatFlags\Store" },
                @{ Path = "HKCU:\Software\Microsoft\Windows NT\CurrentVersion\AppCompatFlags\Layers"; Label = "AppCompatFlags\Layers" },
                @{ Path = "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\FeatureUsage\AppSwitched"; Label = "FeatureUsage\AppSwitched" },
                @{ Path = "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\FeatureUsage\ShowJumpView"; Label = "FeatureUsage\ShowJumpView" },
                @{ Path = "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\FeatureUsage\AppBadgeUpdated"; Label = "FeatureUsage\AppBadgeUpdated" },
                @{ Path = "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\RunMRU"; Label = "RunMRU (Win+R)" },
                @{ Path = "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\RecentDocs"; Label = "RecentDocs" },
                @{ Path = "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\ComDlg32\LastVisitedPidlMRU"; Label = "ComDlg32\LastVisitedPidlMRU" },
                @{ Path = "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\ComDlg32\OpenSavePidlMRU"; Label = "ComDlg32\OpenSavePidlMRU" },
                @{ Path = "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\TypedPaths"; Label = "TypedPaths" },
                @{ Path = "HKLM:\SOFTWARE\Microsoft\Windows Defender\Exclusions\Paths"; Label = "Defender\Exclusions\Paths" },
                @{ Path = "HKLM:\SOFTWARE\Microsoft\Windows Defender\Exclusions\Processes"; Label = "Defender\Exclusions\Processes" },
                @{ Path = "HKLM:\SOFTWARE\Microsoft\RADAR\HeapLeakDetection\DiagnosedApplications"; Label = "RADAR\DiagnosedApplications" },
                @{ Path = "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall"; Label = "Uninstall (x64)" },
                @{ Path = "HKLM:\SOFTWARE\WOW6432Node\Microsoft\Windows\CurrentVersion\Uninstall"; Label = "Uninstall (x86)" },
                @{ Path = "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Map Network Drive MRU"; Label = "Map Network Drive MRU" },
                @{ Path = "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\ComDlg32\CIDSizeMRU"; Label = "ComDlg32\CIDSizeMRU" },
                @{ Path = "HKCU:\Software\Microsoft\Internet Explorer\TypedURLs"; Label = "IE TypedURLs" },
                @{ Path = "HKCU:\Software\Microsoft\Windows\CurrentVersion\Search\RecentApps"; Label = "Search RecentApps" }
            )

            foreach ($sid in $userSIDs) {
                $regPaths += @{ Path = "Registry::HKEY_USERS\$sid\Software\Classes\Local Settings\Software\Microsoft\Windows\Shell\MuiCache"; Label = "MuiCache [$sid]" }
                $regPaths += @{ Path = "Registry::HKEY_USERS\$sid\Software\Microsoft\Windows NT\CurrentVersion\AppCompatFlags\Compatibility Assistant\Store"; Label = "AppCompatFlags\Store [$sid]" }
                $regPaths += @{ Path = "Registry::HKEY_USERS\$sid\Software\Microsoft\Windows\CurrentVersion\Explorer\RecentDocs"; Label = "RecentDocs [$sid]" }
                $regPaths += @{ Path = "Registry::HKEY_USERS\${sid}_Classes\Local Settings\Software\Microsoft\Windows\Shell\MuiCache"; Label = "MuiCache _Classes [$sid]" }
            }

            $regFound = $false
            foreach ($entry in $regPaths) {
                $psPath = $entry.Path
                $label  = $entry.Label
                if (Test-Path -Path $psPath -ErrorAction SilentlyContinue) {
                    $subkeys = Get-ChildItem -Path $psPath -ErrorAction SilentlyContinue
                    foreach ($key in $subkeys) {
                        if ($key.PSChildName -like $searchTerm) {
                            Add-Result "REGISTRY" "$label \ [SUBKEY] $($key.PSChildName)" $null
                            $regFound = $true
                        }
                        if ($label -match "UserAssist|FileExts|ComDlg32|RecentDocs|LastVisited|OpenSave") {
                            $subProps = Get-ItemProperty -Path $key.PSPath -ErrorAction SilentlyContinue
                            if ($null -ne $subProps) {
                                foreach ($prop in $subProps.PSObject.Properties) {
                                    if ($prop.Name -notmatch "^PS" -and ($prop.Name -like $searchTerm -or [string]$prop.Value -like $searchTerm)) {
                                        Add-Result "REGISTRY" "$label \ $($key.PSChildName) \ $($prop.Name)" "Value: $($prop.Value)"
                                        $regFound = $true
                                    }
                                }
                            }
                        }
                    }
                    $props = Get-ItemProperty -Path $psPath -ErrorAction SilentlyContinue
                    if ($null -ne $props) {
                        foreach ($prop in $props.PSObject.Properties) {
                            if ($prop.Name -notmatch "^PS" -and ($prop.Name -like $searchTerm -or [string]$prop.Value -like $searchTerm)) {
                                Add-Result "REGISTRY" "$label \ $($prop.Name)" "Value: $($prop.Value)"
                                $regFound = $true
                            }
                        }
                    }
                }
            }
            if (-not $regFound) { Write-Host "    [CLEAN] No registry execution artifacts found." -ForegroundColor $C_Clean }

            # --- [5] USERASSIST ---
            Write-Host "`n  [5/20] UserAssist (Encoded Execution Counter)" -ForegroundColor $C_White
            Write-Host "  ──────────────────────────────────────────" -ForegroundColor $C_Dim
            Write-Host "    (Tracks GUI app launches — entries are ROT13 encoded)" -ForegroundColor $C_Dim

            function Decode-ROT13 {
                param([string]$s)
                -join ($s.ToCharArray() | ForEach-Object {
                    $c = [int]$_
                    if    ($c -ge 65 -and $c -le 90)  { [char](( ($c - 65 + 13) % 26 ) + 65) }
                    elseif($c -ge 97 -and $c -le 122) { [char](( ($c - 97 + 13) % 26 ) + 97) }
                    else                               { $_ }
                })
            }

            $uaRoots = @("HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\UserAssist")
            foreach ($sid in $userSIDs) {
                $uaRoots += "Registry::HKEY_USERS\$sid\Software\Microsoft\Windows\CurrentVersion\Explorer\UserAssist"
            }

            $uaFound = $false
            foreach ($uaRoot in $uaRoots) {
                if (Test-Path $uaRoot -ErrorAction SilentlyContinue) {
                    Get-ChildItem -Path $uaRoot -ErrorAction SilentlyContinue | ForEach-Object {
                        $guidPath  = $_.PSPath
                        $countPath = Join-Path $guidPath "Count"
                        if (Test-Path $countPath -ErrorAction SilentlyContinue) {
                            $countProps = Get-ItemProperty -Path $countPath -ErrorAction SilentlyContinue
                            if ($null -ne $countProps) {
                                foreach ($prop in $countProps.PSObject.Properties) {
                                    if ($prop.Name -notmatch "^PS") {
                                        $decoded = Decode-ROT13 $prop.Name
                                        if ($decoded -match $regexTerm) {
                                            Add-Result "USERASSIST" $countPath "Decoded: $decoded"
                                            $uaFound = $true
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
            }
            if (-not $uaFound) { Write-Host "    [CLEAN] No UserAssist entries found for '$userInput'." -ForegroundColor $C_Clean }

            # --- [6] PREFETCH ---
            Write-Host "`n  [6/20] Prefetch Files" -ForegroundColor $C_White
            Write-Host "  ──────────────────────────────────────────" -ForegroundColor $C_Dim
            $prefetchPath = "$env:WINDIR\Prefetch"
            $pfFound = $false
            if (Test-Path $prefetchPath) {
                Get-ChildItem -Path $prefetchPath -Filter "*.pf" -ErrorAction SilentlyContinue |
                    Where-Object { $_.Name -match $regexTerm } |
                    ForEach-Object {
                        Add-Result "PREFETCH" $_.FullName "Last Modified: $($_.LastWriteTime)"
                        $pfFound = $true
                    }
            }
            if (-not $pfFound) { Write-Host "    [CLEAN] No Prefetch files found for '$userInput'." -ForegroundColor $C_Clean }

            # --- [7] ARCHIVE FILES ---
            Write-Host "`n  [7/20] Archive Files (.zip / .rar / .7z / .tar / .gz)" -ForegroundColor $C_White
            Write-Host "  ──────────────────────────────────────────" -ForegroundColor $C_Dim
            $archiveExtensions = @("*.zip","*.rar","*.7z","*.tar","*.gz","*.tar.gz","*.bz2","*.xz","*.cab","*.iso")
            $archiveRoots = @(
                "$env:USERPROFILE\Downloads","$env:USERPROFILE\Desktop","$env:USERPROFILE\Documents",
                "$env:TEMP","$env:LOCALAPPDATA\Temp","C:\Temp"
            )
            $archFound = $false
            foreach ($root in $archiveRoots) {
                if (Test-Path $root) {
                    foreach ($ext in $archiveExtensions) {
                        Get-ChildItem -Path $root -Filter $ext -Recurse -Depth 3 -Force -ErrorAction SilentlyContinue |
                            Where-Object { $_.Name -match $regexTerm } |
                            ForEach-Object {
                                Add-Result "ARCHIVE" $_.FullName "Type: $($_.Extension.ToUpper()) | Size: $([math]::Round($_.Length/1MB,2)) MB | Modified: $($_.LastWriteTime)"
                                $archFound = $true
                            }
                    }
                }
            }
            foreach ($root in $archiveRoots) {
                if (Test-Path $root) {
                    Get-ChildItem -Path $root -Filter "*.zip" -Recurse -Depth 2 -Force -ErrorAction SilentlyContinue |
                        ForEach-Object {
                            try {
                                Add-Type -AssemblyName System.IO.Compression.FileSystem -ErrorAction SilentlyContinue
                                $zip   = [System.IO.Compression.ZipFile]::OpenRead($_.FullName)
                                $match = $zip.Entries | Where-Object { $_.FullName -match $regexTerm }
                                if ($match) {
                                    $match | ForEach-Object {
                                        Add-Result "ARCHIVE-CONTENT" $_.FullName "Entry inside ZIP: $($_.FullName)"
                                        $archFound = $true
                                    }
                                }
                                $zip.Dispose()
                            } catch { }
                        }
                }
            }
            if (-not $archFound) { Write-Host "    [CLEAN] No archive files found referencing '$userInput'." -ForegroundColor $C_Clean }

            # --- [8] WINDOWS DEFENDER ---
            Write-Host "`n  [8/20] Windows Defender / Antivirus History" -ForegroundColor $C_White
            Write-Host "  ──────────────────────────────────────────" -ForegroundColor $C_Dim
            $defFound = $false
            $defHistoryPath = "$env:ProgramData\Microsoft\Windows Defender\Scans\History\Service\DetectionHistory"
            if (Test-Path $defHistoryPath) {
                Get-ChildItem -Path $defHistoryPath -Recurse -Force -ErrorAction SilentlyContinue | ForEach-Object {
                    try {
                        $content = Get-Content $_.FullName -Raw -ErrorAction SilentlyContinue
                        if ($content -and $content -match $regexTerm) {
                            Add-Result "DEFENDER-HISTORY" $_.FullName "Detection history references '$userInput'"
                            $defFound = $true
                        }
                    } catch { }
                }
            }
            $quarantinePath = "$env:ProgramData\Microsoft\Windows Defender\Quarantine"
            if (Test-Path $quarantinePath) {
                Get-ChildItem -Path $quarantinePath -Recurse -Force -ErrorAction SilentlyContinue |
                    Where-Object { $_.Name -match $regexTerm } |
                    ForEach-Object { Add-Result "DEFENDER-QUARANTINE" $_.FullName "Quarantined file matches '$userInput'"; $defFound = $true }
            }
            $defExclusions = @(
                "HKLM:\SOFTWARE\Microsoft\Windows Defender\Exclusions\Paths",
                "HKLM:\SOFTWARE\Microsoft\Windows Defender\Exclusions\Processes",
                "HKLM:\SOFTWARE\Microsoft\Windows Defender\Exclusions\Extensions",
                "HKLM:\SOFTWARE\Microsoft\Windows Defender\Exclusions\TemporaryPaths"
            )
            foreach ($excl in $defExclusions) {
                if (Test-Path $excl -ErrorAction SilentlyContinue) {
                    $props = Get-ItemProperty -Path $excl -ErrorAction SilentlyContinue
                    if ($null -ne $props) {
                        foreach ($prop in $props.PSObject.Properties) {
                            if ($prop.Name -notmatch "^PS" -and ($prop.Name -like $searchTerm -or [string]$prop.Value -like $searchTerm)) {
                                Add-Result "DEFENDER-EXCLUSION" $excl "Exclusion: $($prop.Name) = $($prop.Value)"
                                $defFound = $true
                            }
                        }
                    }
                }
            }
            $mpLog = "$env:ProgramData\Microsoft\Windows Defender\Support\MpCmdRun.log"
            if (Test-Path $mpLog) {
                try {
                    $mpContent = Get-Content $mpLog -ErrorAction SilentlyContinue | Select-String -Pattern $regexTerm
                    if ($mpContent) {
                        $mpContent | ForEach-Object { Add-Result "DEFENDER-LOG" $mpLog "MpCmdRun.log line: $($_.Line.Trim())"; $defFound = $true }
                    }
                } catch { }
            }
            if (-not $defFound) { Write-Host "    [CLEAN] No Defender/AV artifacts found for '$userInput'." -ForegroundColor $C_Clean }

            # --- [9] EVENT VIEWER ---
            Write-Host "`n  [9/20] Windows Event Viewer Logs" -ForegroundColor $C_White
            Write-Host "  ──────────────────────────────────────────" -ForegroundColor $C_Dim
            $evFound = $false
            $eventLogs = @(
                @{ LogName = "Application"; MaxEvents = 2000 },
                @{ LogName = "System"; MaxEvents = 2000 },
                @{ LogName = "Security"; MaxEvents = 500 },
                @{ LogName = "Microsoft-Windows-PowerShell/Operational"; MaxEvents = 1000 },
                @{ LogName = "Microsoft-Windows-AppLocker/EXE and DLL"; MaxEvents = 500 },
                @{ LogName = "Microsoft-Windows-AppLocker/MSI and Script"; MaxEvents = 500 },
                @{ LogName = "Microsoft-Windows-TerminalServices-LocalSessionManager/Operational"; MaxEvents = 200 },
                @{ LogName = "Microsoft-Windows-Bits-Client/Operational"; MaxEvents = 500 },
                @{ LogName = "Microsoft-Windows-TaskScheduler/Operational"; MaxEvents = 500 }
            )
            foreach ($logEntry in $eventLogs) {
                Write-Host "    Scanning: $($logEntry.LogName) ..." -ForegroundColor $C_Dim
                try {
                    $events = Get-WinEvent -LogName $logEntry.LogName -MaxEvents $logEntry.MaxEvents -ErrorAction SilentlyContinue |
                        Where-Object { $_.Message -match $regexTerm }
                    if ($events) {
                        foreach ($evt in $events) {
                            $snippet = ($evt.Message -split "`n" | Where-Object { $_ -match $regexTerm } | Select-Object -First 1).Trim()
                            Add-Result "EVENT-LOG" "$($logEntry.LogName) (EventID: $($evt.Id))" "Time: $($evt.TimeCreated) | $snippet"
                            $evFound = $true
                        }
                    }
                } catch {
                    Write-Host "    [SKIP] Cannot read '$($logEntry.LogName)'" -ForegroundColor $C_Dim
                }
            }
            if (-not $evFound) { Write-Host "    [CLEAN] No Event Log entries found for '$userInput'." -ForegroundColor $C_Clean }

            # --- [10] BROWSER HISTORY ---
            Write-Host "`n  [10/20] Browser History (Edge / Chrome / Firefox)" -ForegroundColor $C_White
            Write-Host "  ──────────────────────────────────────────" -ForegroundColor $C_Dim
            $brFound = $false
            $chromiumProfiles = @(
                "$env:LOCALAPPDATA\Microsoft\Edge\User Data",
                "$env:LOCALAPPDATA\Google\Chrome\User Data",
                "$env:LOCALAPPDATA\BraveSoftware\Brave-Browser\User Data",
                "$env:LOCALAPPDATA\Vivaldi\User Data",
                "$env:LOCALAPPDATA\Opera Software\Opera Stable"
            )
            foreach ($browserBase in $chromiumProfiles) {
                if (Test-Path $browserBase) {
                    $histFiles = Get-ChildItem -Path $browserBase -Filter "History" -Recurse -Depth 3 -Force -ErrorAction SilentlyContinue
                    foreach ($hf in $histFiles) {
                        try {
                            $bytes  = [System.IO.File]::ReadAllBytes($hf.FullName)
                            $asText = [System.Text.Encoding]::UTF8.GetString($bytes)
                            if ($asText -match $regexTerm) {
                                $browserName = Split-Path (Split-Path $hf.DirectoryName) -Leaf
                                Add-Result "BROWSER-HISTORY" $hf.FullName "Browser: $browserName — History contains '$userInput'"
                                $brFound = $true
                            }
                        } catch { }
                    }
                    foreach ($dbName in @("Top Sites","Favicons","Visited Links","Shortcuts")) {
                        $dbFiles = Get-ChildItem -Path $browserBase -Filter $dbName -Recurse -Depth 3 -Force -ErrorAction SilentlyContinue
                        foreach ($dbf in $dbFiles) {
                            try {
                                $bytes  = [System.IO.File]::ReadAllBytes($dbf.FullName)
                                $asText = [System.Text.Encoding]::UTF8.GetString($bytes)
                                if ($asText -match $regexTerm) {
                                    Add-Result "BROWSER-HISTORY" $dbf.FullName "Browser DB '$dbName' references '$userInput'"
                                    $brFound = $true
                                }
                            } catch { }
                        }
                    }
                }
            }
            $ffBase = "$env:APPDATA\Mozilla\Firefox\Profiles"
            if (Test-Path $ffBase) {
                Get-ChildItem -Path $ffBase -Filter "places.sqlite" -Recurse -Depth 3 -Force -ErrorAction SilentlyContinue | ForEach-Object {
                    try {
                        $bytes = [System.IO.File]::ReadAllBytes($_.FullName)
                        $asText = [System.Text.Encoding]::UTF8.GetString($bytes)
                        if ($asText -match $regexTerm) { Add-Result "BROWSER-HISTORY" $_.FullName "Firefox history contains '$userInput'"; $brFound = $true }
                    } catch { }
                }
                Get-ChildItem -Path $ffBase -Filter "formhistory.sqlite" -Recurse -Depth 3 -Force -ErrorAction SilentlyContinue | ForEach-Object {
                    try {
                        $bytes = [System.IO.File]::ReadAllBytes($_.FullName)
                        $asText = [System.Text.Encoding]::UTF8.GetString($bytes)
                        if ($asText -match $regexTerm) { Add-Result "BROWSER-HISTORY" $_.FullName "Firefox form history contains '$userInput'"; $brFound = $true }
                    } catch { }
                }
            }
            if (-not $brFound) { Write-Host "    [CLEAN] No browser history references found for '$userInput'." -ForegroundColor $C_Clean }

            # --- [11] JUMP LISTS ---
            Write-Host "`n  [11/20] Jump Lists" -ForegroundColor $C_White
            Write-Host "  ──────────────────────────────────────────" -ForegroundColor $C_Dim
            $jlFound = $false
            $jumpListRoots = @(
                "$env:APPDATA\Microsoft\Windows\Recent\AutomaticDestinations",
                "$env:APPDATA\Microsoft\Windows\Recent\CustomDestinations"
            )
            foreach ($jlRoot in $jumpListRoots) {
                if (Test-Path $jlRoot) {
                    Get-ChildItem -Path $jlRoot -Force -ErrorAction SilentlyContinue | ForEach-Object {
                        try {
                            $bytes  = [System.IO.File]::ReadAllBytes($_.FullName)
                            $asText = [System.Text.Encoding]::Unicode.GetString($bytes)
                            if ($asText -match $regexTerm) {
                                Add-Result "JUMPLIST" $_.FullName "Jump list binary references '$userInput' | Modified: $($_.LastWriteTime)"
                                $jlFound = $true
                            }
                        } catch { }
                    }
                }
            }
            if (-not $jlFound) { Write-Host "    [CLEAN] No Jump List references found." -ForegroundColor $C_Clean }

            # --- [12] THUMBNAIL CACHE ---
            Write-Host "`n  [12/20] Thumbnail Cache" -ForegroundColor $C_White
            Write-Host "  ──────────────────────────────────────────" -ForegroundColor $C_Dim
            $tcFound = $false
            $thumbCachePath = "$env:LOCALAPPDATA\Microsoft\Windows\Explorer"
            if (Test-Path $thumbCachePath) {
                Get-ChildItem -Path $thumbCachePath -Filter "thumbcache_*.db" -ErrorAction SilentlyContinue | ForEach-Object {
                    try {
                        $bytes  = [System.IO.File]::ReadAllBytes($_.FullName)
                        $asText = [System.Text.Encoding]::Unicode.GetString($bytes)
                        if ($asText -match $regexTerm) {
                            Add-Result "THUMBCACHE" $_.FullName "Thumbnail DB references '$userInput'"
                            $tcFound = $true
                        }
                    } catch { }
                }
            }
            if (-not $tcFound) { Write-Host "    [CLEAN] No thumbnail cache references found." -ForegroundColor $C_Clean }

            # --- [13] WINDOWS SEARCH ---
            Write-Host "`n  [13/20] Windows Search Index" -ForegroundColor $C_White
            Write-Host "  ──────────────────────────────────────────" -ForegroundColor $C_Dim
            $wsFound = $false
            $wwqPath = "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\WordWheelQuery"
            if (Test-Path $wwqPath -ErrorAction SilentlyContinue) {
                $wwqProps = Get-ItemProperty -Path $wwqPath -ErrorAction SilentlyContinue
                if ($null -ne $wwqProps) {
                    foreach ($prop in $wwqProps.PSObject.Properties) {
                        if ($prop.Name -notmatch "^PS") {
                            $valStr = ""
                            try {
                                if ($prop.Value -is [byte[]]) { $valStr = [System.Text.Encoding]::Unicode.GetString($prop.Value).TrimEnd([char]0) }
                                else { $valStr = [string]$prop.Value }
                            } catch { }
                            if ($valStr -match $regexTerm) { Add-Result "SEARCH-HISTORY" $wwqPath "WordWheelQuery: '$valStr'"; $wsFound = $true }
                        }
                    }
                }
            }
            foreach ($sid in $userSIDs) {
                $sidWWQ = "Registry::HKEY_USERS\$sid\Software\Microsoft\Windows\CurrentVersion\Explorer\WordWheelQuery"
                if (Test-Path $sidWWQ -ErrorAction SilentlyContinue) {
                    $wwqProps = Get-ItemProperty -Path $sidWWQ -ErrorAction SilentlyContinue
                    if ($null -ne $wwqProps) {
                        foreach ($prop in $wwqProps.PSObject.Properties) {
                            if ($prop.Name -notmatch "^PS") {
                                $valStr = ""
                                try {
                                    if ($prop.Value -is [byte[]]) { $valStr = [System.Text.Encoding]::Unicode.GetString($prop.Value).TrimEnd([char]0) }
                                    else { $valStr = [string]$prop.Value }
                                } catch { }
                                if ($valStr -match $regexTerm) { Add-Result "SEARCH-HISTORY" $sidWWQ "WordWheelQuery [$sid]: '$valStr'"; $wsFound = $true }
                            }
                        }
                    }
                }
            }
            $searchDB = "$env:ProgramData\Microsoft\Search\Data\Applications\Windows\Windows.edb"
            if (Test-Path $searchDB) {
                Add-Result "SEARCH-DB" $searchDB "Windows.edb exists — use NirSoft SearchMyFiles for deep inspection."
                $wsFound = $true
            }
            if (-not $wsFound) { Write-Host "    [CLEAN] No Windows Search history found for '$userInput'." -ForegroundColor $C_Clean }

            # --- [14] SCHEDULED TASKS ---
            Write-Host "`n  [14/20] Scheduled Tasks" -ForegroundColor $C_White
            Write-Host "  ──────────────────────────────────────────" -ForegroundColor $C_Dim
            $stFound = $false
            try {
                $tasks = Get-ScheduledTask -ErrorAction SilentlyContinue |
                    Where-Object {
                        $_.TaskName -match $regexTerm -or $_.TaskPath -match $regexTerm -or
                        ($_.Actions | ForEach-Object { $_.Execute, $_.Arguments } | Where-Object { $_ -match $regexTerm })
                    }
                foreach ($task in $tasks) {
                    $actionStr = ($task.Actions | ForEach-Object { "$($_.Execute) $($_.Arguments)" }) -join " | "
                    Add-Result "SCHED-TASK" "\$($task.TaskPath)$($task.TaskName)" "Actions: $actionStr | State: $($task.State)"
                    $stFound = $true
                }
            } catch { }
            $taskXmlRoot = "$env:WINDIR\System32\Tasks"
            if (Test-Path $taskXmlRoot) {
                Get-ChildItem -Path $taskXmlRoot -Recurse -File -ErrorAction SilentlyContinue | ForEach-Object {
                    try {
                        $xml = Get-Content $_.FullName -Raw -ErrorAction SilentlyContinue
                        if ($xml -match $regexTerm) { Add-Result "SCHED-TASK-XML" $_.FullName "Task references '$userInput'"; $stFound = $true }
                    } catch { }
                }
            }
            if (-not $stFound) { Write-Host "    [CLEAN] No scheduled tasks found referencing '$userInput'." -ForegroundColor $C_Clean }

            # --- [15] NETWORK ARTIFACTS ---
            Write-Host "`n  [15/20] Network Artifacts" -ForegroundColor $C_White
            Write-Host "  ──────────────────────────────────────────" -ForegroundColor $C_Dim
            $netFound = $false
            try {
                $dnsCache = Get-DnsClientCache -ErrorAction SilentlyContinue | Where-Object { $_.Entry -match $regexTerm -or $_.RecordName -match $regexTerm }
                foreach ($dns in $dnsCache) { Add-Result "DNS-CACHE" "DNS Cache" "Entry: $($dns.Entry) | Record: $($dns.RecordName)"; $netFound = $true }
            } catch { }
            $hostsFile = "$env:WINDIR\System32\drivers\etc\hosts"
            if (Test-Path $hostsFile) {
                $hostsContent = Get-Content $hostsFile -ErrorAction SilentlyContinue | Select-String -Pattern $regexTerm
                if ($hostsContent) { $hostsContent | ForEach-Object { Add-Result "HOSTS-FILE" $hostsFile "Line: $($_.Line.Trim())"; $netFound = $true } }
            }
            $fwLogPath = "$env:WINDIR\System32\LogFiles\Firewall\pfirewall.log"
            if (Test-Path $fwLogPath) {
                try {
                    $fwMatches = Get-Content $fwLogPath -ErrorAction SilentlyContinue | Select-String -Pattern $regexTerm
                    if ($fwMatches) { $fwMatches | Select-Object -First 5 | ForEach-Object { Add-Result "FIREWALL-LOG" $fwLogPath "Line: $($_.Line.Trim())"; $netFound = $true } }
                } catch { }
            }
            $netHistPaths = @(
                "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\NetworkList\Profiles",
                "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\NetworkList\Signatures\Unmanaged",
                "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\NetworkList\Signatures\Managed"
            )
            foreach ($nhp in $netHistPaths) {
                if (Test-Path $nhp -ErrorAction SilentlyContinue) {
                    Get-ChildItem -Path $nhp -ErrorAction SilentlyContinue | ForEach-Object {
                        $props = Get-ItemProperty -Path $_.PSPath -ErrorAction SilentlyContinue
                        if ($null -ne $props) {
                            foreach ($prop in $props.PSObject.Properties) {
                                if ($prop.Name -notmatch "^PS" -and [string]$prop.Value -match $regexTerm) {
                                    Add-Result "NETWORK-HISTORY" $_.PSPath "$($prop.Name): $($prop.Value)"; $netFound = $true
                                }
                            }
                        }
                    }
                }
            }
            if (-not $netFound) { Write-Host "    [CLEAN] No network artifacts found for '$userInput'." -ForegroundColor $C_Clean }

            # --- [16] RECYCLE BIN ---
            Write-Host "`n  [16/20] Recycle Bin" -ForegroundColor $C_White
            Write-Host "  ──────────────────────────────────────────" -ForegroundColor $C_Dim
            $rbFound = $false
            $drives = Get-PSDrive -PSProvider FileSystem -ErrorAction SilentlyContinue | Select-Object -ExpandProperty Root
            foreach ($drive in $drives) {
                $rbPath = Join-Path $drive '$Recycle.Bin'
                if (Test-Path $rbPath -ErrorAction SilentlyContinue) {
                    Get-ChildItem -Path $rbPath -Recurse -Force -ErrorAction SilentlyContinue |
                        Where-Object { $_.Name -match $regexTerm } |
                        ForEach-Object { Add-Result "RECYCLE-BIN" $_.FullName "Size: $([math]::Round($_.Length/1KB,1)) KB | Deleted ~: $($_.LastWriteTime)"; $rbFound = $true }
                    Get-ChildItem -Path $rbPath -Recurse -Force -ErrorAction SilentlyContinue |
                        Where-Object { $_.Name -match '^\$I' } |
                        ForEach-Object {
                            try {
                                $bytes  = [System.IO.File]::ReadAllBytes($_.FullName)
                                $asText = [System.Text.Encoding]::Unicode.GetString($bytes)
                                if ($asText -match $regexTerm) { Add-Result "RECYCLE-BIN-META" $_.FullName "Recycle metadata references '$userInput'"; $rbFound = $true }
                            } catch { }
                        }
                }
            }
            if (-not $rbFound) { Write-Host "    [CLEAN] No Recycle Bin items found for '$userInput'." -ForegroundColor $C_Clean }

            # --- [17] LNK SHORTCUTS ---
            Write-Host "`n  [17/20] LNK / Shortcut Files" -ForegroundColor $C_White
            Write-Host "  ──────────────────────────────────────────" -ForegroundColor $C_Dim
            $lnkFound = $false
            $lnkRoots = @(
                "$env:APPDATA\Microsoft\Windows\Recent","$env:USERPROFILE\Desktop",
                "$env:PROGRAMDATA\Microsoft\Windows\Start Menu","$env:APPDATA\Microsoft\Windows\Start Menu",
                "$env:USERPROFILE\AppData\Roaming\Microsoft\Internet Explorer\Quick Launch"
            )
            $wshell = New-Object -ComObject WScript.Shell -ErrorAction SilentlyContinue
            foreach ($lnkRoot in $lnkRoots) {
                if (Test-Path $lnkRoot) {
                    Get-ChildItem -Path $lnkRoot -Filter "*.lnk" -Recurse -Force -ErrorAction SilentlyContinue | ForEach-Object {
                        $lnkPath = $_.FullName
                        if ($_.BaseName -match $regexTerm) { Add-Result "LNK-NAME" $lnkPath "Shortcut name matches '$userInput'"; $lnkFound = $true }
                        try {
                            if ($null -ne $wshell) {
                                $sc = $wshell.CreateShortcut($lnkPath)
                                if ($sc.TargetPath -match $regexTerm -or $sc.Arguments -match $regexTerm -or $sc.WorkingDirectory -match $regexTerm) {
                                    Add-Result "LNK-TARGET" $lnkPath "Target: $($sc.TargetPath) | Args: $($sc.Arguments)"; $lnkFound = $true
                                }
                            }
                        } catch { }
                        try {
                            $bytes  = [System.IO.File]::ReadAllBytes($lnkPath)
                            $asText = [System.Text.Encoding]::Unicode.GetString($bytes)
                            if ($asText -match $regexTerm -and -not $lnkFound) { Add-Result "LNK-BINARY" $lnkPath "Binary content references '$userInput'"; $lnkFound = $true }
                        } catch { }
                    }
                }
            }
            if (-not $lnkFound) { Write-Host "    [CLEAN] No LNK shortcut references found." -ForegroundColor $C_Clean }

            # --- [18] VSS ---
            Write-Host "`n  [18/20] Volume Shadow Copies (VSS)" -ForegroundColor $C_White
            Write-Host "  ──────────────────────────────────────────" -ForegroundColor $C_Dim
            $vssFound = $false
            try {
                $shadows = Get-WmiObject Win32_ShadowCopy -ErrorAction SilentlyContinue
                if ($shadows) {
                    Write-Host "    [INFO] Found $($shadows.Count) shadow copy/copies on this system." -ForegroundColor $C_Dim
                    foreach ($shadow in $shadows) {
                        $shadowLink = "C:\vaelith_vss_mount_$(Get-Random)"
                        try {
                            cmd /c "mklink /d `"$shadowLink`" `"$($shadow.DeviceObject)\`"" 2>$null | Out-Null
                            if (Test-Path $shadowLink) {
                                Get-ChildItem -Path $shadowLink -Recurse -Depth 4 -Force -ErrorAction SilentlyContinue |
                                    Where-Object { $_.Name -match $regexTerm } |
                                    ForEach-Object { Add-Result "VSS" $_.FullName "Found in shadow copy $($shadow.ID)"; $vssFound = $true }
                                cmd /c "rmdir `"$shadowLink`"" 2>$null | Out-Null
                            }
                        } catch { }
                    }
                } else {
                    Write-Host "    [INFO] No Volume Shadow Copies found." -ForegroundColor $C_Dim
                }
            } catch { }
            if (-not $vssFound) { Write-Host "    [CLEAN] No VSS references found for '$userInput'." -ForegroundColor $C_Clean }

            # --- [19] POWERSHELL HISTORY ---
            Write-Host "`n  [19/20] PowerShell Command History" -ForegroundColor $C_White
            Write-Host "  ──────────────────────────────────────────" -ForegroundColor $C_Dim
            $psFound = $false
            $psHistoryPaths = @(
                "$env:APPDATA\Microsoft\Windows\PowerShell\PSReadLine\ConsoleHost_history.txt",
                "$env:APPDATA\Microsoft\Windows\PowerShell\PSReadLine\Visual Studio Code Host_history.txt"
            )
            foreach ($psHist in $psHistoryPaths) {
                if (Test-Path $psHist) {
                    $matches = Get-Content $psHist -ErrorAction SilentlyContinue | Select-String -Pattern $regexTerm
                    if ($matches) { $matches | ForEach-Object { Add-Result "PS-HISTORY" $psHist "Command: $($_.Line.Trim())"; $psFound = $true } }
                }
            }
            $transcriptRoots = @("$env:USERPROFILE\Documents","$env:WINDIR\System32\config\systemprofile\Documents","C:\Transcripts")
            foreach ($tRoot in $transcriptRoots) {
                if (Test-Path $tRoot) {
                    Get-ChildItem -Path $tRoot -Filter "PowerShell_transcript*.txt" -Recurse -Depth 3 -Force -ErrorAction SilentlyContinue | ForEach-Object {
                        try {
                            $m = Get-Content $_.FullName -ErrorAction SilentlyContinue | Select-String -Pattern $regexTerm
                            if ($m) { $m | Select-Object -First 3 | ForEach-Object { Add-Result "PS-TRANSCRIPT" $_.Path "Line: $($_.Line.Trim())"; $psFound = $true } }
                        } catch { }
                    }
                }
            }
            if (-not $psFound) { Write-Host "    [CLEAN] No PowerShell history references found." -ForegroundColor $C_Clean }

            # --- [20] WMI SUBSCRIPTIONS ---
            Write-Host "`n  [20/20] WMI Event Subscriptions" -ForegroundColor $C_White
            Write-Host "  ──────────────────────────────────────────" -ForegroundColor $C_Dim
            $wmiFound = $false
            try {
                $wmiFilters   = Get-WmiObject -Namespace "root\subscription" -Class "__EventFilter"   -ErrorAction SilentlyContinue
                $wmiConsumers = Get-WmiObject -Namespace "root\subscription" -Class "__EventConsumer" -ErrorAction SilentlyContinue
                $wmiBinders   = Get-WmiObject -Namespace "root\subscription" -Class "__FilterToConsumerBinding" -ErrorAction SilentlyContinue
                foreach ($filter in $wmiFilters) {
                    if ($filter.Name -match $regexTerm -or $filter.Query -match $regexTerm) {
                        Add-Result "WMI-FILTER" "root\subscription\__EventFilter" "Name: $($filter.Name) | Query: $($filter.Query)"; $wmiFound = $true
                    }
                }
                foreach ($consumer in $wmiConsumers) {
                    $consumerStr = "$($consumer.Name) $($consumer.CommandLineTemplate) $($consumer.ScriptText)"
                    if ($consumerStr -match $regexTerm) {
                        Add-Result "WMI-CONSUMER" "root\subscription\__EventConsumer" "Name: $($consumer.Name)"; $wmiFound = $true
                    }
                }
                $totalWmi = ($wmiFilters.Count + $wmiConsumers.Count + $wmiBinders.Count)
                if ($totalWmi -gt 0) {
                    Write-Host "    [INFO] Total WMI subscriptions: $totalWmi (Filters: $($wmiFilters.Count) | Consumers: $($wmiConsumers.Count) | Bindings: $($wmiBinders.Count))" -ForegroundColor $C_Warn
                }
            } catch { }
            if (-not $wmiFound) { Write-Host "    [CLEAN] No WMI subscription references found for '$userInput'." -ForegroundColor $C_Clean }

            # --- FINAL REPORT ---
            $scanEnd      = Get-Date
            $scanDuration = ($scanEnd - $scanStart).TotalSeconds

            Write-Host ""
            Write-Host "  ==========================================" -ForegroundColor $C_Info
            Write-Host "   VAELITH V4  —  SCAN REPORT" -ForegroundColor $C_White
            Write-Host "   Target   : $($userInput.ToUpper())" -ForegroundColor $C_White
            Write-Host "   Modules  : 20" -ForegroundColor $C_White
            Write-Host "   Duration : $([math]::Round($scanDuration,1)) seconds" -ForegroundColor $C_White
            Write-Host "   Total    : $($results.Count) trace(s) found" -ForegroundColor $(if ($results.Count -gt 0) { $C_Found } else { $C_Clean })
            Write-Host "  ==========================================" -ForegroundColor $C_Info

            if ($results.Count -gt 0) {
                Write-Host ""
                Write-Host "  CATEGORY BREAKDOWN:" -ForegroundColor $C_White
                $grouped = $results | Group-Object Category | Sort-Object Count -Descending
                foreach ($g in $grouped) {
                    Write-Host "    $($g.Name.PadRight(20)) : $($g.Count) hit(s)" -ForegroundColor $C_Warn
                }

                Write-Host ""
                $reportPath = "$env:USERPROFILE\Desktop\VAELITH_V4_Report_$($userInput)_$(Get-Date -Format 'yyyyMMdd_HHmmss').txt"
                try {
                    $header = "VAELITH V4 — Forensic Scan Report`nTarget  : $($userInput.ToUpper())`nDate    : $(Get-Date -Format 'yyyy-MM-dd HH:mm:ss')`nSystem  : $env:COMPUTERNAME ($env:USERNAME)`nModules : 20`nTraces  : $($results.Count)`nDuration: $([math]::Round($scanDuration,1)) seconds`n============================================================`n`n"
                    $body = $results | Format-Table -AutoSize | Out-String
                    ($header + $body) | Out-File -FilePath $reportPath -Encoding UTF8
                    Write-Host "  [REPORT] Saved to: $reportPath" -ForegroundColor $C_Info
                } catch {
                    Write-Host "  [WARN] Could not save report: $($_.Exception.Message)" -ForegroundColor $C_Warn
                }
            } else {
                Write-Host ""
                Write-Host "  [CLEAN] System appears clean of '$userInput'." -ForegroundColor $C_Clean
            }

            Read-Host "`nPress Enter to return to menu..."
        }

        "2" {
            # =========================================================
            # --- [2] BAM KEYS VIEWER ---------------------------------
            # =========================================================
            Clear-Host
            Write-Host ""
            Write-Host "  ==========================================" -ForegroundColor $C_Info
            Write-Host "           BAM KEYS VIEWER                  " -ForegroundColor $C_White
            Write-Host "   Background Activity Monitor — Execution   " -ForegroundColor $C_Dim
            Write-Host "  ==========================================" -ForegroundColor $C_Dim
            Write-Host "  Tracks every binary executed, with timestamp." -ForegroundColor $C_Dim
            Write-Host "  Survives reboots. Stored per user SID."       -ForegroundColor $C_Dim
            Write-Host ""

            $bamRoots = @(
                "HKLM:\SYSTEM\ControlSet001\Services\bam\State\UserSettings",
                "HKLM:\SYSTEM\CurrentControlSet\Services\bam\State\UserSettings"
            )

            $userSIDs = Get-ChildItem "Registry::HKEY_USERS" -ErrorAction SilentlyContinue |
                Where-Object { $_.PSChildName -match "^S-1-5-21-\d+-\d+-\d+-\d+$" } |
                Select-Object -ExpandProperty PSChildName

            # Try to resolve SID to username
            function Get-UsernameFromSID {
                param([string]$sid)
                try {
                    $objSID  = New-Object System.Security.Principal.SecurityIdentifier($sid)
                    $objUser = $objSID.Translate([System.Security.Principal.NTAccount])
                    return $objUser.Value
                } catch {
                    return $sid
                }
            }

            $totalEntries = 0
            $bamFound     = $false

            foreach ($bamRoot in $bamRoots) {
                if (-not (Test-Path $bamRoot -ErrorAction SilentlyContinue)) { continue }

                foreach ($sid in $userSIDs) {
                    $bamPath = "$bamRoot\$sid"
                    if (-not (Test-Path $bamPath -ErrorAction SilentlyContinue)) { continue }

                    $username = Get-UsernameFromSID $sid
                    Write-Host "  ── User: $username" -ForegroundColor $C_Info
                    Write-Host "     SID : $sid"      -ForegroundColor $C_Dim
                    Write-Host ""

                    $props = Get-ItemProperty -Path $bamPath -ErrorAction SilentlyContinue
                    if ($null -eq $props) { continue }

                    $entries = @()
                    foreach ($prop in $props.PSObject.Properties) {
                        if ($prop.Name -match "^PS") { continue }
                        if ($prop.Name -match "^SequenceNumber$|^Version$") { continue }

                        # Decode FILETIME timestamp from binary value
                        $timestamp = "N/A"
                        try {
                            if ($prop.Value -is [byte[]] -and $prop.Value.Length -ge 8) {
                                $ft = [System.BitConverter]::ToInt64($prop.Value, 0)
                                if ($ft -gt 0) {
                                    $timestamp = [datetime]::FromFileTime($ft).ToString("dd/MM/yyyy  HH:mm:ss")
                                }
                            }
                        } catch { }

                        $entries += [PSCustomObject]@{
                            Executable = $prop.Name
                            Timestamp  = $timestamp
                        }
                        $totalEntries++
                    }

                    # Sort by timestamp descending
                    $entries = $entries | Sort-Object { 
                        try { [datetime]::ParseExact($_.Timestamp, "dd/MM/yyyy  HH:mm:ss", $null) } 
                        catch { [datetime]::MinValue }
                    } -Descending

                    foreach ($entry in $entries) {
                        Write-Host "    [" -NoNewline -ForegroundColor $C_Dim
                        Write-Host "$($entry.Timestamp)" -NoNewline -ForegroundColor $C_Warn
                        Write-Host "] " -NoNewline -ForegroundColor $C_Dim
                        Write-Host "$($entry.Executable)" -ForegroundColor $C_White
                    }

                    if ($entries.Count -eq 0) {
                        Write-Host "    No BAM entries found for this user." -ForegroundColor $C_Dim
                    }

                    $bamFound = $true
                    Write-Host ""
                }
                break  # Avoid duplicate from both ControlSets
            }

            if (-not $bamFound) {
                Write-Host "  [INFO] No BAM entries found on this system." -ForegroundColor $C_Dim
                Write-Host "  BAM may be disabled or no user activity recorded yet." -ForegroundColor $C_Dim
            }

            Write-Host ""
            Write-Host "  ==========================================" -ForegroundColor $C_Dim
            Write-Host "  Total entries found: $totalEntries" -ForegroundColor $C_Info
            Write-Host "  ==========================================" -ForegroundColor $C_Dim
            Read-Host "`nPress Enter to return to menu..."
        }

        "4" {
            # =========================================================
            # --- [4] PREFETCH VIEWER ---------------------------------
            # =========================================================
            Clear-Host
            Write-Host ""
            Write-Host "  ==========================================" -ForegroundColor $C_Info
            Write-Host "            PREFETCH VIEWER                 " -ForegroundColor $C_White
            Write-Host "   Windows caches app execution data here   " -ForegroundColor $C_Dim
            Write-Host "  ==========================================" -ForegroundColor $C_Dim
            Write-Host "  Each .pf file = one executed application." -ForegroundColor $C_Dim
            Write-Host "  LastWriteTime = last time it was run."     -ForegroundColor $C_Dim
            Write-Host ""

            $prefetchPath = "$env:WINDIR\Prefetch"

            if (-not (Test-Path $prefetchPath)) {
                Write-Host "  [WARN] Prefetch folder not found: $prefetchPath" -ForegroundColor $C_Warn
                Write-Host "  Prefetch may be disabled on this system (common on SSDs)." -ForegroundColor $C_Dim
                Read-Host "`nPress Enter to return to menu..."
                continue
            }

            $pfFiles = Get-ChildItem -Path $prefetchPath -Filter "*.pf" -ErrorAction SilentlyContinue |
                Sort-Object LastWriteTime -Descending

            if ($pfFiles.Count -eq 0) {
                Write-Host "  [INFO] No Prefetch files found." -ForegroundColor $C_Dim
                Read-Host "`nPress Enter to return to menu..."
                continue
            }

            Write-Host "  Found $($pfFiles.Count) prefetch entries — sorted by most recent execution:" -ForegroundColor $C_Info
            Write-Host ""
            Write-Host ("  " + "LAST EXECUTED".PadRight(22) + "  " + "APPLICATION") -ForegroundColor $C_Dim
            Write-Host "  ──────────────────────────────────────────────────────────" -ForegroundColor $C_Dim

            $counter = 0
            foreach ($pf in $pfFiles) {
                $counter++
                $appName   = $pf.BaseName -replace "-[A-F0-9]{8}$", ""
                $lastRun   = $pf.LastWriteTime.ToString("dd/MM/yyyy  HH:mm:ss")
                $sizeKB    = [math]::Round($pf.Length / 1KB, 1)

                $color = if ($counter -le 10) { $C_Found } elseif ($counter -le 30) { $C_Warn } else { $C_White }

                Write-Host ("  " + $lastRun.PadRight(22) + "  ") -NoNewline -ForegroundColor $C_Dim
                Write-Host $appName -ForegroundColor $color
            }

            Write-Host ""
            Write-Host "  ==========================================" -ForegroundColor $C_Dim
            Write-Host "  Total: $($pfFiles.Count) entries" -ForegroundColor $C_Info

            # Export option
            Write-Host ""
            $exportChoice = Read-Host "  Export to TXT on Desktop? (y/n)"
            if ($exportChoice -eq "y" -or $exportChoice -eq "Y") {
                $exportPath = "$env:USERPROFILE\Desktop\VAELITH_Prefetch_$(Get-Date -Format 'yyyyMMdd_HHmmss').txt"
                try {
                    $header = "VAELITH V4 — Prefetch Viewer`nDate   : $(Get-Date -Format 'yyyy-MM-dd HH:mm:ss')`nSystem : $env:COMPUTERNAME`nTotal  : $($pfFiles.Count) entries`n" + ("=" * 60) + "`n`n"
                    $lines  = $pfFiles | ForEach-Object {
                        $n = $_.BaseName -replace "-[A-F0-9]{8}$", ""
                        "$($_.LastWriteTime.ToString('dd/MM/yyyy HH:mm:ss'))   $n"
                    }
                    ($header + ($lines -join "`n")) | Out-File -FilePath $exportPath -Encoding UTF8
                    Write-Host "  [SAVED] $exportPath" -ForegroundColor $C_Info
                } catch {
                    Write-Host "  [WARN] Could not save: $($_.Exception.Message)" -ForegroundColor $C_Warn
                }
            }

            Read-Host "`nPress Enter to return to menu..."
        }

        "5" {
            # =========================================================
            # --- [5] PROCESS EXPLORER --------------------------------
            # =========================================================
            Clear-Host
            Write-Host ""
            Write-Host "  ==========================================" -ForegroundColor $C_Info
            Write-Host "            PROCESS EXPLORER                " -ForegroundColor $C_White
            Write-Host "      Live snapshot of running processes     " -ForegroundColor $C_Dim
            Write-Host "  ==========================================" -ForegroundColor $C_Dim
            Write-Host ""

            Write-Host "  Collecting process data..." -ForegroundColor $C_Dim
            Write-Host ""

            try {
                $processes = Get-Process -ErrorAction SilentlyContinue | Sort-Object CPU -Descending

                # Get owner info via WMI (slower but accurate)
                $wmiProcs = @{}
                try {
                    Get-WmiObject Win32_Process -ErrorAction SilentlyContinue | ForEach-Object {
                        $owner = $_.GetOwner()
                        $wmiProcs[$_.ProcessId] = if ($owner.User) { "$($owner.Domain)\$($owner.User)" } else { "SYSTEM" }
                    }
                } catch { }

                Write-Host ("  " + "PID".PadRight(8) + "CPU(s)".PadRight(10) + "MEM(MB)".PadRight(10) + "OWNER".PadRight(25) + "PROCESS") -ForegroundColor $C_Dim
                Write-Host "  ──────────────────────────────────────────────────────────────────────" -ForegroundColor $C_Dim

                $suspicious = @("mimikatz","meterpreter","rat","keylog","inject","hook","dump","hack","cheat","bypass","spoof","ghost")

                foreach ($proc in $processes) {
                    $pid_    = $proc.Id
                    $name    = $proc.Name
                    $cpuS    = [math]::Round($proc.CPU, 1)
                    $memMB   = [math]::Round($proc.WorkingSet64 / 1MB, 1)
                    $owner   = if ($wmiProcs.ContainsKey($pid_)) { $wmiProcs[$pid_] } else { "N/A" }

                    # Flag suspicious process names
                    $isSusp  = $suspicious | Where-Object { $name -match $_ }
                    $color   = if ($isSusp) { $C_Found } elseif ($cpuS -gt 50) { $C_Warn } else { $C_White }

                    $flag = if ($isSusp) { " [!]" } else { "" }

                    Write-Host ("  " + "$pid_".PadRight(8) + "$cpuS".PadRight(10) + "$memMB".PadRight(10) + $owner.PadRight(25)) -NoNewline -ForegroundColor $C_Dim
                    Write-Host "$name$flag" -ForegroundColor $color
                }

                Write-Host ""
                Write-Host "  ==========================================" -ForegroundColor $C_Dim
                Write-Host "  Total processes: $($processes.Count)" -ForegroundColor $C_Info
                Write-Host "  [!] = Potentially suspicious name" -ForegroundColor $C_Found

                # Show full path for suspicious ones
                $suspProcs = $processes | Where-Object { $name = $_.Name; $suspicious | Where-Object { $name -match $_ } }
                if ($suspProcs) {
                    Write-Host ""
                    Write-Host "  SUSPICIOUS PROCESS DETAILS:" -ForegroundColor $C_Found
                    foreach ($sp in $suspProcs) {
                        Write-Host "    PID $($sp.Id) — $($sp.Name)" -ForegroundColor $C_Found
                        try {
                            $path = (Get-WmiObject Win32_Process -Filter "ProcessId=$($sp.Id)" -ErrorAction SilentlyContinue).ExecutablePath
                            Write-Host "    Path: $path" -ForegroundColor $C_Warn
                        } catch { }
                    }
                }

                # Export option
                Write-Host ""
                $exportChoice = Read-Host "  Export process list to Desktop? (y/n)"
                if ($exportChoice -eq "y" -or $exportChoice -eq "Y") {
                    $exportPath = "$env:USERPROFILE\Desktop\VAELITH_Processes_$(Get-Date -Format 'yyyyMMdd_HHmmss').txt"
                    try {
                        $header = "VAELITH V4 — Process Explorer`nDate   : $(Get-Date -Format 'yyyy-MM-dd HH:mm:ss')`nSystem : $env:COMPUTERNAME`nTotal  : $($processes.Count) processes`n" + ("=" * 60) + "`n`n"
                        $body   = $processes | Select-Object Id, Name, CPU, @{N="MemMB";E={[math]::Round($_.WorkingSet64/1MB,1)}} | Format-Table -AutoSize | Out-String
                        ($header + $body) | Out-File -FilePath $exportPath -Encoding UTF8
                        Write-Host "  [SAVED] $exportPath" -ForegroundColor $C_Info
                    } catch {
                        Write-Host "  [WARN] Could not save: $($_.Exception.Message)" -ForegroundColor $C_Warn
                    }
                }

            } catch {
                Write-Host "  [ERROR] Could not enumerate processes: $($_.Exception.Message)" -ForegroundColor $C_Found
            }

            Read-Host "`nPress Enter to return to menu..."
        }

        "6" {
            # =========================================================
            # --- [6] LAST ACTIVITY VIEWER ----------------------------
            # =========================================================
            Clear-Host
            Write-Host ""
            Write-Host "  ==========================================" -ForegroundColor $C_Info
            Write-Host "          LAST ACTIVITY VIEWER              " -ForegroundColor $C_White
            Write-Host "    Recent files, searches, apps & logins   " -ForegroundColor $C_Dim
            Write-Host "  ==========================================" -ForegroundColor $C_Dim
            Write-Host ""

            # --- RECENT FILES (Shell Recent) ---
            Write-Host "  [ RECENT FILES — Last 20 Opened ]" -ForegroundColor $C_Info
            Write-Host "  ──────────────────────────────────────────" -ForegroundColor $C_Dim

            $recentPath = "$env:APPDATA\Microsoft\Windows\Recent"
            if (Test-Path $recentPath) {
                $recentFiles = Get-ChildItem -Path $recentPath -Filter "*.lnk" -Force -ErrorAction SilentlyContinue |
                    Sort-Object LastWriteTime -Descending |
                    Select-Object -First 20

                $wshell2 = New-Object -ComObject WScript.Shell -ErrorAction SilentlyContinue
                foreach ($lnk in $recentFiles) {
                    $target = ""
                    try {
                        if ($null -ne $wshell2) {
                            $sc     = $wshell2.CreateShortcut($lnk.FullName)
                            $target = $sc.TargetPath
                        }
                    } catch { }
                    $displayName = if ($target) { $target } else { $lnk.BaseName }
                    Write-Host ("  " + $lnk.LastWriteTime.ToString("dd/MM/yyyy  HH:mm:ss").PadRight(22) + "  ") -NoNewline -ForegroundColor $C_Dim
                    Write-Host $displayName -ForegroundColor $C_White
                }
            } else {
                Write-Host "  [INFO] Recent folder not found." -ForegroundColor $C_Dim
            }

            Write-Host ""

            # --- EXPLORER SEARCH HISTORY (WordWheelQuery) ---
            Write-Host "  [ EXPLORER SEARCH HISTORY ]" -ForegroundColor $C_Info
            Write-Host "  ──────────────────────────────────────────" -ForegroundColor $C_Dim

            $wwqPath = "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\WordWheelQuery"
            $searchTermsFound = $false
            if (Test-Path $wwqPath -ErrorAction SilentlyContinue) {
                $wwqProps = Get-ItemProperty -Path $wwqPath -ErrorAction SilentlyContinue
                if ($null -ne $wwqProps) {
                    $searchEntries = @()
                    foreach ($prop in $wwqProps.PSObject.Properties) {
                        if ($prop.Name -match "^PS|^MRUListEx$") { continue }
                        $valStr = ""
                        try {
                            if ($prop.Value -is [byte[]]) { $valStr = [System.Text.Encoding]::Unicode.GetString($prop.Value).TrimEnd([char]0) }
                            else { $valStr = [string]$prop.Value }
                        } catch { }
                        if ($valStr) { $searchEntries += $valStr }
                    }
                    if ($searchEntries.Count -gt 0) {
                        $searchEntries | ForEach-Object { Write-Host "    >> $_" -ForegroundColor $C_Warn }
                        $searchTermsFound = $true
                    }
                }
            }
            if (-not $searchTermsFound) {
                Write-Host "  [CLEAN] No Explorer search history found." -ForegroundColor $C_Clean
            }

            Write-Host ""

            # --- RUN DIALOG HISTORY (Win+R) ---
            Write-Host "  [ RUN DIALOG HISTORY (Win+R) ]" -ForegroundColor $C_Info
            Write-Host "  ──────────────────────────────────────────" -ForegroundColor $C_Dim

            $runMRU = "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\RunMRU"
            $runFound = $false
            if (Test-Path $runMRU -ErrorAction SilentlyContinue) {
                $runProps = Get-ItemProperty -Path $runMRU -ErrorAction SilentlyContinue
                if ($null -ne $runProps) {
                    foreach ($prop in $runProps.PSObject.Properties) {
                        if ($prop.Name -match "^PS|^MRUList$") { continue }
                        Write-Host "    >> $($prop.Value)" -ForegroundColor $C_Warn
                        $runFound = $true
                    }
                }
            }
            if (-not $runFound) { Write-Host "  [CLEAN] No Run dialog history found." -ForegroundColor $C_Clean }

            Write-Host ""

            # --- TYPED PATHS (Explorer Address Bar) ---
            Write-Host "  [ TYPED PATHS (Explorer Address Bar) ]" -ForegroundColor $C_Info
            Write-Host "  ──────────────────────────────────────────" -ForegroundColor $C_Dim

            $typedPaths = "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\TypedPaths"
            $tpFound = $false
            if (Test-Path $typedPaths -ErrorAction SilentlyContinue) {
                $tpProps = Get-ItemProperty -Path $typedPaths -ErrorAction SilentlyContinue
                if ($null -ne $tpProps) {
                    foreach ($prop in $tpProps.PSObject.Properties) {
                        if ($prop.Name -match "^PS") { continue }
                        Write-Host "    >> $($prop.Value)" -ForegroundColor $C_Warn
                        $tpFound = $true
                    }
                }
            }
            if (-not $tpFound) { Write-Host "  [CLEAN] No typed paths found." -ForegroundColor $C_Clean }

            Write-Host ""

            # --- LAST LOGIN EVENTS ---
            Write-Host "  [ LAST LOGIN / LOGOFF EVENTS ]" -ForegroundColor $C_Info
            Write-Host "  ──────────────────────────────────────────" -ForegroundColor $C_Dim

            try {
                $loginEvents = Get-WinEvent -FilterHashtable @{
                    LogName = 'Security'
                    Id      = @(4624, 4634, 4647, 4800, 4801)
                } -MaxEvents 20 -ErrorAction SilentlyContinue | Sort-Object TimeCreated -Descending

                if ($loginEvents) {
                    foreach ($evt in $loginEvents) {
                        $label = switch ($evt.Id) {
                            4624  { "LOGON " }
                            4634  { "LOGOFF" }
                            4647  { "LOGOFF" }
                            4800  { "LOCKED" }
                            4801  { "UNLOCK" }
                            default { "EVENT " }
                        }
                        $color = switch ($evt.Id) {
                            4624  { $C_Clean }
                            4634  { $C_Dim }
                            4647  { $C_Dim }
                            4800  { $C_Warn }
                            4801  { $C_Info }
                            default { $C_White }
                        }
                        Write-Host ("  [$label] " ) -NoNewline -ForegroundColor $color
                        Write-Host $evt.TimeCreated.ToString("dd/MM/yyyy  HH:mm:ss") -ForegroundColor $C_White
                    }
                } else {
                    Write-Host "  [INFO] No login events found (may need audit policy enabled)." -ForegroundColor $C_Dim
                }
            } catch {
                Write-Host "  [SKIP] Cannot read Security log: $($_.Exception.Message)" -ForegroundColor $C_Dim
            }

            Write-Host ""

            # --- RECENTLY INSTALLED PROGRAMS ---
            Write-Host "  [ RECENTLY INSTALLED PROGRAMS (last 30 days) ]" -ForegroundColor $C_Info
            Write-Host "  ──────────────────────────────────────────" -ForegroundColor $C_Dim

            $uninstallPaths = @(
                "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall",
                "HKLM:\SOFTWARE\WOW6432Node\Microsoft\Windows\CurrentVersion\Uninstall",
                "HKCU:\Software\Microsoft\Windows\CurrentVersion\Uninstall"
            )

            $cutoff = (Get-Date).AddDays(-30)
            $recentInstalls = @()

            foreach ($uPath in $uninstallPaths) {
                if (Test-Path $uPath -ErrorAction SilentlyContinue) {
                    Get-ChildItem -Path $uPath -ErrorAction SilentlyContinue | ForEach-Object {
                        $props = Get-ItemProperty -Path $_.PSPath -ErrorAction SilentlyContinue
                        if ($null -ne $props -and $props.DisplayName -and $props.InstallDate) {
                            try {
                                $installDate = [datetime]::ParseExact($props.InstallDate.ToString(), "yyyyMMdd", $null)
                                if ($installDate -ge $cutoff) {
                                    $recentInstalls += [PSCustomObject]@{
                                        Date    = $installDate
                                        Program = $props.DisplayName
                                        Version = $props.DisplayVersion
                                    }
                                }
                            } catch { }
                        }
                    }
                }
            }

            if ($recentInstalls.Count -gt 0) {
                $recentInstalls | Sort-Object Date -Descending | ForEach-Object {
                    Write-Host ("  " + $_.Date.ToString("dd/MM/yyyy").PadRight(14)) -NoNewline -ForegroundColor $C_Dim
                    Write-Host "$($_.Program)  " -NoNewline -ForegroundColor $C_White
                    Write-Host "v$($_.Version)" -ForegroundColor $C_Dim
                }
            } else {
                Write-Host "  [CLEAN] No programs installed in the last 30 days." -ForegroundColor $C_Clean
            }

            Write-Host ""

            # --- RECENTLY ACCESSED USB DEVICES ---
            Write-Host "  [ USB DEVICES HISTORY ]" -ForegroundColor $C_Info
            Write-Host "  ──────────────────────────────────────────" -ForegroundColor $C_Dim

            $usbPath = "HKLM:\SYSTEM\CurrentControlSet\Enum\USBSTOR"
            $usbFound = $false
            if (Test-Path $usbPath -ErrorAction SilentlyContinue) {
                Get-ChildItem -Path $usbPath -ErrorAction SilentlyContinue | ForEach-Object {
                    $deviceType = $_.PSChildName
                    Get-ChildItem -Path $_.PSPath -ErrorAction SilentlyContinue | ForEach-Object {
                        $props = Get-ItemProperty -Path $_.PSPath -ErrorAction SilentlyContinue
                        $friendlyName = $props.FriendlyName
                        if ($friendlyName) {
                            Write-Host "    >> $friendlyName" -ForegroundColor $C_Warn
                            Write-Host "       Type: $deviceType" -ForegroundColor $C_Dim
                            $usbFound = $true
                        }
                    }
                }
            }
            if (-not $usbFound) { Write-Host "  [CLEAN] No USB storage devices found in registry." -ForegroundColor $C_Clean }

            Write-Host ""
            Write-Host "  ==========================================" -ForegroundColor $C_Dim

            # Export option
            $exportChoice = Read-Host "  Export activity report to Desktop? (y/n)"
            if ($exportChoice -eq "y" -or $exportChoice -eq "Y") {
                $exportPath = "$env:USERPROFILE\Desktop\VAELITH_Activity_$(Get-Date -Format 'yyyyMMdd_HHmmss').txt"
                try {
                    $out = "VAELITH V4 — Last Activity Viewer`nDate   : $(Get-Date -Format 'yyyy-MM-dd HH:mm:ss')`nSystem : $env:COMPUTERNAME ($env:USERNAME)`n" + ("=" * 60) + "`n`n"

                    $out += "=== RECENT FILES ===`n"
                    if (Test-Path $recentPath) {
                        Get-ChildItem -Path $recentPath -Filter "*.lnk" -Force -ErrorAction SilentlyContinue |
                            Sort-Object LastWriteTime -Descending | Select-Object -First 30 |
                            ForEach-Object { $out += "$($_.LastWriteTime.ToString('dd/MM/yyyy HH:mm:ss'))   $($_.BaseName)`n" }
                    }

                    $out += "`n=== RECENTLY INSTALLED (30 days) ===`n"
                    if ($recentInstalls.Count -gt 0) {
                        $recentInstalls | Sort-Object Date -Descending | ForEach-Object {
                            $out += "$($_.Date.ToString('dd/MM/yyyy'))   $($_.Program)  v$($_.Version)`n"
                        }
                    }

                    $out | Out-File -FilePath $exportPath -Encoding UTF8
                    Write-Host "  [SAVED] $exportPath" -ForegroundColor $C_Info
                } catch {
                    Write-Host "  [WARN] Could not save: $($_.Exception.Message)" -ForegroundColor $C_Warn
                }
            }

            Read-Host "`nPress Enter to return to menu..."
        }
        "0" {
            Write-Host "`n  Exiting VAELITH..." -ForegroundColor $C_Found
            exit
        }
    }
}
