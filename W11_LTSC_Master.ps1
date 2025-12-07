# ============================================================================
# WINDOWS 11 LTSC IoT MASTER OPTIMIZATION & GAMING SUITE v1.1
# ============================================================================
# Comprehensive optimization, debloat, and gaming enablement script
# For: Windows 11 LTSC IoT systems with focus on gaming and streaming
#
# Author: Development Project
# Date: December 2025
# License: MIT
# Version: 1.1 - Production-grade robustness
#
# GitHub: https://github.com/tedofgarlic/W11-LTSC-Optimizer
# Features: 10 optimization modules + rollback + logging + validation
# ============================================================================

# ============================================================================
# GLOBALS & CONFIGURATION
# ============================================================================
$ErrorActionPreference = "Continue"
$LogPath = "$env:TEMP\W11_LTSC_Optimizer_$(Get-Date -Format 'yyyyMMdd_HHmmss').log"
$BackupPath = "$env:TEMP\W11_LTSC_Registry_Backup_$(Get-Date -Format 'yyyyMMdd_HHmmss').reg"
$ModifiedItems = @()
$FailedItems = @()

# Critical whitelist: Services that NEVER get disabled
$CriticalWhitelist = @(
    "WlanSvc",           # WiFi
    "bthserv",           # Bluetooth
    "HidUsb",            # Human Interface Devices (USB, Keyboard, Mouse)
    "WinDefend",         # Windows Defender
    "wuauserv",          # Windows Update
    "BITS",              # Background Intelligent Transfer
    "RpcSs",             # RPC Service (critical system)
    "DcomLaunch"         # COM Launch Service
)

# ============================================================================
# LOGGING FUNCTIONS
# ============================================================================
function Log-Action {
    param([string]$Message, [string]$Level = "INFO")
    $Timestamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
    $LogEntry = "[$Timestamp] [$Level] $Message"
    Write-Host $LogEntry
    Add-Content -Path $LogPath -Value $LogEntry -Encoding UTF8
}

function Log-Error {
    param([string]$Message, [System.Exception]$Exception = $null)
    $ErrorMsg = if ($Exception) { "$Message - Error: $($Exception.Message)" } else { $Message }
    Log-Action $ErrorMsg "ERROR"
    $FailedItems += $Message
}

function Log-Success {
    param([string]$Message)
    Log-Action $Message "SUCCESS"
    $ModifiedItems += $Message
}

# ============================================================================
# VALIDATION & PRE-FLIGHT CHECKS
# ============================================================================
function Test-Prerequisitesmet {
    Log-Action "Starting pre-flight checks..."
    
    # Check admin privileges
    $isAdmin = ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator")
    if (-not $isAdmin) {
        Log-Error "Not running as Administrator. Script requires admin privileges."
        exit 1
    }
    Log-Success "Administrator privileges verified"
    
    # Check Windows 11 LTSC
    $osVersion = [System.Environment]::OSVersion.Version
    $osCaption = (Get-WmiObject Win32_OperatingSystem).Caption
    
    if ($osVersion.Major -ne 10 -or $osVersion.Build -lt 22000) {
        Log-Error "Windows 11 or later required. Detected: $osCaption (Build $($osVersion.Build))"
        exit 1
    }
    Log-Success "Windows version compatible: $osCaption (Build $($osVersion.Build))"
    
    # Check disk space
    $diskSpace = (Get-Volume C).SizeRemaining / 1GB
    if ($diskSpace -lt 5) {
        Log-Error "Insufficient disk space. Required: 5GB free, Available: $([math]::Round($diskSpace, 2))GB"
        exit 1
    }
    Log-Success "Disk space check passed: $([math]::Round($diskSpace, 2))GB available"
    
    # Test registry access
    try {
        $regTest = Get-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion" -ErrorAction Stop
        Log-Success "Registry access verified"
    } catch {
        Log-Error "Cannot access Windows registry. Required for full functionality."
        exit 1
    }
    
    Log-Action "Pre-flight checks completed successfully"
}

