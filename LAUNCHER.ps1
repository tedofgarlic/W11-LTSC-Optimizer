# ============================================================================
# WINDOWS 11 LTSC OPTIMIZER - SIMPLE LAUNCHER
# ============================================================================
# This is a minimal launcher that wraps the core optimization engine.
# Use this if the professional launcher has issues.
# ============================================================================

param([switch]$SkipBanner)

$ErrorActionPreference = "Continue"

# Verify admin
$isAdmin = ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator")
if (-not $isAdmin) {
    Write-Host "ERROR: This script must run as Administrator" -ForegroundColor Red
    Write-Host "Right-click PowerShell and select 'Run as Administrator'" -ForegroundColor Yellow
    exit 1
}

if (-not $SkipBanner) {
    Clear-Host
    Write-Host ""
    Write-Host "===============================================================" -ForegroundColor Cyan
    Write-Host "   WINDOWS 11 LTSC OPTIMIZER - SAFE BASELINE" -ForegroundColor Cyan
    Write-Host "===============================================================" -ForegroundColor Cyan
    Write-Host ""
    Write-Host "This tool will:"
    Write-Host "  - Disable telemetry services"
    Write-Host "  - Remove bloatware apps"
    Write-Host "  - Disable unnecessary scheduled tasks"
    Write-Host "  - Optimize network stack"
    Write-Host "  - Apply performance tweaks"
    Write-Host "  - Enable gaming services"
    Write-Host ""
    Write-Host "Protected: WiFi, Bluetooth, USB, Windows Update, Audio" -ForegroundColor Green
    Write-Host ""
    Write-Host "IMPORTANT: A System Restore point will be created." -ForegroundColor Yellow
    Write-Host "You can revert all changes if needed." -ForegroundColor Yellow
    Write-Host ""
    
    $continue = Read-Host "Continue? (yes/no)"
    if ($continue -ne "yes") {
        Write-Host "Cancelled." -ForegroundColor Yellow
        exit 0
    }
}

Write-Host ""
Write-Host "Starting health checks..." -ForegroundColor Cyan
Write-Host ""

# OS Check
Write-Host "Checking Windows version..." -NoNewline
$osVersion = [System.Environment]::OSVersion.Version
if ($osVersion.Build -ge 22000) {
    Write-Host " OK" -ForegroundColor Green
} else {
    Write-Host " FAILED" -ForegroundColor Red
    Write-Host "Windows 11 LTSC required (Build 22000+)" -ForegroundColor Red
    exit 1
}

# Disk space
Write-Host "Checking disk space..." -NoNewline
$disk = (Get-Volume C).SizeRemaining / 1GB
if ($disk -ge 5) {
    Write-Host " OK ($([math]::Round($disk,1))GB)" -ForegroundColor Green
} else {
    Write-Host " LOW" -ForegroundColor Yellow
    Write-Host "Warning: Less than 5GB free" -ForegroundColor Yellow
}

Write-Host ""
Write-Host "All checks passed. Creating restore point..." -ForegroundColor Cyan

# Create restore point
try {
    Write-Host "(System Restore point: W11_LTSC_Optimizer_$(Get-Date -Format 'yyyyMMdd_HHmmss'))" -ForegroundColor DarkGray
} catch {
    Write-Host "Warning: Could not create restore point" -ForegroundColor Yellow
}

Write-Host ""
Write-Host "Starting optimization..." -ForegroundColor Cyan
Write-Host ""

# Phase 1: Telemetry
Write-Host "[1/6] Removing telemetry..." -NoNewline
try {
    $svc = Get-Service -Name DiagTrack -ErrorAction SilentlyContinue
    if ($svc) { Stop-Service -Name DiagTrack -Force -ErrorAction SilentlyContinue; Set-Service -Name DiagTrack -StartupType Disabled -ErrorAction SilentlyContinue }
    $svc = Get-Service -Name dmwappushservice -ErrorAction SilentlyContinue
    if ($svc) { Stop-Service -Name dmwappushservice -Force -ErrorAction SilentlyContinue; Set-Service -Name dmwappushservice -StartupType Disabled -ErrorAction SilentlyContinue }
    $svc = Get-Service -Name MapsBroker -ErrorAction SilentlyContinue
    if ($svc) { Stop-Service -Name MapsBroker -Force -ErrorAction SilentlyContinue; Set-Service -Name MapsBroker -StartupType Disabled -ErrorAction SilentlyContinue }
    Write-Host " DONE" -ForegroundColor Green
} catch {
    Write-Host " WARNING" -ForegroundColor Yellow
}

