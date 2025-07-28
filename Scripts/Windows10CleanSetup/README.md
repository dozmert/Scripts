# Windows 10 Setup Automation Script
This PowerShell script performs a one-click setup and cleanup of a fresh Windows 10 installation. It disables unwanted features, improves privacy, and applies UI/UX and performance optimizations.

---
## ⚙️ Features

### 🔒 Privacy & Bloat Removal
- Disables:
    - **Activity history**
    - **Windows Tips and Suggestions**
    - **Windows welcome experience**
    - **Cortana**
    - **Web/Bing search integration**
- Hides or removes
    - **OneDrive in File Explorer**
    - **Task View button**
    - **News and Interests**
    - **Recent Files in Quick Access**
### 🎨 UI & Usability
- Shows **hidden files** and **file extensions**
- Shows **seconds** in the taskbar clock
- Always shows **all tray icons**
- Hides the **search bar** (replaces with icon only)
- Unpins all default taskbar items
- Pins **File Explorer** to taskbar
### 🚀 Performance
- Applies "Best performance" settings with minor visual tweaks:
    - Enables smooth scroll, font smoothing, full window drag
### 📂 File System & Registry Tweaks
- Cleans taskbar pins
- Tweaks several keys under:
    - `HKCU:\Software\Microsoft\Windows\CurrentVersion`
    - `HKLM:\SOFTWARE\Policies\Microsoft\Windows`
---
## 🧪 Requirements
- **Windows 10**
- **Administrator privileges**
---
## 🛠️ Usage

1. **Right-click the script** and choose **“Run with PowerShell”**  
    Or open PowerShell as Administrator and run:
```powershell
.\Windows10CleanSetup.ps1
```
2. The script will:
    - Elevate privileges automatically
    - Apply all tweaks and changes
    - Restart Explorer at the end
---
## 📝 Notes
- Some changes may require a **logout** or **reboot** to fully take effect.
- You can **uncomment** the OneDrive uninstall block to fully remove OneDrive.
- This script is **safe to re-run**, it won’t duplicate settings.

---
## ❗ Disclaimer
Use at your own risk. This script modifies Windows registry and system settings. Always test in a VM or non-production machine first.