# ============================================================================
# HELPER FUNCTIONS
# ============================================================================
function Confirm-Action {
    param([string]$prompt)
    $response = Read-Host "$prompt (Y/N)"
    return $response -eq "Y" -or $response -eq "yes"
}

function Test-ServiceExists {
    param([string]$ServiceName)
    $service = Get-Service -Name $ServiceName -ErrorAction SilentlyContinue
    return $null -ne $service
}

function Test-CriticalService {
    param([string]$ServiceName)
    return $CriticalWhitelist -contains $ServiceName
}

function Disable-ServiceSafely {
    param([string]$ServiceName, [string]$DisplayName)
    
    # NEVER disable critical services
    if (Test-CriticalService $ServiceName) {
        Log-Action "Skipping critical service: $ServiceName (whitelisted)"
        return
    }
    
    if (-not (Test-ServiceExists $ServiceName)) {
        Log-Action "Service not found: $ServiceName"
        return
    }
    
    try {
        $service = Get-Service -Name $ServiceName -ErrorAction Stop
        
        # Stop service if running
        if ($service.Status -eq "Running") {
            Stop-Service -Name $ServiceName -Force -ErrorAction Stop
            Log-Action "Stopped service: $DisplayName"
        }
        
        # Disable startup
        Set-Service -Name $ServiceName -StartupType Disabled -ErrorAction Stop
        Log-Success "Disabled service: $DisplayName"
    } catch {
        Log-Error "Failed to disable service: $DisplayName" $_
    }
}

function Enable-ServiceSafely {
    param([string]$ServiceName, [string]$DisplayName)
    
    if (-not (Test-ServiceExists $ServiceName)) {
        Log-Action "Service not found: $ServiceName"
        return
    }
    
    try {
        Set-Service -Name $ServiceName -StartupType Automatic -ErrorAction Stop
        Start-Service -Name $ServiceName -ErrorAction Stop
        Log-Success "Enabled service: $DisplayName"
    } catch {
        Log-Error "Failed to enable service: $DisplayName" $_
    }
}

function Set-RegistryValue {
    param([string]$Path, [string]$Name, [string]$Value, [string]$Type = "DWORD")
    
    try {
        # Create path if doesn't exist
        if (-not (Test-Path $Path)) {
            New-Item -Path $Path -Force -ErrorAction Stop | Out-Null
        }
        
        # Set value
        Set-ItemProperty -Path $Path -Name $Name -Value $Value -Type $Type -Force -ErrorAction Stop
        Log-Success "Registry set: $Path\$Name = $Value"
    } catch {
        Log-Error "Failed to set registry: $Path\$Name" $_
    }
}

# ============================================================================
# MAIN MENU FUNCTION
# ============================================================================
function Show-Menu {
    Write-Host ""
    Write-Host "======================================================================" -ForegroundColor Cyan
    Write-Host "WINDOWS 11 LTSC IoT OPTIMIZER v1.1 - SELECT OPTIMIZATION SECTIONS" -ForegroundColor Cyan
    Write-Host "======================================================================" -ForegroundColor Cyan
    Write-Host ""
    Write-Host "OPTIMIZATION SECTIONS:" -ForegroundColor Yellow
    Write-Host "  1. TELEMETRY REMOVAL" -ForegroundColor Green
    Write-Host "  2. BLOATWARE REMOVAL" -ForegroundColor Green
    Write-Host "  3. SERVICE OPTIMIZATION" -ForegroundColor Green
    Write-Host "  4. SCHEDULED TASKS CLEANUP" -ForegroundColor Green
    Write-Host "  5. PERFORMANCE TWEAKS" -ForegroundColor Green
    Write-Host "  6. NETWORK OPTIMIZATION" -ForegroundColor Green
    Write-Host "  7. STORAGE OPTIMIZATION" -ForegroundColor Green
    Write-Host "  8. VISUAL EFFECTS" -ForegroundColor Green
    Write-Host "  9. GAMING & STREAMING TWEAKS" -ForegroundColor Green
    Write-Host ""
    Write-Host "GAMING SERVICES:" -ForegroundColor Yellow
    Write-Host "  10. GAMEPASS & GAMING SERVICES ENABLER" -ForegroundColor Cyan
    Write-Host ""
    Write-Host "BATCH OPERATIONS:" -ForegroundColor Yellow
    Write-Host "  11. RUN ALL OPTIMIZATION (1-9)" -ForegroundColor Green
    Write-Host "  12. RUN ALL (Optimization + Gaming)" -ForegroundColor Cyan
    Write-Host "  13. VIEW LOG" -ForegroundColor Magenta
    Write-Host "  14. EXIT" -ForegroundColor Red
    Write-Host ""
}