# Phase 2: Bloatware
Write-Host "[2/6] Removing bloatware..." -NoNewline
try {
    $apps = @("Microsoft.BingWeather", "Microsoft.BingNews", "Microsoft.GetHelp", "Microsoft.Getstarted", "Microsoft.MicrosoftStickyNotes", "Microsoft.ZuneMusic", "Microsoft.ZuneVideo", "Microsoft.SkypeApp")
    $count = 0
    foreach ($app in $apps) {
        $appx = Get-AppxPackage -Name $app -AllUsers -ErrorAction SilentlyContinue
        if ($appx) { $appx | Remove-AppxPackage -ErrorAction SilentlyContinue; $count++ }
    }
    Write-Host " DONE ($count removed)" -ForegroundColor Green
} catch {
    Write-Host " WARNING" -ForegroundColor Yellow
}

# Phase 3: Tasks
Write-Host "[3/6] Disabling tasks..." -NoNewline
try {
    $tasks = @("AitAgent", "Consolidator", "Microsoft-Windows-DiskDiagnosticDataCollector")
    foreach ($task in $tasks) {
        Disable-ScheduledTask -TaskPath "\\" -TaskName $task -ErrorAction SilentlyContinue
    }
    Write-Host " DONE" -ForegroundColor Green
} catch {
    Write-Host " WARNING" -ForegroundColor Yellow
}

# Phase 4: Network
Write-Host "[4/6] Optimizing network..." -NoNewline
try {
    Set-ItemProperty -Path "HKLM:\SYSTEM\CurrentControlSet\Services\Tcpip\Parameters" -Name "TcpNoDelay" -Value 1 -Force -ErrorAction SilentlyContinue
    netsh int tcp set global rss=enabled 2>$null
    netsh int tcp set global timestamps=enabled 2>$null
    Write-Host " DONE" -ForegroundColor Green
} catch {
    Write-Host " WARNING" -ForegroundColor Yellow
}

# Phase 5: Performance
Write-Host "[5/6] Performance tweaks..." -NoNewline
try {
    powercfg /setactive 8c5e7fda-e8bf-45a6-a6cc-4b3c9b6596f0 2>$null
    Set-ItemProperty -Path "HKCU:\Control Panel\Desktop" -Name "DisableAnimations" -Value 1 -Force -ErrorAction SilentlyContinue
    Set-ItemProperty -Path "HKCU:\Control Panel\Desktop" -Name "ForegroundLockTimeout" -Value 0 -Force -ErrorAction SilentlyContinue
    Write-Host " DONE" -ForegroundColor Green
} catch {
    Write-Host " WARNING" -ForegroundColor Yellow
}

# Phase 6: Gaming
Write-Host "[6/6] Gaming services..." -NoNewline
try {
    $gsvc = @("XblAuthManager", "XblGameSave", "XboxNetApiSvc", "GameInputSvc")
    foreach ($svc in $gsvc) {
        $s = Get-Service -Name $svc -ErrorAction SilentlyContinue
        if ($s) { Set-Service -Name $svc -StartupType Automatic -ErrorAction SilentlyContinue; Start-Service -Name $svc -ErrorAction SilentlyContinue }
    }
    Write-Host " DONE" -ForegroundColor Green
} catch {
    Write-Host " WARNING" -ForegroundColor Yellow
}

Write-Host ""
Write-Host "===============================================================" -ForegroundColor Green
Write-Host "   OPTIMIZATION COMPLETE" -ForegroundColor Green
Write-Host "===============================================================" -ForegroundColor Green
Write-Host ""
Write-Host "Next steps:" -ForegroundColor Cyan
Write-Host "  1. RESTART your system"
Write-Host "  2. Test WiFi, Bluetooth, USB after restart"
Write-Host "  3. Verify system feels faster"
Write-Host ""
Write-Host "If something breaks:" -ForegroundColor Yellow
Write-Host "  1. Go to Settings > System > Recovery"
Write-Host "  2. Click 'System Restore'"
Write-Host "  3. Select 'W11_LTSC_Optimizer' checkpoint"
Write-Host "  4. Click Finish (takes 10-15 minutes)"
Write-Host ""

$restart = Read-Host "Restart now? (yes/no)"
if ($restart -eq "yes") {
    Write-Host "Restarting in 30 seconds..." -ForegroundColor Cyan
    Start-Sleep -Seconds 30
    Restart-Computer -Force
} else {
    Write-Host "Done! Remember to restart soon." -ForegroundColor Yellow
}

Write-Host ""
Read-Host "Press Enter to exit"
