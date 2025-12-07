# Security Policy

## 🔒 Safe by Design

This project is built with safety as a core principle:

### Security Features

✅ **Administrator Check** - Verifies admin privileges before execution
✅ **User Confirmation** - Y/N prompts for major operations
✅ **Service Protection** - Critical services (WiFi, Bluetooth, USB) always protected
✅ **Error Handling** - Graceful error management throughout execution
✅ **Logging** - All operations logged for review and auditing
✅ **Reversible Changes** - All modifications can be undone via System Restore

---

## What This Script Does

### ✅ Safe Operations

- Removes telemetry services (non-critical)
- Disables non-essential services (configurable)
- Optimizes network settings (performance-focused)
- Enables gaming services (user choice)
- Optimizes storage (temporary file cleanup)

### ❌ What This Script Does NOT Do

- Does NOT delete user files or documents
- Does NOT disable essential services (WiFi, Bluetooth, USB)
- Does NOT make breaking system changes
- Does NOT install any software without confirmation
- Does NOT require internet connection
- Does NOT install malware or trackers
- Does NOT modify security settings dangerously

---

## Critical Services Protected

These services are **NEVER disabled**:

```powershell
# Networking
- WlanSvc (WiFi)
- bthserv (Bluetooth)
- RasMan (Remote Access)

# Storage & USB
- usbhid (USB Human Interface Device)
- USBSTOR (USB Storage)

# Audio/Display
- AudioSrv (Windows Audio)
- DisplayDriver (Graphics)

# System Core
- Power Services
- Update Services
- Security Services
```

---

## 🛡️ How to Stay Safe

### Before Running

1. **Read the script** - View [W11_LTSC_Master.ps1](W11_LTSC_Master.ps1)
2. **Create restore point**:
   ```powershell
   Win+R > rstrui.exe > Create Restore Point
   ```
3. **Backup important data** (always good practice)
4. **Run on test system first** (if possible)

### During Execution

1. **Read each prompt** - Don't just hit "yes"
2. **Review options** - Understand what's being changed
3. **Watch for errors** - Console will show any issues
4. **Have patience** - Takes 5-10 minutes to complete

### After Execution

1. **Test critical functions** - WiFi, audio, USB
2. **Verify gaming** - If applicable for your use
3. **Check logs** - Review what changed
4. **Create new restore point** - After successful run

---

## 🔄 How to Undo Changes

### Option 1: System Restore (Easiest)

```powershell
Win+R > rstrui.exe

# Steps:
1. Click "Next"
2. Select restore point (created before running script)
3. Click "Next"
4. Confirm and wait
```

**Time**: 5-15 minutes, fully reversible

### Option 2: Manual Re-enable Services

```powershell
# Run as Administrator

# Re-enable specific services
Set-Service WlanSvc -StartupType Automatic
Start-Service WlanSvc

Set-Service bthserv -StartupType Automatic
Start-Service bthserv

# Verify they're running
Get-Service WlanSvc
Get-Service bthserv
```

### Option 3: Fresh Windows Install

If needed, Windows 11 LTSC can be reinstalled cleanly.

---

## 🐛 Reporting Security Issues

### Do NOT Open Public Issues

If you discover a security vulnerability:

1. **Do NOT** open a public GitHub issue
2. **Do NOT** discuss it publicly
3. **Do NOT** share in Discord/forums

### Proper Reporting

1. **Email** with details to: `security@example.com` (maintainer)
2. Include:
   - Description of vulnerability
   - Steps to reproduce
   - Potential impact
   - Suggested fix (if applicable)
3. Allow 24-48 hours for response

---

## ✅ Security Checklist

Before running this script, verify:

- [ ] You have Administrator privileges
- [ ] You have created a System Restore point
- [ ] You have read the [README.md](README.md)
- [ ] You understand what optimization level you're selecting
- [ ] You have backed up important data
- [ ] You are running Windows 11 LTSC IoT
- [ ] You are on a stable network connection
- [ ] PowerShell is version 5.1 or higher

---

## 📋 Supported Systems

**Tested and Supported**:
- ✅ Windows 11 LTSC IoT (Build 22000+)
- ✅ Clean install or updated systems
- ✅ Enterprise deployments
- ✅ Consumer systems

**Not Supported**:
- ❌ Windows 10
- ❌ Windows Server (except manual modifications)
- ❌ Home/Pro editions (use at own risk)

---

## 🔍 Transparency

### Code Visibility

- All source code is **publicly available**
- No obfuscation or hidden functionality
- Comments explain all major sections
- Anyone can audit the code

### What's Logged

- Script execution start/end times
- Each operation performed
- Services modified
- Files deleted
- Any errors encountered

### Privacy

- Script does NOT collect personal data
- Script does NOT transmit data
- Script does NOT require internet
- Script does NOT phone home

---

## 🤝 Trust & Verification

### Open Source Benefits

- Code can be audited by anyone
- Community can identify issues
- Transparent improvement process
- MIT License ensures freedom

### How to Verify

```powershell
# Check file signature (if signed)
Get-AuthenticodeSignature W11_LTSC_Master.ps1

# View script contents
Notepad W11_LTSC_Master.ps1

# Get file hash (verify integrity)
Get-FileHash W11_LTSC_Master.ps1 -Algorithm SHA256
```

---

## 📞 Security Contacts

For security concerns:

- **Email**: Report privately
- **GitHub**: Use GitHub Security Advisory (if applicable)
- **Discord**: Not for security issues

---

## 📜 License & Terms

This script is provided **AS-IS** under the MIT License:

- No warranty of any kind
- Use at your own risk
- Test in lab environment first
- Always maintain backups

---

## ✨ Version History

**v1.0** - Initial Release
- Core optimization features
- Gaming support
- Security features
- Comprehensive documentation

---

**Questions about security? Check our [FAQ](README.md#troubleshooting) or open a Discussion.**

*Last Updated: December 6, 2025*