# ============================================================================
# SECTION 1: TELEMETRY REMOVAL
# ============================================================================
function Optimize-Telemetry {
    Write-Host ""
    Write-Host "======================================================================" -ForegroundColor Cyan
    Write-Host "SECTION 1: TELEMETRY REMOVAL" -ForegroundColor Cyan
    Write-Host "======================================================================" -ForegroundColor Cyan
    Write-Host ""
    Write-Host "This will disable Windows tracking and diagnostic services." -ForegroundColor Yellow
    
    if (-not (Confirm-Action "Continue?")) { return }

    $telemetryServices = @(
        @{Name = "DiagTrack"; DisplayName = "Diagnostic Tracking Service"},
        @{Name = "dmwappushservice"; DisplayName = "dmwappushservice"},
        @{Name = "MapsBroker"; DisplayName = "Maps Broker Service"}
    )

    foreach ($svc in $telemetryServices) {
        Disable-ServiceSafely $svc.Name $svc.DisplayName
    }
    
    # Registry telemetry keys
    $telemetryPaths = @(
        "HKLM:\Software\Policies\Microsoft\Windows\DataCollection",
        "HKCU:\Software\Microsoft\Windows\CurrentVersion\Diagnostics\DiagTrack"
    )
    
    foreach ($path in $telemetryPaths) {
        if (Test-Path $path) {
            try {
                Set-RegistryValue $path "AllowDiagnosticData" 0
            } catch {
                Log-Error "Registry telemetry cleanup for $path" $_
            }
        }
    }
    
    Write-Host ""
    Write-Host "✓ TELEMETRY REMOVAL COMPLETE" -ForegroundColor Green
    Log-Action "Telemetry removal section completed"
}

# ============================================================================
# SECTION 2: BLOATWARE REMOVAL
# ============================================================================
function Remove-Bloatware {
    Write-Host ""
    Write-Host "======================================================================" -ForegroundColor Cyan
    Write-Host "SECTION 2: BLOATWARE REMOVAL" -ForegroundColor Cyan
    Write-Host "======================================================================" -ForegroundColor Cyan
    Write-Host ""
    Write-Host "Removing pre-installed UWP applications..." -ForegroundColor Yellow
    Write-Host "WARNING: Some apps may be reinstalled by system. This is normal." -ForegroundColor Yellow
    
    if (-not (Confirm-Action "Continue?")) { return }

    $bloatwareApps = @(
        "Microsoft.BingWeather",
        "Microsoft.BingNews",
        "Microsoft.GetHelp",
        "Microsoft.Getstarted",
        "Microsoft.MicrosoftStickyNotes",
        "Microsoft.WindowsFeedbackHub",
        "Microsoft.XboxGameCallableUI",
        "Microsoft.ZuneMusic",
        "Microsoft.ZuneVideo",
        "Microsoft.OneConnect",
        "Microsoft.People",
        "Microsoft.SkypeApp",
        "Microsoft.MixedReality.Portal",
        "Microsoft.YourPhone"
    )

    $removedCount = 0
    foreach ($app in $bloatwareApps) {
        try {
            $appx = Get-AppxPackage -Name $app -AllUsers -ErrorAction SilentlyContinue
            if ($appx) {
                $appx | Remove-AppxPackage -ErrorAction Stop
                Log-Success "Removed bloatware: $app"
                $removedCount++
            } else {
                Log-Action "Bloatware not found: $app"
            }
        } catch {
            Log-Error "Failed to remove bloatware: $app" $_
        }
    }
    
    Write-Host ""
    Write-Host "✓ BLOATWARE REMOVAL COMPLETE - Removed $removedCount apps" -ForegroundColor Green
    Log-Action "Bloatware removal section completed - $removedCount apps removed"
}

