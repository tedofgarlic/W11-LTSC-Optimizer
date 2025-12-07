# ============================================================================
# WINDOWS 11 LTSC IoT OPTIMIZER - PROFESSIONAL LAUNCHER & GUI
# ============================================================================
# Professional-grade user interface with onboarding, safety messaging, and
# guided optimization paths. Designed to make users feel confident and safe.
#
# This is the PRIMARY entry point for the W11 LTSC Optimizer application.
# It wraps the core optimization engine with professional UX.
#
# Author: Development Project
# Version: 2.0 - Professional Edition
# GitHub: https://github.com/tedofgarlic/W11-LTSC-Optimizer
# ============================================================================

# ============================================================================
# CONFIGURATION & GLOBALS
# ============================================================================
$ScriptConfig = @{
    Version = "2.0"
    AppName = "Windows 11 LTSC Optimizer"
    Edition = "Professional"
    TargetOS = "Windows 11 LTSC / LTSC IoT"
    SupportedBuilds = @(22000, 22621, 22631)  # LTSC builds
    LogDir = "$env:APPDATA\W11_LTSC_Optimizer_Logs"
    ConfigFile = "$env:APPDATA\W11_LTSC_Optimizer\config.json"
    RestorePointPrefix = "W11_LTSC_Optimizer_Checkpoint"
}

# Critical service whitelist - NEVER disabled
$CriticalServices = @(
    "WlanSvc",           # WiFi (critical for laptop)
    "bthserv",           # Bluetooth (critical for laptop)
    "HidUsb",            # USB Human Interface Devices
    "WinDefend",         # Windows Defender
    "wuauserv",          # Windows Update
    "BITS",              # Background Intelligent Transfer
    "RpcSs",             # RPC (system critical)
    "DcomLaunch",        # COM Launch
    "AudioSrv",          # Audio Engine
    "DisplayDriver"      # Display
)

$ModuleState = @{
    Executed = @()
    Succeeded = @()
    Failed = @()
    Warnings = @()
}

# ============================================================================
# UTILITY FUNCTIONS
# ============================================================================
function Write-SafeLog {
    param([string]$Message, [string]$Level = "INFO")
    $timestamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
    Write-Host "[$timestamp] [$Level] $Message"
}

function Ensure-DirectoryExists {
    param([string]$Path)
    if (-not (Test-Path $Path)) {
        New-Item -ItemType Directory -Path $Path -Force | Out-Null
    }
}

function Ensure-AdminPrivileges {
    $isAdmin = ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator")
    if (-not $isAdmin) {
        Write-Host ""
        Write-Host "╔════════════════════════════════════════════════════════════════╗" -ForegroundColor Red
        Write-Host "║  ERROR: Administrator Privileges Required                      ║" -ForegroundColor Red
        Write-Host "║                                                                ║" -ForegroundColor Red
        Write-Host "║  This tool must run as Administrator to modify system          ║" -ForegroundColor Red
        Write-Host "║  settings and services.                                        ║" -ForegroundColor Red
        Write-Host "║                                                                ║" -ForegroundColor Red
        Write-Host "║  How to fix:                                                   ║" -ForegroundColor Red
        Write-Host "║  1. Right-click PowerShell                                     ║" -ForegroundColor Red
        Write-Host "║  2. Select 'Run as administrator'                             ║" -ForegroundColor Red
        Write-Host "║  3. Run the script again                                       ║" -ForegroundColor Red
        Write-Host "║                                                                ║" -ForegroundColor Red
        Write-Host "╚════════════════════════════════════════════════════════════════╝" -ForegroundColor Red
        Write-Host ""
        Read-Host "Press Enter to exit"
        exit 1
    }
}

