# Quick Start Guide

## Your First Run: The Complete Experience

This guide walks you through running the Windows 11 LTSC Optimizer for the first time. Don't worry—it's designed to be safe and intuitive.

---

## Step 0: Before You Start (5 minutes)

### ✅ Create a System Backup

While the tool is safe, having a backup is smart:

```
1. Press Windows key + I to open Settings
2. Go to System → Recovery
3. Click "Create a restore point"
4. Click "Create" and name it "Before W11 Optimizer"
5. Wait for completion
```

### ✅ Test Your WiFi & Bluetooth

Quickly verify these are working:
- Open WiFi settings and confirm connected
- Check Bluetooth (if you have devices)
- Test that a USB device is recognized

**Why?** So you can tell if optimization affected anything.

### ✅ Close Other Programs

The tool modifies system services, so:
- Close your web browser
- Shut down any games or streaming apps
- Close Microsoft Store if open
- Don't run multiple optimizers simultaneously

---

## Step 1: Open PowerShell as Administrator (2 minutes)

### Method 1: Quick Menu (Easiest)

```
1. Press Windows key + X
2. Select "Windows PowerShell (Admin)" or "Terminal (Admin)"
3. Click "Yes" if prompted
```

### Method 2: Search

```
1. Click the Windows search icon
2. Type "PowerShell"
3. Right-click on "Windows PowerShell"
4. Select "Run as administrator"
5. Click "Yes" if prompted
```

### Method 3: Classic

```
1. Press Ctrl + Shift + Esc to open Task Manager
2. Click "File" → "Run new task"
3. Type: powershell
4. Check "Create this task with administrative privileges"
5. Click OK
```

**Expected:** You should see a blue or dark window with your username listed.

---

## Step 2: Enable Script Execution (1 minute)

PowerShell requires permission to run scripts. Copy and paste this command:

```powershell
Set-ExecutionPolicy Unrestricted -Scope CurrentUser -Force
```

**Expected:** The command completes silently (no error = success).

---

## Step 3: Download & Run the Optimizer (2 minutes)

Copy and paste this command into PowerShell:

```powershell
$url = "https://raw.githubusercontent.com/tedofgarlic/W11-LTSC-Optimizer/master/W11_LTSC_Optimizer_Launcher.ps1"
Invoke-WebRequest -Uri $url -OutFile W11_LTSC_Optimizer_Launcher.ps1
.\W11_LTSC_Optimizer_Launcher.ps1
```

**What's happening:**
- First line: Sets the download URL
- Second line: Downloads the script to your computer
- Third line: Runs the script

**Expected:** A colorful box with the optimizer's title and a prompt to continue.

---

## Step 4: Follow the Interactive Flow

The optimizer now guides you through the process. Here's what to expect:

### Screen 1: Welcome & System Check

```
╔═══════════════════════════════════════════════════════════════╗
║  WINDOWS 11 LTSC OPTIMIZER - PROFESSIONAL EDITION           ║
║  Safely optimize your LTSC IoT system...                    ║
╚═══════════════════════════════════════════════════════════════╝
```

**Action:** Read the header, press Enter to continue.

The tool then:
- Checks that you're running as Administrator ✓
- Verifies Windows 11 LTSC is installed ✓
- Confirms you have at least 5GB disk space ✓
- Tests network connectivity (optional)
- Checks System Restore status

**Expected:** All checks pass. If any fail, the tool tells you why and asks if you want to proceed anyway.

### Screen 2: Safety Guarantees

You'll see a list of protected services:

```
✓ Critical services protected:
  • WiFi & Bluetooth (networking)
  • USB devices & input (keyboard, mouse)
  • Windows Update & security
  • Audio, display, RPC infrastructure
```

**Action:** Read to build confidence, press Enter to continue.

### Screen 3: Select Your System Type

```
1. Laptop/Mobile (RECOMMENDED)
   • Optimized for ThinkPad and portable devices
   • Preserves power management and sleep behavior
   • Ideal for on-the-go usage

2. Desktop/Stationary
   • Optimized for permanently connected systems
   • More aggressive power and sleep management
   • Ideal for gaming rigs and workstations

3. Custom/Advanced
   • Select individual modules
   • Fine-grained control over every change
```