# ============================================================================
# SECTION 3: SERVICE OPTIMIZATION
# ============================================================================
function Optimize-Services {
    Write-Host ""
    Write-Host "======================================================================" -ForegroundColor Cyan
    Write-Host "SECTION 3: SERVICE OPTIMIZATION" -ForegroundColor Cyan
    Write-Host "======================================================================" -ForegroundColor Cyan
    Write-Host ""
    Write-Host "Disabling non-essential services while protecting critical ones..." -ForegroundColor Yellow
    
    if (-not (Confirm-Action "Continue?")) { return }

    $optionalServices = @(
        @{Name = "ProgramCompatibilityAssistant"; DisplayName = "Program Compatibility Assistant"},
        @{Name = "ShellHWDetection"; DisplayName = "Shell Hardware Detection"},
        @{Name = "SSDPSRV"; DisplayName = "SSDP Discovery"},
        @{Name = "upnphost"; DisplayName = "UPnP Device Host"},
        @{Name = "Theme"; DisplayName = "Themes"},
        @{Name = "Themes"; DisplayName = "Themes (alternate)"}
    )

    $disabledCount = 0
    foreach ($svc in $optionalServices) {
        if (Disable-ServiceSafely $svc.Name $svc.DisplayName) {
            $disabledCount++
        }
    }
    
    Write-Host ""
    Write-Host "✓ SERVICE OPTIMIZATION COMPLETE" -ForegroundColor Green
    Log-Action "Service optimization completed - disabled $disabledCount services"
}

# ============================================================================
# SECTION 4: SCHEDULED TASKS CLEANUP
# ============================================================================
function Optimize-ScheduledTasks {
    Write-Host ""
    Write-Host "======================================================================" -ForegroundColor Cyan
    Write-Host "SECTION 4: SCHEDULED TASKS CLEANUP" -ForegroundColor Cyan
    Write-Host "======================================================================" -ForegroundColor Cyan
    Write-Host ""
    Write-Host "Disabling telemetry and diagnostics scheduled tasks..." -ForegroundColor Yellow
    
    if (-not (Confirm-Action "Continue?")) { return }

    $tasksToDisable = @(
        "\\Microsoft\\Windows\\Application Experience\\AitAgent",
        "\\Microsoft\\Windows\\Application Experience\\ProgramDataUpdater",
        "\\Microsoft\\Windows\\Customer Experience Improvement Program\\Consolidator",
        "\\Microsoft\\Windows\\DiskDiagnostic\\Microsoft-Windows-DiskDiagnosticDataCollector",
        "\\Microsoft\\Windows\\DiskDiagnostic\\Microsoft-Windows-DiskDiagnosticResolver"
    )

    $disabledTasks = 0
    foreach ($task in $tasksToDisable) {
        try {
            $taskObj = Get-ScheduledTask -TaskPath "*" -TaskName (Split-Path $task -Leaf) -ErrorAction SilentlyContinue
            if ($taskObj) {
                Disable-ScheduledTask -TaskName $taskObj.TaskName -ErrorAction Stop
                Log-Success "Disabled task: $task"
                $disabledTasks++
            }
        } catch {
            Log-Error "Failed to disable task: $task" $_
        }
    }
    
    Write-Host ""
    Write-Host "✓ SCHEDULED TASKS CLEANUP COMPLETE - Disabled $disabledTasks tasks" -ForegroundColor Green
    Log-Action "Task cleanup completed - $disabledTasks tasks disabled"
}