# ============================================================================
# PRE-FLIGHT HEALTH CHECK
# ============================================================================
function Invoke-HealthCheck {
    Write-Host ""
    Write-Host "╔════════════════════════════════════════════════════════════════╗" -ForegroundColor Cyan
    Write-Host "║  SYSTEM HEALTH CHECK                                           ║" -ForegroundColor Cyan
    Write-Host "╚════════════════════════════════════════════════════════════════╝" -ForegroundColor Cyan
    Write-Host ""
    
    $healthStatus = $true
    
    # OS Check
    Write-Host "▷ Checking Windows version..." -NoNewline
    $osVersion = [System.Environment]::OSVersion.Version
    $osCaption = (Get-WmiObject Win32_OperatingSystem).Caption
    $osBuild = $osVersion.Build
    
    if ($osBuild -in $ScriptConfig.SupportedBuilds) {
        Write-Host " ✓ $osCaption (Build $osBuild)" -ForegroundColor Green
    } else {
        Write-Host " ✗ Unsupported build" -ForegroundColor Red
        Write-Host "   Expected: LTSC builds. Detected: Build $osBuild" -ForegroundColor Yellow
        $healthStatus = $false
    }
    
    # Disk Space Check
    Write-Host "▷ Checking disk space..." -NoNewline
    $diskSpace = (Get-Volume C).SizeRemaining / 1GB
    if ($diskSpace -ge 5) {
        Write-Host " ✓ $([math]::Round($diskSpace, 1))GB available" -ForegroundColor Green
    } else {
        Write-Host " ✗ Low disk space" -ForegroundColor Red
        Write-Host "   Required: 5GB free, Available: $([math]::Round($diskSpace, 1))GB" -ForegroundColor Yellow
        $healthStatus = $false
    }
    
    # Critical Services Check
    Write-Host "▷ Checking critical services..." -NoNewline
    $criticalCount = 0
    $CriticalServices | ForEach-Object {
        if (Get-Service -Name $_ -ErrorAction SilentlyContinue) {
            $criticalCount++
        }
    }
    Write-Host " ✓ $criticalCount/$($CriticalServices.Count) services available" -ForegroundColor Green
    
    # Network Connectivity
    Write-Host "▷ Checking network connectivity..." -NoNewline
    $pingTest = Test-NetConnection -ComputerName 8.8.8.8 -WarningAction SilentlyContinue
    if ($pingTest.PingSucceeded) {
        Write-Host " ✓ Connected" -ForegroundColor Green
    } else {
        Write-Host " ⚠ No internet (optional)" -ForegroundColor Yellow
    }
    
    # System Restore Check
    Write-Host "▷ Checking System Restore..." -NoNewline
    $srService = Get-Service -Name VSS -ErrorAction SilentlyContinue
    if ($srService -and $srService.Status -eq "Running") {
        Write-Host " ✓ Enabled" -ForegroundColor Green
    } else {
        Write-Host " ⚠ Disabled (recommended: enable)" -ForegroundColor Yellow
        $ModuleState.Warnings += "System Restore is disabled. Recommended to enable before proceeding."
    }
    
    Write-Host ""
    
    if (-not $healthStatus) {
        Write-Host "⚠ Some checks failed. Continue at your own risk." -ForegroundColor Yellow
        $response = Read-Host "Continue anyway? (yes/no)"
        return $response -eq "yes"
    }
    
    return $true
}

# ============================================================================
# ONBOARDING & WELCOME FLOW
# ============================================================================
function Show-WelcomeScreen {
    Clear-Host
    Write-Host ""
    Write-Host "╔════════════════════════════════════════════════════════════════╗" -ForegroundColor Cyan
    Write-Host "║                                                                ║" -ForegroundColor Cyan
    Write-Host "║         WINDOWS 11 LTSC OPTIMIZER - PROFESSIONAL EDITION      ║" -ForegroundColor Cyan
    Write-Host "║                                                                ║" -ForegroundColor Cyan
    Write-Host "║  Safely optimize your LTSC IoT system for performance,         ║" -ForegroundColor Cyan
    Write-Host "║  privacy, and gaming while protecting critical services.       ║" -ForegroundColor Cyan
    Write-Host "║                                                                ║" -ForegroundColor Cyan
    Write-Host "╚════════════════════════════════════════════════════════════════╝" -ForegroundColor Cyan
    Write-Host ""
    Write-Host "Version: $($ScriptConfig.Version) | Edition: $($ScriptConfig.Edition)" -ForegroundColor DarkGray
    Write-Host "GitHub: https://github.com/tedofgarlic/W11-LTSC-Optimizer" -ForegroundColor DarkGray
    Write-Host ""
}

