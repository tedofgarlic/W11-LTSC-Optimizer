# GitHub Repo Automation Guide

## Prerequisites

1. **Git installed** - https://git-scm.com/download/win
2. **GitHub CLI installed** - https://cli.github.com  
3. **GitHub account created** - https://github.com/signup
4. **GitHub CLI authenticated** - gh auth login

## Automated Setup

\\\powershell
Set-ExecutionPolicy Unrestricted -Scope CurrentUser -Force
.\Create-GitHubRepo.ps1
\\\

## Manual Setup

\\\ash
git init
git add .
git commit -m "Initial commit: W11 LTSC Optimizer"
git remote add origin https://github.com/[username]/W11-LTSC-Optimizer.git
git branch -M main
git push -u origin main
\\\

---

See DEPLOYMENT_SUMMARY.md for complete details.