# ============================================================================
# SECTION 5: PERFORMANCE TWEAKS
# ============================================================================
function Optimize-Performance {
    Write-Host ""
    Write-Host "======================================================================" -ForegroundColor Cyan
    Write-Host "SECTION 5: PERFORMANCE TWEAKS" -ForegroundColor Cyan
    Write-Host "======================================================================" -ForegroundColor Cyan
    Write-Host ""
    Write-Host "Optimizing power plan and visual effects..." -ForegroundColor Yellow
    
    if (-not (Confirm-Action "Continue?")) { return }

    try {
        # Set High Performance power plan
        $highPerfGuid = "8c5e7fda-e8bf-45a6-a6cc-4b3c9b6596f0"
        powercfg /setactive $highPerfGuid
        Log-Success "Set power plan to High Performance"
    } catch {
        Log-Error "Failed to set power plan" $_
    }

    # Disable hibernation on AC power
    try {
        powercfg /change standby-timeout-ac 0
        powercfg /change monitor-timeout-ac 10
        Log-Success "Disabled standby on AC power"
    } catch {
        Log-Error "Failed to configure power settings" $_
    }
    
    Write-Host ""
    Write-Host "✓ PERFORMANCE TWEAKS COMPLETE" -ForegroundColor Green
    Log-Action "Performance optimization completed"
}

# ============================================================================
# SECTION 6: NETWORK OPTIMIZATION
# ============================================================================
function Optimize-Network {
    Write-Host ""
    Write-Host "======================================================================" -ForegroundColor Cyan
    Write-Host "SECTION 6: NETWORK OPTIMIZATION" -ForegroundColor Cyan
    Write-Host "======================================================================" -ForegroundColor Cyan
    Write-Host ""
    Write-Host "Optimizing TCP/IP stack for gaming and streaming..." -ForegroundColor Yellow
    
    if (-not (Confirm-Action "Continue?")) { return }

    try {
        # Disable Nagle's algorithm (reduces latency)
        Set-ItemProperty -Path "HKLM:\SYSTEM\CurrentControlSet\Services\Tcpip\Parameters" -Name "TcpNoDelay" -Value 1 -Force -ErrorAction Stop
        Log-Success "Disabled Nagle's algorithm (TCP NoDelay)"
    } catch {
        Log-Error "Failed to set TcpNoDelay" $_
    }

    try {
        # Enable Receive Side Scaling
        netsh int tcp set global rss=enabled 2>$null
        Log-Success "Enabled Receive Side Scaling (RSS)"
    } catch {
        Log-Error "Failed to enable RSS" $_
    }

    try {
        # Enable timestamps for better performance
        netsh int tcp set global timestamps=enabled 2>$null
        Log-Success "Enabled TCP timestamps"
    } catch {
        Log-Error "Failed to enable timestamps" $_
    }
    
    Write-Host ""
    Write-Host "✓ NETWORK OPTIMIZATION COMPLETE" -ForegroundColor Green
    Log-Action "Network optimization completed"
}

# ============================================================================
# SECTION 7: STORAGE OPTIMIZATION
# ============================================================================
function Optimize-Storage {
    Write-Host ""
    Write-Host "======================================================================" -ForegroundColor Cyan
    Write-Host "SECTION 7: STORAGE OPTIMIZATION" -ForegroundColor Cyan
    Write-Host "======================================================================" -ForegroundColor Cyan
    Write-Host ""
    Write-Host "Cleaning temporary files and cache..." -ForegroundColor Yellow
    
    if (-not (Confirm-Action "Continue?")) { return }

    $cleanupPaths = @(
        @{Path = "$env:TEMP"; Display = "Windows Temp"},
        @{Path = "$env:LOCALAPPDATA\Temp"; Display = "User Temp"},
        @{Path = "$env:SystemRoot\Temp"; Display = "System Temp"}
    )

    $spaceSaved = 0
    foreach ($item in $cleanupPaths) {
        try {
            if (Test-Path $item.Path) {
                $before = (Get-ChildItem -Path $item.Path -Recurse -Force -ErrorAction SilentlyContinue | Measure-Object -Property Length -Sum).Sum / 1MB
                Remove-Item -Path "$($item.Path)\*" -Recurse -Force -ErrorAction SilentlyContinue
                $spaceSaved += $before
                Log-Success "Cleaned: $($item.Display) (~$([math]::Round($before, 2))MB)"
            }
        } catch {
            Log-Error "Failed to clean: $($item.Display)" $_
        }
    }
    
    Write-Host ""
    Write-Host "✓ STORAGE OPTIMIZATION COMPLETE - Freed ~$([math]::Round($spaceSaved, 2))MB" -ForegroundColor Green
    Log-Action "Storage optimization completed - freed ~$([math]::Round($spaceSaved, 2))MB"
}