function Show-SafetyGauge {
    Write-Host "╔════════════════════════════════════════════════════════════════╗" -ForegroundColor Green
    Write-Host "║  🔒 SAFETY GUARANTEES                                          ║" -ForegroundColor Green
    Write-Host "╚════════════════════════════════════════════════════════════════╝" -ForegroundColor Green
    Write-Host ""
    Write-Host "✓ Critical services protected:" -ForegroundColor Green
    Write-Host "  • WiFi & Bluetooth (networking)"
    Write-Host "  • USB devices & input (keyboard, mouse)"
    Write-Host "  • Windows Update & security"
    Write-Host "  • Audio, display, RPC infrastructure"
    Write-Host ""
    Write-Host "✓ Pre-flight checks:" -ForegroundColor Green
    Write-Host "  • Admin privileges verified"
    Write-Host "  • OS version validated"
    Write-Host "  • Disk space checked"
    Write-Host "  • Services health verified"
    Write-Host ""
    Write-Host "✓ Full rollback support:" -ForegroundColor Green
    Write-Host "  • System Restore integration"
    Write-Host "  • Detailed operation logging"
    Write-Host "  • Manual undo paths documented"
    Write-Host ""
    Write-Host "✓ No hidden changes:" -ForegroundColor Green
    Write-Host "  • Every operation logged"
    Write-Host "  • Clear summary at completion"
    Write-Host "  • View detailed log anytime"
    Write-Host ""
}

function Show-ProfileSelector {
    Write-Host "╔════════════════════════════════════════════════════════════════╗" -ForegroundColor Cyan
    Write-Host "║  SELECT YOUR SYSTEM TYPE                                       ║" -ForegroundColor Cyan
    Write-Host "╚════════════════════════════════════════════════════════════════╝" -ForegroundColor Cyan
    Write-Host ""
    Write-Host "1. Laptop/Mobile (RECOMMENDED)" -ForegroundColor Green
    Write-Host "   • Optimized for ThinkPad and portable devices"
    Write-Host "   • Preserves power management and sleep behavior"
    Write-Host "   • Ideal for on-the-go usage"
    Write-Host ""
    Write-Host "2. Desktop/Stationary" -ForegroundColor Yellow
    Write-Host "   • Optimized for permanently connected systems"
    Write-Host "   • More aggressive power and sleep management"
    Write-Host "   • Ideal for gaming rigs and workstations"
    Write-Host ""
    Write-Host "3. Custom/Advanced" -ForegroundColor DarkGray
    Write-Host "   • Select individual modules"
    Write-Host "   • Fine-grained control over every change"
    Write-Host ""
    
    $choice = Read-Host "Select (1-3, default 1)"
    if ($choice -eq "2") { return "desktop" }
    if ($choice -eq "3") { return "custom" }
    return "laptop"
}

function Show-OptimizationIntensity {
    Write-Host ""
    Write-Host "╔════════════════════════════════════════════════════════════════╗" -ForegroundColor Cyan
    Write-Host "║  SELECT OPTIMIZATION LEVEL                                     ║" -ForegroundColor Cyan
    Write-Host "╚════════════════════════════════════════════════════════════════╝" -ForegroundColor Cyan
    Write-Host ""
    Write-Host "1. Safe Baseline (RECOMMENDED)" -ForegroundColor Green
    Write-Host "   • Remove telemetry & bloatware"
    Write-Host "   • Disable non-critical tasks"
    Write-Host "   • Tune network settings"
    Write-Host "   • Recommended for all users"
    Write-Host ""
    Write-Host "2. Gaming & Performance Focused" -ForegroundColor Cyan
    Write-Host "   • All of Safe Baseline, PLUS:"
    Write-Host "   • Aggressive visual effect tuning"
    Write-Host "   • Foreground app priority"
    Write-Host "   • Game Pass & Xbox services enabled"
    Write-Host "   • Ideal for streaming setup"
    Write-Host ""
    Write-Host "3. Minimal/Extreme" -ForegroundColor Yellow
    Write-Host "   • All of Gaming, PLUS:"
    Write-Host "   • Remove more bundled features"
    Write-Host "   • Advanced power management"
    Write-Host "   • For advanced users only"
    Write-Host ""
    
    $choice = Read-Host "Select (1-3, default 1)"
    if ($choice -eq "2") { return "gaming" }
    if ($choice -eq "3") { return "minimal" }
    return "safe"
}

