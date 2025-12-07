# Contributing to W11-LTSC-Optimizer

Thank you for your interest in contributing! We welcome all types of contributions.

## 🚀 Ways to Contribute

### 1. Report Bugs 🐛

If you find a bug, please open a GitHub Issue with:

```
Title: [BUG] Brief description
Description:
- What happened
- Expected behavior
- Steps to reproduce
- System info (CPU, GPU, RAM, Windows build)
- Relevant error messages
```

### 2. Suggest Features 💡

Open a GitHub Issue with:

```
Title: [FEATURE] Brief description
Description:
- What you want
- Why it would be useful
- Example use case
- Any related features
```

### 3. Submit Pull Requests 🔧

1. **Fork** the repository
2. **Create** a feature branch: `git checkout -b feature/your-feature`
3. **Make** your changes
4. **Test** thoroughly on Windows 11 LTSC IoT
5. **Commit** with clear messages: `git commit -m "Add [feature]: description"`
6. **Push** to your fork: `git push origin feature/your-feature`
7. **Create** Pull Request with description

### 4. Improve Documentation 📖

- Fix typos or unclear sections
- Add examples or clarifications
- Improve formatting or organization
- Submit via Pull Request

### 5. Share & Discuss 💬

- Star the repository
- Share with your network
- Participate in Discussions
- Provide feedback on features

---

## 📋 Code Quality Standards

### PowerShell Code

```powershell
# ✅ Good
$result = Get-Service -Name "MyService" | Select-Object -ExpandProperty Status
if ($result -eq "Running") {
    Write-Host "Service is running" -ForegroundColor Green
}

# ❌ Avoid
$svc = Get-Service "MyService"
if ($svc.Status -eq "Running") { write-host "running" }
```

### Guidelines

- **Comments**: Explain complex logic clearly
- **Functions**: Use descriptive names (verb-noun format)
- **Error Handling**: Use try-catch for critical operations
- **Testing**: Verify changes don't break existing functionality
- **Documentation**: Update README if adding features

---

## 🧪 Testing Before Submit

### Required Testing

- [ ] Script runs without errors
- [ ] No service breakage (WiFi, Bluetooth, USB)
- [ ] Can revert with System Restore
- [ ] Tested on Windows 11 LTSC IoT
- [ ] No permission issues
- [ ] Logging works correctly

### Test on Your System

```powershell
# Run the script on a test machine
.\W11_LTSC_Master.ps1

# Verify results
Get-Service WlanSvc  # Should be Running
Get-Service bthserv  # Should be Running
Get-EventLog System -Newest 5  # Check for errors
```

---

## 📝 Commit Message Format

Use clear, descriptive commit messages:

```
✅ Add telemetry removal section
🐛 Fix service startup issue
📖 Update documentation for gaming tweaks
🔧 Improve error handling in cleanup section
```

---

## 🏆 Code Review Process

1. **Submission**: You create a Pull Request
2. **Review**: Maintainer reviews for:
   - Code quality
   - Safety and reversibility
   - Documentation
   - Testing completeness
3. **Feedback**: Comments and suggestions
4. **Revision**: You make updates if needed
5. **Merge**: PR is merged when approved

---

## ❓ Questions?

- **Documentation**: Check [README.md](README.md)
- **Specific Help**: Open a [Discussion](https://github.com/tedofgarlic/W11-LTSC-Optimizer/discussions)
- **Security Issues**: See [SECURITY.md](SECURITY.md)

---

## 📜 License

By contributing, you agree that your contributions will be licensed under the MIT License.

---

**Thank you for making W11-LTSC-Optimizer better! 🎉**