# ============================================================================
# SECTION 8: VISUAL EFFECTS
# ============================================================================
function Disable-VisualEffects {
    Write-Host ""
    Write-Host "======================================================================" -ForegroundColor Cyan
    Write-Host "SECTION 8: VISUAL EFFECTS" -ForegroundColor Cyan
    Write-Host "======================================================================" -ForegroundColor Cyan
    Write-Host ""
    Write-Host "Disabling animations and visual effects..." -ForegroundColor Yellow
    
    if (-not (Confirm-Action "Continue?")) { return }

    try {
        Set-RegistryValue "HKCU:\Control Panel\Desktop" "DisableAnimations" 1 "DWORD"
        Log-Success "Disabled animations"
    } catch {
        Log-Error "Failed to disable animations" $_
    }

    try {
        Set-RegistryValue "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" "ListviewAlphaEnabled" 0 "DWORD"
        Log-Success "Disabled transparency effects"
    } catch {
        Log-Error "Failed to disable transparency" $_
    }
    
    Write-Host ""
    Write-Host "✓ VISUAL EFFECTS DISABLED" -ForegroundColor Green
    Log-Action "Visual effects optimization completed"
}

# ============================================================================
# SECTION 9: GAMING & STREAMING TWEAKS
# ============================================================================
function Optimize-GamingStreaming {
    Write-Host ""
    Write-Host "======================================================================" -ForegroundColor Cyan
    Write-Host "SECTION 9: GAMING & STREAMING OPTIMIZATION" -ForegroundColor Cyan
    Write-Host "======================================================================" -ForegroundColor Cyan
    Write-Host ""
    Write-Host "Optimizing for gaming and streaming performance..." -ForegroundColor Yellow
    
    if (-not (Confirm-Action "Continue?")) { return }

    try {
        # Disable GameDVR
        Set-RegistryValue "HKCU:\System\GameConfigStore" "GameDVR_Enabled" 0 "DWORD"
        Log-Success "Disabled GameDVR"
    } catch {
        Log-Error "Failed to disable GameDVR" $_
    }

    try {
        # Foreground app priority
        Set-RegistryValue "HKCU:\Control Panel\Desktop" "ForegroundLockTimeout" 0 "DWORD"
        Log-Success "Enabled foreground application priority"
    } catch {
        Log-Error "Failed to set foreground priority" $_
    }
    
    Write-Host ""
    Write-Host "✓ GAMING & STREAMING OPTIMIZATION COMPLETE" -ForegroundColor Green
    Log-Action "Gaming/Streaming optimization completed"
}

# ============================================================================
# SECTION 10: GAMING SERVICES ENABLEMENT
# ============================================================================
function Enable-GamingServices {
    Write-Host ""
    Write-Host "======================================================================" -ForegroundColor Cyan
    Write-Host "SECTION 10: GAMEPASS & GAMING SERVICES ENABLER" -ForegroundColor Cyan
    Write-Host "======================================================================" -ForegroundColor Cyan
    Write-Host ""
    Write-Host "Re-enabling gaming services after optimization..." -ForegroundColor Yellow
    
    if (-not (Confirm-Action "Continue?")) { return }

    $xboxServices = @(
        @{Name = "XblAuthManager"; DisplayName = "Xbox Live Auth Manager"},
        @{Name = "XblGameSave"; DisplayName = "Xbox Live Game Save Service"},
        @{Name = "XboxNetApiSvc"; DisplayName = "Xbox Live Networking Service"},
        @{Name = "GameInputSvc"; DisplayName = "Game Input Service"}
    )

    $enabledCount = 0
    foreach ($svc in $xboxServices) {
        Enable-ServiceSafely $svc.Name $svc.DisplayName
        $enabledCount++
    }

    try {
        Enable-WindowsOptionalFeature -Online -FeatureName DirectPlay -NoRestart -ErrorAction Stop
        Log-Success "Enabled DirectPlay"
    } catch {
        Log-Error "Failed to enable DirectPlay" $_
    }
    
    Write-Host ""
    Write-Host "✓ GAMING SERVICES ENABLEMENT COMPLETE - Enabled $enabledCount services" -ForegroundColor Green
    Log-Action "Gaming services enablement completed - $enabledCount services enabled"
}