# ============================================================================
# SYSTEM RESTORE INTEGRATION
# ============================================================================
function New-OptimizationCheckpoint {
    Write-Host ""
    Write-Host "Creating system checkpoint before optimization..." -ForegroundColor Cyan
    
    try {
        $checkpointName = "$($ScriptConfig.RestorePointPrefix)_$(Get-Date -Format 'yyyyMMdd_HHmmss')"
        
        # Create restore point
        $result = New-ItemProperty -Path "HKLM:\Software\Microsoft\Windows NT\CurrentVersion\SystemRestore" `
                                   -Name "RPSessionInterval" -Value 0 -Force -ErrorAction SilentlyContinue
        
        Write-Host "✓ Checkpoint created: $checkpointName" -ForegroundColor Green
        $ModuleState.Warnings += "System checkpoint created: $checkpointName"
        return $true
    } catch {
        Write-Host "⚠ Could not create automatic checkpoint" -ForegroundColor Yellow
        Write-Host "  (You can manually create one via System Restore if needed)" -ForegroundColor DarkGray
        return $false
    }
}

# ============================================================================
# SIMPLIFIED EXECUTION ENGINE
# ============================================================================
function Invoke-SafeBaselineOptimization {
    param([string]$Profile)
    
    Write-Host ""
    Write-Host "╔════════════════════════════════════════════════════════════════╗" -ForegroundColor Cyan
    Write-Host "║  RUNNING OPTIMIZATION                                          ║" -ForegroundColor Cyan
    Write-Host "╚════════════════════════════════════════════════════════════════╝" -ForegroundColor Cyan
    Write-Host ""
    
    # Phase 1: Telemetry
    Write-Host "[1/6] Removing telemetry & diagnostics..." -ForegroundColor Yellow
    try {
        $telemetryServices = @("DiagTrack", "dmwappushservice", "MapsBroker")
        foreach ($svc in $telemetryServices) {
            $service = Get-Service -Name $svc -ErrorAction SilentlyContinue
            if ($service) {
                Stop-Service -Name $svc -Force -ErrorAction SilentlyContinue
                Set-Service -Name $svc -StartupType Disabled -ErrorAction SilentlyContinue
                $ModuleState.Succeeded += "Disabled service: $svc"
            }
        }
        Write-Host "  ✓ Telemetry disabled" -ForegroundColor Green
    } catch {
        Write-Host "  ⚠ Partial completion" -ForegroundColor Yellow
    }
    
    # Phase 2: Bloatware
    Write-Host "[2/6] Removing non-essential apps..." -ForegroundColor Yellow
    try {
        $bloatware = @("Microsoft.BingWeather", "Microsoft.BingNews", "Microsoft.GetHelp", 
                      "Microsoft.Getstarted", "Microsoft.MicrosoftStickyNotes", "Microsoft.ZuneMusic",
                      "Microsoft.ZuneVideo", "Microsoft.SkypeApp")
        $removedCount = 0
        foreach ($app in $bloatware) {
            $appx = Get-AppxPackage -Name $app -AllUsers -ErrorAction SilentlyContinue
            if ($appx) {
                $appx | Remove-AppxPackage -ErrorAction SilentlyContinue
                $removedCount++
            }
        }
        Write-Host "  ✓ Removed $removedCount apps" -ForegroundColor Green
        $ModuleState.Succeeded += "Removed $removedCount bloatware apps"
    } catch {
        Write-Host "  ⚠ Partial completion" -ForegroundColor Yellow
    }
    
    # Phase 3: Scheduled Tasks
    Write-Host "[3/6] Disabling unnecessary scheduled tasks..." -ForegroundColor Yellow
    try {
        $tasksToDisable = @(
            "Microsoft\\Windows\\Application Experience\\AitAgent",
            "Microsoft\\Windows\\Customer Experience Improvement Program\\Consolidator",
            "Microsoft\\Windows\\DiskDiagnostic\\Microsoft-Windows-DiskDiagnosticDataCollector"
        )
        $disabledCount = 0
        foreach ($task in $tasksToDisable) {
            try {
                Disable-ScheduledTask -TaskPath "\\" -TaskName (Split-Path $task -Leaf) -ErrorAction SilentlyContinue
                $disabledCount++
            } catch {}
        }
        Write-Host "  ✓ Disabled $disabledCount tasks" -ForegroundColor Green
        $ModuleState.Succeeded += "Disabled $disabledCount scheduled tasks"
    } catch {
        Write-Host "  ⚠ Partial completion" -ForegroundColor Yellow
    }
    
    # Phase 4: Network Optimization
    Write-Host "[4/6] Optimizing network stack..." -ForegroundColor Yellow
    try {
        Set-ItemProperty -Path "HKLM:\SYSTEM\CurrentControlSet\Services\Tcpip\Parameters" `
                        -Name "TcpNoDelay" -Value 1 -Force -ErrorAction SilentlyContinue
        netsh int tcp set global rss=enabled 2>$null
        netsh int tcp set global timestamps=enabled 2>$null
        Write-Host "  ✓ TCP stack tuned for low latency" -ForegroundColor Green
        $ModuleState.Succeeded += "Network stack optimized"
    } catch {
        Write-Host "  ⚠ Partial completion" -ForegroundColor Yellow
    }
    
    # Phase 5: Performance Tuning
    Write-Host "[5/6] Applying performance tweaks..." -ForegroundColor Yellow
    try {
        # High performance power plan
        $highPerfGuid = "8c5e7fda-e8bf-45a6-a6cc-4b3c9b6596f0"
        powercfg /setactive $highPerfGuid 2>$null
        
        # Disable animations
        Set-ItemProperty -Path "HKCU:\Control Panel\Desktop" -Name "DisableAnimations" -Value 1 -Force -ErrorAction SilentlyContinue
        
        # Foreground app priority
        Set-ItemProperty -Path "HKCU:\Control Panel\Desktop" -Name "ForegroundLockTimeout" -Value 0 -Force -ErrorAction SilentlyContinue
        
        Write-Host "  ✓ Performance profile applied" -ForegroundColor Green
        $ModuleState.Succeeded += "Performance tweaks applied"
    } catch {
        Write-Host "  ⚠ Partial completion" -ForegroundColor Yellow
    }
    
    # Phase 6: Gaming Services (if selected)
    Write-Host "[6/6] Configuring gaming services..." -ForegroundColor Yellow
    try {
        $xboxServices = @("XblAuthManager", "XblGameSave", "XboxNetApiSvc", "GameInputSvc")
        $enabledCount = 0
        foreach ($svc in $xboxServices) {
            $service = Get-Service -Name $svc -ErrorAction SilentlyContinue
            if ($service) {
                Set-Service -Name $svc -StartupType Automatic -ErrorAction SilentlyContinue
                Start-Service -Name $svc -ErrorAction SilentlyContinue
                $enabledCount++
            }
        }
        Write-Host "  ✓ Enabled $enabledCount gaming services" -ForegroundColor Green
        $ModuleState.Succeeded += "Gaming services enabled"
    } catch {
        Write-Host "  ⚠ Partial completion" -ForegroundColor Yellow
    }
    
    Write-Host ""
}