**Action:** Type your choice (1, 2, or 3) and press Enter.

**Recommendation:** If you're on a ThinkPad, choose **1** (Laptop).

### Screen 4: Select Optimization Level

```
1. Safe Baseline (RECOMMENDED)
   • Remove telemetry & bloatware
   • Disable non-critical tasks
   • Tune network settings
   • Recommended for all users

2. Gaming & Performance Focused
   • All of Safe Baseline, PLUS aggressive gaming tuning
   • Enable Game Pass and Xbox services
   • Ideal for streaming setup

3. Minimal/Extreme
   • Advanced users only
   • Maximum performance at potential stability cost
```

**Action:** Type your choice (1, 2, or 3) and press Enter.

**Recommendation:** First time? Choose **1** (Safe Baseline).

### Screen 5: Final Confirmation

```
Profile: laptop | Intensity: safe

This will apply safe optimization to your laptop system.
All changes will be logged. System Restore point will be created.

Proceed with optimization? (type 'yes' to confirm)
```

**Action:** Type `yes` and press Enter to begin.

**Important:** Don't type 'y' or 'Y'—it must be 'yes'.

---

## Step 5: Watch the Optimization Run (5-10 minutes)

You'll see progress for each phase:

```
[1/6] Removing telemetry & diagnostics...
  ✓ Telemetry disabled

[2/6] Removing non-essential apps...
  ✓ Removed 8 apps

[3/6] Disabling unnecessary scheduled tasks...
  ✓ Disabled 3 tasks

[4/6] Optimizing network stack...
  ✓ TCP stack tuned for low latency

[5/6] Applying performance tweaks...
  ✓ Performance profile applied

[6/6] Configuring gaming services...
  ✓ Enabled 4 gaming services
```

**Expected:** Green checkmarks for each phase. You can safely watch, but don't interrupt.

### If Something Fails

Don't panic. The tool is designed to fail gracefully:

```
[3/6] Disabling unnecessary scheduled tasks...
  ⚠ Partial completion
```

This just means that particular task was already disabled or couldn't be modified. **This is normal.** The optimization continues without stopping.

---

## Step 6: Review the Completion Summary (2 minutes)

When finished, you'll see:

```
╔═══════════════════════════════════════════════════════════════╗
║  ✓ OPTIMIZATION COMPLETE                                     ║
╚═══════════════════════════════════════════════════════════════╝

Successfully applied:
  ✓ Disabled service: DiagTrack
  ✓ Removed 8 bloatware apps
  ✓ Disabled 3 scheduled tasks
  ✓ Network stack optimized
  ✓ Performance tweaks applied
  ✓ Gaming services enabled
```

**What this means:** All optimizations were successfully applied.

### Next Steps

```
1. RESTART your system for all changes to take effect
   (Changes are not fully active until you reboot)

2. VERIFY critical features after restart:
   • WiFi connectivity
   • Bluetooth devices
   • USB peripherals
   • Audio output

3. TEST gaming/streaming if applicable
   • Launch your games
   • Test streaming services
   • Check performance improvements

4. KEEP YOUR SYSTEM RESTORE POINT
   • You can revert all changes via System Restore if needed
   • Go to Settings > System > Recovery > System Restore
```

**Action:** Follow the next steps. Most importantly, restart your system soon.

### Should You Restart Now?

You'll be asked:

```
Restart now? (yes/no)
```

**Recommendation:** Type `yes` to restart immediately and activate all changes.

**If you type `no`:** The changes are applied but not fully active until you manually restart later.

---

## Step 7: After Restart (5 minutes)

Your system will boot normally. Here's what to verify:

### ✅ WiFi Still Works?

```
1. Click the WiFi icon in the system tray
2. Your network should appear and show "Connected"
3. Open a web browser and load any website
```

**If WiFi is broken:**
- This is very unlikely (WiFi is protected)
- Revert via System Restore immediately (see Troubleshooting below)
- Report the issue on GitHub

### ✅ Bluetooth Working?