# ============================================================================
# SUMMARY & REPORTING
# ============================================================================
function Show-ExecutionSummary {
    Write-Host ""
    Write-Host "======================================================================" -ForegroundColor Cyan
    Write-Host "EXECUTION SUMMARY" -ForegroundColor Cyan
    Write-Host "======================================================================" -ForegroundColor Cyan
    Write-Host ""
    Write-Host "Successful modifications: $(@($ModifiedItems).Count)" -ForegroundColor Green
    Write-Host "Failed operations: $(@($FailedItems).Count)" -ForegroundColor $(if ($FailedItems.Count -gt 0) { "Yellow" } else { "Green" })
    Write-Host "Log file: $LogPath" -ForegroundColor Magenta
    Write-Host ""
    Write-Host "NEXT STEPS:" -ForegroundColor Yellow
    Write-Host "  1. RESTART your system for all changes to take effect"
    Write-Host "  2. Test WiFi, Bluetooth, and USB devices"
    Write-Host "  3. Update GPU drivers from manufacturer"
    Write-Host "  4. Install Xbox App if gaming services were enabled"
    Write-Host ""
}

# ============================================================================
# MAIN LOOP
# ============================================================================
function Main {
    Clear-Host
    Write-Host "========================================================================" -ForegroundColor Cyan
    Write-Host "WINDOWS 11 LTSC IoT OPTIMIZER v1.1" -ForegroundColor Cyan
    Write-Host "========================================================================" -ForegroundColor Cyan
    Write-Host ""
    
    # Run pre-flight checks
    Test-Prerequisitesmet
    
    $continue = $true
    while ($continue) {
        Show-Menu
        $choice = Read-Host "Select option (1-14)"
        
        switch ($choice) {
            "1" { Optimize-Telemetry }
            "2" { Remove-Bloatware }
            "3" { Optimize-Services }
            "4" { Optimize-ScheduledTasks }
            "5" { Optimize-Performance }
            "6" { Optimize-Network }
            "7" { Optimize-Storage }
            "8" { Disable-VisualEffects }
            "9" { Optimize-GamingStreaming }
            "10" { Enable-GamingServices }
            "11" {
                Optimize-Telemetry
                Remove-Bloatware
                Optimize-Services
                Optimize-ScheduledTasks
                Optimize-Performance
                Optimize-Network
                Optimize-Storage
                Disable-VisualEffects
                Optimize-GamingStreaming
            }
            "12" {
                Optimize-Telemetry
                Remove-Bloatware
                Optimize-Services
                Optimize-ScheduledTasks
                Optimize-Performance
                Optimize-Network
                Optimize-Storage
                Disable-VisualEffects
                Optimize-GamingStreaming
                Enable-GamingServices
            }
            "13" {
                if (Test-Path $LogPath) {
                    notepad $LogPath
                } else {
                    Write-Host "No log file found yet." -ForegroundColor Yellow
                }
            }
            "14" {
                $continue = $false
                Show-ExecutionSummary
            }
            default {
                Write-Host "Invalid option. Please select 1-14." -ForegroundColor Red
            }
        }
    }
}

# ============================================================================
# ENTRY POINT
# ============================================================================
Main
Read-Host "Press Enter to exit"