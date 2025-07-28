# Windows Activation Script
A simple PowerShell script to automate Windows activation via KMS. It detects your OS edition and build, allows you to select your installed version, installs the appropriate product key, sets a KMS server, and attempts activation.

---
## ⚙️ Features
- Auto-elevates to Administrator if needed.
- Detects Windows edition and version (Windows 10 or 11).
- Prompts the user to choose:
    - Home
    - Pro
    - Enterprise
- Installs the selected edition’s KMS client key.
- Sets a public KMS server (`kms8.msguides.com`).
- Activates Windows using `slmgr.vbs`.
---
## 🧪 Requirements
- Windows 10 or Windows 11
- Administrator privileges
- Internet access (for KMS server)
- `slmgr.vbs` (included by default in Windows)
---
## 🚀 How to Use

1. **Add your own activation keys**  
	Open the script and locate the `$keys` block. Replace the placeholder `XXXXX-XXXXX-XXXXX-XXXXX-XXXXX` values with your own **valid KMS client setup keys** or appropriate activation keys.
2. **Right-click** `WindowsActivationScript.ps1` and choose **Run with PowerShell**  
    _(Alternatively: open PowerShell as Administrator and run the script manually)_
3. Follow the on-screen prompts:
    - Confirm your OS info
    - Choose the edition you want to activate
    - The script will handle key installation and activation
4. Wait for the "Activation process complete." message.
---
## 🔐 Notes
- The script uses **KMS client keys**, which are publicly available and do not violate licensing terms when used with a legitimate KMS server.
- It does **not install pirated or unauthorized keys**.
- This script is intended for **testing, lab, or enterprise environments** where KMS activation is permitted.
---
## 🧩 Supported Editions

|OS|Home|Pro|Enterprise|
|---|---|---|---|
|Windows 10|✅|✅|✅|
|Windows 11|❌|✅|✅|

_Note: Windows 11 Home is not supported due to KMS key limitations._

---
## ❗ Disclaimer
This script is for **educational and testing purposes only**. You are responsible for ensuring you comply with Microsoft's licensing terms.