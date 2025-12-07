# Windows 11 LTSC Optimizer

**Professional optimization tool for Windows 11 LTSC and LTSC IoT systems**

Designed to safely optimize performance, enhance privacy, and enable gaming capabilities while protecting critical system components and maintaining full reversibility.

![Version](https://img.shields.io/badge/version-2.0-blue?style=flat-square)
![Status](https://img.shields.io/badge/status-stable-green?style=flat-square)
![License](https://img.shields.io/badge/license-MIT-blue?style=flat-square)
![Platform](https://img.shields.io/badge/platform-Windows%2011%20LTSC%2F%20LTSC%20IoT-blue?style=flat-square)

---

## Overview

The Windows 11 LTSC Optimizer is a professional-grade tool that transforms Windows 11 LTSC IoT into a lean, fast, and privacy-respecting operating system optimized for gaming, streaming, and everyday productivity.

**This is not a generic debloater.** Every change is carefully engineered with these principles:

- **Safety First**: Critical services (WiFi, Bluetooth, USB, security) are protected by explicit whitelists
- **Reversibility**: All changes are logged and can be reverted via System Restore
- **Transparency**: Users choose profiles and review changes before execution
- **Reliability**: Pre-flight health checks ensure system compatibility

### What This Tool Does

✅ Removes telemetry and diagnostic services
✅ Uninstalls non-essential Microsoft Store apps (bloatware)
✅ Disables resource-intensive scheduled tasks
✅ Optimizes network stack for low-latency gaming and streaming
✅ Applies smart performance tuning without sacrificing stability
✅ Enables Xbox Game Pass and gaming-related services
✅ Preserves WiFi, Bluetooth, USB, Windows Update, and audio
✅ Integrates with Windows System Restore for safe rollback

### What This Tool Does NOT Do

❌ Never disables critical networking or input services
❌ Never breaks Windows Update or security updates
❌ Never requires internet access
❌ Never silently reboots or makes hidden changes
❌ Never prevents use of Store apps or Microsoft services
❌ Never modifies user files or settings

---

## System Requirements

| Requirement | Details |
|-------------|----------|
| **OS** | Windows 11 LTSC or LTSC IoT (Build 22000+) |
| **Architecture** | x64 only |
| **RAM** | 4GB minimum (8GB+ recommended) |
| **Disk Space** | 5GB free space required |
| **Privileges** | Administrator rights (required) |
| **PowerShell** | 5.0 or higher |

### Tested Platforms

- ✓ ThinkPad (X1 Carbon, T14, E15, etc.)
- ✓ Surface devices
- ✓ Dell XPS / Inspiron / Latitude
- ✓ HP EliteBook / Pavilion
- ✓ ASUS VivoBook / ROG
- ✓ Custom-built systems

---

## Quick Start

### Option 1: Run the Professional Launcher (Recommended)

The launcher provides an interactive, guided experience with safety checks and profile selection.

```powershell
# 1. Open PowerShell as Administrator (right-click → Run as administrator)

# 2. Set execution policy (one-time setup)
Set-ExecutionPolicy Unrestricted -Scope CurrentUser -Force

# 3. Download and run the launcher
$url = "https://raw.githubusercontent.com/tedofgarlic/W11-LTSC-Optimizer/master/W11_LTSC_Optimizer_Launcher.ps1"
Invoke-WebRequest -Uri $url -OutFile W11_LTSC_Optimizer_Launcher.ps1
.\W11_LTSC_Optimizer_Launcher.ps1
```

### Option 2: Clone the Repository

```powershell
# Clone entire repository for offline use and inspection
git clone https://github.com/tedofgarlic/W11-LTSC-Optimizer
cd W11-LTSC-Optimizer

# Run the launcher
.\W11_LTSC_Optimizer_Launcher.ps1
```

---

## Usage Profiles

### 🟢 Laptop/Mobile (Default)

Optimized for ThinkPads and portable devices. Preserves power management, sleep behavior, and battery reporting.

**Recommended for:** Most users with laptops or tablets

**What it does:**
- Safe baseline optimizations
- Preserves power saving features
- Keeps battery management intact
- Optimized for mobile connectivity

### 🟦 Desktop/Stationary

Optimized for permanently connected systems. More aggressive power and performance tuning.

**Recommended for:** Gaming rigs, workstations, media servers

**What it does:**
- All of Laptop optimizations
- Disables sleep timeout on AC power
- Enables sustained high performance
- Optimized for 24/7 uptime scenarios

### 🟪 Custom/Advanced

Select individual optimization modules for granular control.

**Recommended for:** Power users and advanced administrators

**Modules available:**
- Telemetry removal
- Bloatware removal
- Service optimization
- Task scheduler cleanup
- Performance tuning
- Network optimization
- Storage cleanup
- Visual effects tuning
- Gaming optimization
- Gaming services enablement

---

## Optimization Levels

### 🟩 Safe Baseline (Default)

Conservative, well-tested optimizations suitable for all users.

**Applied changes:**
- Telemetry services disabled (DiagTrack, dmwappushservice, MapsBroker)
- Bloatware apps removed (News, Weather, Tips, Sticky Notes, etc.)
- Non-critical scheduled tasks disabled
- Network stack tuned for low latency
- High Performance power plan activated
- Basic animations disabled

**Impact:** Noticeable system responsiveness improvement, 5-10% free disk space

**Rollback difficulty:** Easy (via System Restore or manual service re-enablement)

### 🟦 Gaming & Performance Focused

All of Safe Baseline, plus aggressive performance tuning for gaming and streaming.

**Additional changes:**
- More aggressive visual effect removal
- Foreground application priority enabled (reduces input lag)
- GameDVR disabled
- Xbox services and Game Pass enabled
- DirectPlay enabled for legacy games

**Impact:** Noticeable FPS improvement in competitive games, lower input latency

**Rollback difficulty:** Easy (changes are additive, all services can be re-enabled)

### 🟧 Minimal/Extreme (Advanced Only)

All of Gaming level, plus experimental optimizations for absolute minimum footprint.

**Additional changes:**
- More bundled features removed
- Advanced power management tweaks
- Experimental network tuning
- Reduced driver overhead settings

**⚠️ Warning:** Only for advanced users. Some changes may affect stability or functionality. Full system knowledge recommended.

**Rollback difficulty:** Moderate (may require manual registry restoration)

---

## Safety Guarantees

### Protected Services (Always Whitelisted)

These services are **never** disabled, regardless of profile:

| Service | Purpose | Why Protected |
|---------|---------|---------------|
| **WlanSvc** | WiFi networking | Critical for laptop connectivity |
| **bthserv** | Bluetooth | Critical for peripherals on ThinkPad |
| **HidUsb** | USB input devices | Critical for keyboard and mouse |
| **WinDefend** | Windows Defender | Critical for security |
| **wuauserv** | Windows Update | Critical for patches and security |
| **BITS** | Background transfer | Used by updates and installations |
| **RpcSs** | Remote Procedure Call | System-critical infrastructure |
| **DcomLaunch** | COM+ services | System-critical infrastructure |
| **AudioSrv** | Audio engine | Critical for sound output |

### Pre-Flight Health Checks

Before any optimization runs, the tool verifies:

✅ Administrator privileges are active
✅ Windows 11 LTSC edition is detected
✅ At least 5GB disk space is available
✅ Critical services are responding
✅ System Restore is available
✅ Network connectivity (if applicable)

### Logging & Audit Trail

Every operation is recorded with:
- **Timestamp** of execution
- **Operation type** (service disable, app removal, registry change)
- **Status** (success, warning, failure)
- **Error details** if applicable

Log file location: `%APPDATA%\W11_LTSC_Optimizer_Logs\`

---

## Rollback & Recovery

### Automatic System Restore Point

Before optimization begins, the tool:
1. Checks if System Restore is enabled
2. Creates a named restore point: `W11_LTSC_Optimizer_Checkpoint_[timestamp]`
3. Documents the restore point name for easy recovery

### Manual Rollback (If Needed)

If something doesn't work as expected:

#### Using System Restore (Recommended)

```
1. Open Windows Settings
2. System → Recovery
3. Click "Open System Restore"
4. Select the checkpoint created by the optimizer
5. Click "Next" → "Finish"
6. System will revert to pre-optimization state
```

#### Manual Service Re-enablement

```powershell
# Re-enable specific disabled services
Set-Service -Name DiagTrack -StartupType Automatic
Start-Service -Name DiagTrack

Set-Service -Name dmwappushservice -StartupType Automatic
Start-Service -Name dmwappushservice
```

#### Reinstall Removed Apps

```powershell
# Removed apps can be reinstalled from Microsoft Store
# Search for app name and click "Get" to reinstall

# Or via PowerShell:
Get-AppxPackage -Name "Microsoft.BingWeather" -AllUsers | Add-AppxPackage
```

---

## Troubleshooting

### "WiFi not working after optimization"

**Solution:** Revert via System Restore or manually re-enable WlanSvc:
```powershell
Set-Service -Name WlanSvc -StartupType Automatic
Start-Service -Name WlanSvc
Restart-Computer
```

### "Bluetooth devices not connecting"

**Solution:** Re-enable Bluetooth service:
```powershell
Set-Service -Name bthserv -StartupType Automatic
Start-Service -Name bthserv
Restart-Computer
```

### "USB devices not recognized"

**Solution:** The tool protects HidUsb. Check Device Manager for driver issues or revert via System Restore.

### "System slow after optimization"

**Solution:** This is unlikely. If it occurs:
1. Use System Restore to revert changes
2. Run again with lower optimization level (Safe Baseline)
3. Report the issue on GitHub

### "Can't re-enable a service"

**Solution:** Some services require specific conditions. Use System Restore for full rollback.

---

## What Changes (In Detail)

### Telemetry & Diagnostics

**Services disabled:**
- DiagTrack (Diagnostic Tracking Service)
- dmwappushservice (Device Management)
- MapsBroker (Maps location service)

**Registry keys modified:**
- `HKLM:\Software\Policies\Microsoft\Windows\DataCollection`
- `HKCU:\Software\Microsoft\Windows\CurrentVersion\Diagnostics\DiagTrack`

### Bloatware Removed

Removes Microsoft Store apps that are purely consumer-oriented:
- News, Weather, Tips, Get Help
- Sticky Notes, Mail & Calendar
- Zune Music, Zune Video
- Skype
- Others (complete list available in code)

**Important:** Does NOT remove:
- Microsoft Store (app store itself)
- Settings, File Explorer, Photos
- Windows Terminal, Notepad
- Core system apps

### Scheduled Tasks Disabled

**Tasks removed:**
- Application Experience telemetry collection
- Customer Experience Improvement Program
- Disk Diagnostics data collection
- System Restore point cleaning

### Performance Optimizations

**Power plan:**
- Switches to "High Performance" plan
- Disables standby on AC power
- 10-minute monitor off timeout

**Visual effects:**
- Disables window animations
- Removes transparency effects (if desktop, not laptop)

**Foreground priority:**
- Foreground apps get CPU priority
- Reduces input lag in games

**Network tuning:**
- TCP NoDelay (Nagle algorithm disabled)
- Receive Side Scaling enabled
- TCP timestamps enabled

---

## Advanced Usage

### Command-Line Options (Future Release)

```powershell
# Run with specific profile
.\W11_LTSC_Optimizer_Launcher.ps1 -Profile laptop -Level safe

# Run without interactive prompts
.\W11_LTSC_Optimizer_Launcher.ps1 -AutoRun -NoConfirm

# Dry-run (show what would be changed)
.\W11_LTSC_Optimizer_Launcher.ps1 -DryRun
```

### Building a Custom Configuration

Edit `W11_LTSC_Optimizer_Launcher.ps1` and modify the `$ScriptConfig` hashtable to customize:
- Excluded services
- Removed apps
- Disabled tasks
- Registry modifications

---

## Contributing

Found an issue or want to improve the optimizer?

1. Test on your system and document results
2. Open an issue on GitHub with:
   - Your system (ThinkPad model, OS build, etc.)
   - What happened (expected vs actual)
   - Steps to reproduce
3. Submit a pull request with improvements

---

## License

MIT License - See LICENSE file for details

---

## Disclaimer

This tool modifies your operating system. While every precaution is taken to ensure safety:

- **Create a backup** of your system before running
- **Test in a VM** if you're unsure
- **Keep System Restore enabled**
- **Use at your own risk**

The author is not responsible for:
- Data loss
- System instability
- Hardware damage
- Service provider issues

However, all changes are fully reversible via System Restore.

---

## Version History

### v2.0 - Professional Edition (Current)
- ✨ Interactive GUI launcher with onboarding
- ✨ Profile-based configuration (Laptop/Desktop/Custom)
- ✨ Optimization level selection (Safe/Gaming/Minimal)
- ✨ System health checks and validation
- ✨ Enhanced safety messaging and documentation
- ✨ Improved completion summary and next steps
- 🐛 Better error handling across all modules

### v1.1 - Robustness Release
- 🔧 Production-grade error handling
- 🔧 Service whitelisting system
- 🔧 Comprehensive logging
- 🔧 Pre-flight validation

### v1.0 - Initial Release
- 🎉 10 optimization modules
- 🎉 Menu-driven interface
- 🎉 Per-module confirmation

---

## Support

**Issues or questions?**

- 📝 Check GitHub Issues
- 📧 Submit detailed bug reports
- 🔍 Review the log file in `%APPDATA%\W11_LTSC_Optimizer_Logs\`
- 📖 Read the full documentation

**GitHub:** https://github.com/tedofgarlic/W11-LTSC-Optimizer

---

**Made with ❤️ for Windows 11 LTSC optimization**