If you have Bluetooth devices:
```
1. Go to Settings > Bluetooth & devices
2. Your paired devices should still be there
3. Try connecting to a device
```

### ✅ USB Devices Recognized?

```
1. Plug in a USB device (mouse, keyboard, drive)
2. It should be recognized immediately
3. Try accessing files or using the device
```

### ✅ Audio Works?

```
1. Increase volume and play any audio
2. Speaker should produce sound
3. If you have headphones, test both
```

### ✅ System Feels Faster?

Wait a few minutes for Windows to settle, then:
- Open applications (compare to before)
- Launch a game (note responsiveness)
- Browse the web (general snappiness)

**Expected:** Noticeably faster app launches and system responsiveness.

---

## Common Questions

### Q: Did the optimization actually work?

**A:** Check your disk space:
```
1. Open File Explorer
2. Right-click "C:" drive
3. Select "Properties"
4. Compare to before optimization
```

You should see **5-15% more free space** depending on how much bloatware was installed.

### Q: Can I undo everything?

**A:** Yes, easily:
```
1. Open Windows Settings
2. System > Recovery
3. Click "Open System Restore"
4. Select the checkpoint named "W11_LTSC_Optimizer_Checkpoint..."
5. Click Next > Finish
```

Your system will revert to the state before optimization. This takes 10-15 minutes.

### Q: Why do I need to restart?

**A:** Some changes (especially service startup types) don't fully activate until Windows restarts. It's not strictly required, but you won't get the full benefit until you do.

### Q: Is this safe for production systems?

**A:** The optimization is safe for gaming, streaming, and everyday use on LTSC IoT laptops. If you're running mission-critical workloads, test in a VM first or stick with the Safe Baseline level.

### Q: What if my antivirus complains?

**A:** Some antivirus software flags the script as suspicious (because it modifies system services). This is a false positive. If you're comfortable:
```
1. Add the script to your antivirus exclusion list
2. Disable antivirus temporarily
3. Run the optimizer
4. Re-enable antivirus
```

Or use a trusted device without aggressive antivirus.

### Q: Can I run it multiple times?

**A:** Yes, it's safe. Running it again after changes were manually reverted is fine. Running it multiple times won't cause problems because many operations are idempotent (running them twice = running them once).

### Q: What if something breaks?

**A:** 
1. Use System Restore (see above) to revert
2. Or manually re-enable services (see README for command examples)
3. Report the issue with full details (OS build, hardware, what failed)

---

## Next: Customize Your System

After optimization, consider:

### Gaming Setup
- Install Steam, Epic Games, or Game Pass
- Configure GPU settings (NVIDIA Control Panel, AMD Radeon Settings)
- Test frame rates and latency

### Streaming Setup
- Install streaming software (OBS, Streamlabs)
- Configure encoder settings
- Test stream bitrate and quality

### Privacy Setup
- Enable VPN if desired
- Review Windows privacy settings
- Configure browser security

### Appearance
- Customize desktop background
- Adjust taskbar settings
- Configure display scaling if needed

---

## Support & Issues

### If Something Goes Wrong

1. **Check the log file:**
   ```
   Open: %APPDATA%\W11_LTSC_Optimizer_Logs\
   ```
   This shows exactly what was attempted.

2. **Use System Restore:**
   ```
   Settings > System > Recovery > System Restore
   ```
   Revert to before optimization.

3. **Report on GitHub:**
   - Go to: https://github.com/tedofgarlic/W11-LTSC-Optimizer
   - Click "Issues"
   - Create a new issue with:
     - Your hardware (ThinkPad model, etc.)
     - Windows build number
     - What failed
     - Steps to reproduce
     - Log file content

---

## You're Done! 🎉

Your Windows 11 LTSC IoT system is now optimized for:
- ✓ **Privacy**: Telemetry removed
- ✓ **Performance**: Services and effects optimized
- ✓ **Gaming/Streaming**: Services enabled
- ✓ **Reliability**: Critical components protected

Enjoy your faster, leaner, more private Windows system!

---

**Questions?** Check the full README: https://github.com/tedofgarlic/W11-LTSC-Optimizer/blob/master/README_v2.md