# Application Config Backup Script
This repository contains a reusable Windows batch script to back up configuration folders of applications that store data under `%AppData%` (Roaming) and `%LocalAppData%` (Local).

## Features
- Backs up `%AppData%\[Application]` and `%LocalAppData%\[Application]` folders.
- Creates a dated backup folder with automatic versioning (`YYYY-MM-DD_1`, `YYYY-MM-DD_2`, etc.).
- Saves backups inside an `\[Application]` folder next to the script location.
- Easily customizable by setting the `APPLICATION` variable in the script.
## Usage
1. Clone or download this repository.
2. Edit the `LogitechGhub_backup.bat` script:
    `set "APPLICATION=LogitechGhub"`
    Replace `LogitechGhub` with the folder name your application uses in `%AppData%` and `%LocalAppData%`.
3. Run `LogitechGhub_backup.bat` by double-clicking it or from the command line.
4. Backups will be saved in a subfolder named after the application in the same directory as the script, e.g.,
```
	LGHUB\2025-07-28_1\
				├── Roaming\
				└── Local\
```
## Example
Backing up Logitech G HUB settings (default):
- `%AppData%\LGHUB` → `Roaming` backup folder.
- `%LocalAppData%\LGHUB` → `Local` backup folder.
## Notes
- The script requires PowerShell for date formatting (available by default on Windows 7+).
- The script uses `xcopy` and will overwrite existing files without prompt.
- Make sure the application is closed before restoring backups.
## Extending
You can adapt this script for other applications by changing the `APPLICATION` variable to the app’s config folder name.