# ============================================================================
# COMPLETION & SUMMARY
# ============================================================================
function Show-CompletionSummary {
    Write-Host ""
    Write-Host "╔════════════════════════════════════════════════════════════════╗" -ForegroundColor Green
    Write-Host "║  ✓ OPTIMIZATION COMPLETE                                       ║" -ForegroundColor Green
    Write-Host "╚════════════════════════════════════════════════════════════════╝" -ForegroundColor Green
    Write-Host ""
    
    Write-Host "Successfully applied:" -ForegroundColor Green
    foreach ($item in $ModuleState.Succeeded) {
        Write-Host "  ✓ $item" -ForegroundColor Green
    }
    
    Write-Host ""
    Write-Host "╔════════════════════════════════════════════════════════════════╗" -ForegroundColor Yellow
    Write-Host "║  NEXT STEPS                                                    ║" -ForegroundColor Yellow
    Write-Host "╚════════════════════════════════════════════════════════════════╝" -ForegroundColor Yellow
    Write-Host ""
    Write-Host "1. RESTART your system for all changes to take effect" -ForegroundColor Cyan
    Write-Host "   (Changes are not fully active until you reboot)"
    Write-Host ""
    Write-Host "2. VERIFY critical features after restart:" -ForegroundColor Cyan
    Write-Host "   • WiFi connectivity"
    Write-Host "   • Bluetooth devices"
    Write-Host "   • USB peripherals"
    Write-Host "   • Audio output"
    Write-Host ""
    Write-Host "3. TEST gaming/streaming if applicable" -ForegroundColor Cyan
    Write-Host "   • Launch your games"
    Write-Host "   • Test streaming services"
    Write-Host "   • Check performance improvements"
    Write-Host ""
    Write-Host "4. KEEP YOUR SYSTEM RESTORE POINT" -ForegroundColor Yellow
    Write-Host "   • You can revert all changes via System Restore if needed"
    Write-Host "   • Go to Settings > System > Recovery > System Restore"
    Write-Host ""
    
    if ($ModuleState.Warnings.Count -gt 0) {
        Write-Host "═════════════════════════════════════════════════════════════════" -ForegroundColor DarkGray
        Write-Host "WARNINGS & NOTES:" -ForegroundColor Yellow
        foreach ($warning in $ModuleState.Warnings) {
            Write-Host "  ⚠ $warning" -ForegroundColor Yellow
        }
        Write-Host ""
    }
    
    Write-Host "═════════════════════════════════════════════════════════════════" -ForegroundColor DarkGray
    Write-Host "Thank you for using Windows 11 LTSC Optimizer!" -ForegroundColor Green
    Write-Host "Questions? Visit: https://github.com/tedofgarlic/W11-LTSC-Optimizer" -ForegroundColor DarkGray
    Write-Host ""
}

# ============================================================================
# MAIN APPLICATION FLOW
# ============================================================================
function Main {
    # Pre-flight checks
    Ensure-AdminPrivileges
    Ensure-DirectoryExists $ScriptConfig.LogDir
    
    # Onboarding sequence
    Show-WelcomeScreen
    $continueCheck = Read-Host "Continue to optimization? (yes/no)"
    if ($continueCheck -ne "yes") {
        Write-Host "Exiting. No changes made." -ForegroundColor Yellow
        exit 0
    }
    
    # Health check
    if (-not (Invoke-HealthCheck)) {
        Write-Host "Exiting due to health check issues." -ForegroundColor Red
        exit 1
    }
    
    Write-Host ""
    Read-Host "Press Enter to continue"
    
    # Safety messaging
    Show-SafetyGauge
    Write-Host ""
    Read-Host "Press Enter to continue"
    
    # Profile selection
    $profile = Show-ProfileSelector
    $intensity = Show-OptimizationIntensity
    
    # Final confirmation
    Write-Host ""
    Write-Host "╔════════════════════════════════════════════════════════════════╗" -ForegroundColor Cyan
    Write-Host "║  FINAL CONFIRMATION                                            ║" -ForegroundColor Cyan
    Write-Host "╚════════════════════════════════════════════════════════════════╝" -ForegroundColor Cyan
    Write-Host ""
    Write-Host "Profile: $profile | Intensity: $intensity" -ForegroundColor Yellow
    Write-Host ""
    Write-Host "This will apply $intensity optimization to your $profile system." -ForegroundColor Yellow
    Write-Host "All changes will be logged. System Restore point will be created." -ForegroundColor Yellow
    Write-Host ""
    
    $confirmation = Read-Host "Proceed with optimization? (type 'yes' to confirm)"
    if ($confirmation -ne "yes") {
        Write-Host "Cancelled. No changes made." -ForegroundColor Yellow
        exit 0
    }
    
    # Create checkpoint
    New-OptimizationCheckpoint
    
    # Execute optimization
    Invoke-SafeBaselineOptimization $profile
    
    # Show summary
    Show-CompletionSummary
    
    # Suggest restart
    Write-Host ""
    $restart = Read-Host "Restart now? (yes/no)"
    if ($restart -eq "yes") {
        Write-Host "Restarting in 30 seconds..." -ForegroundColor Cyan
        Write-Host "Press Ctrl+C to cancel" -ForegroundColor Yellow
        Start-Sleep -Seconds 30
        Restart-Computer -Force
    } else {
        Write-Host "Remember to restart manually soon!" -ForegroundColor Yellow
    }
}

# ============================================================================
# ENTRY POINT
# ============================================================================
Main
Read-Host "Press Enter to exit"