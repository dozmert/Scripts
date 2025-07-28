# Elevate Priv
if (!([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator")) { Start-Process powershell.exe "-NoProfile -ExecutionPolicy Bypass -File `"$PSCommandPath`"" -Verb RunAs; exit }


# Check for administrator privileges
If (-NOT ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator"))
{
    Write-Warning "You do not have Administrator rights to run this script. Please re-run it as Administrator."
    Exit
}

Write-Host "Starting Windows 10 setup automation..."

# --- Desktop Cleanup ---
Write-Host "Unpinning all taskbar items..."
$taskbarPath = "$env:APPDATA\Microsoft\Internet Explorer\Quick Launch\User Pinned\TaskBar"
if (Test-Path $taskbarPath) {
    Get-ChildItem $taskbarPath -Filter *.lnk | Remove-Item -Force
}

Write-Host "Disabling 'News and Interests'..."
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Feeds" /v ShellFeedsTaskbarViewMode /t REG_DWORD /d 2 /f

Write-Host "Removing Task View button..."
Set-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" -Name ShowTaskViewButton -Value 0

Write-Host "Hiding search box on taskbar (icon only)..."
Set-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Search" -Name SearchboxTaskbarMode -Value 0

# --- Privacy & Permissions ---
Write-Host "Disabling activity history..."
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\ActivityHistory" /v EnableActivityFeed /t REG_DWORD /d 0 /f
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\ActivityHistory" /v PublishUserActivities /t REG_DWORD /d 0 /f
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\ActivityHistory" /v UploadUserActivities /t REG_DWORD /d 0 /f

Write-Host "Disabling Windows Tips and Suggestions..."
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" /v SubscribedContent-338388Enabled /t REG_DWORD /d 0 /f
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" /v SystemPaneSuggestionsEnabled /t REG_DWORD /d 0 /f
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" /v SoftLandingEnabled /t REG_DWORD /d 0 /f

Write-Host "Disabling 'Show me the Windows welcome experience'..."
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" /v OOBEExperienceEnabled /t REG_DWORD /d 0 /f

# Disable Cortana
Write-Host "Disabling Cortana..."
$CortanaKey = "HKLM:\SOFTWARE\Policies\Microsoft\Windows\Windows Search"
if (-not (Test-Path $CortanaKey)) {
    New-Item -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows" -Name "Windows Search" | Out-Null
}
New-ItemProperty -Path $CortanaKey -Name "AllowCortana" -PropertyType DWORD -Value 0 -Force | Out-Null

# --- Search Configuration ---
Write-Host "Disabling web search in Start menu..."
$explorerKey = "HKLM:\SOFTWARE\Policies\Microsoft\Windows\Explorer"
if (-not (Test-Path $explorerKey)) {
    New-Item -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows" -Name "Explorer" | Out-Null
}
New-ItemProperty -Path $explorerKey -Name "DisableSearchBoxSuggestions" -PropertyType DWord -Value 1 -Force | Out-Null

Write-Host "Disabling Bing integration in search..."
$searchKey = "HKCU:\Software\Microsoft\Windows\CurrentVersion\Search"
Set-ItemProperty -Path $searchKey -Name BingSearchEnabled -Value 0 -Force
Set-ItemProperty -Path $searchKey -Name CortanaConsent -Value 0 -Force

# --- Performance Tweaks ---
Write-Host "Setting performance options for best performance with key visual tweaks..."
$perfKey = "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\VisualEffects"
New-ItemProperty -Path $perfKey -Name VisualFXSetting -PropertyType DWord -Value 2 -Force | Out-Null

$desktopKey = "HKCU:\Control Panel\Desktop"
Set-ItemProperty -Path $desktopKey -Name DragFullWindows -Value 1
Set-ItemProperty -Path $desktopKey -Name SmoothScroll -Value 1
Set-ItemProperty -Path $desktopKey -Name FontSmoothing -Value 2

# Show hidden files and extensions
Write-Host "Showing hidden files and file extensions..."
Set-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" -Name Hidden -Value 1
Set-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" -Name HideFileExt -Value 0

# --- Show all tray icons (including USB safely remove) ---
Write-Host "Always showing all tray icons..."
Set-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer" -Name "EnableAutoTray" -Value 0

# --- Remove OneDrive from File Explorer sidebar ---
Write-Host "Removing OneDrive from File Explorer sidebar..."
New-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" -Name "DontUseOneDriveForFileStorage" -Value 1 -Force | Out-Null

# --- Optional: Uninstall OneDrive ---
# Uncomment the following lines if you want to uninstall OneDrive completely
# Write-Host "Uninstalling OneDrive..."
# Stop-Process -Name OneDrive -ErrorAction SilentlyContinue
# Start-Process -FilePath "$env:SystemRoot\SysWOW64\OneDriveSetup.exe" -ArgumentList "/uninstall" -Wait

# --- Disable Recent Files in Quick Access ---
Write-Host "Disabling Recent Files and Frequent Folders in Quick Access..."
Set-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" -Name "Start_TrackDocs" -Value 0 -Force
Set-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" -Name "Start_TrackProgs" -Value 0 -Force

# --- Pin File Explorer to Taskbar ---
Write-Host "Pinning File Explorer to the taskbar..."

# Path to File Explorer shortcut
$explorerPath = "$env:SystemRoot\explorer.exe"

# Use Shell COM object to pin File Explorer to taskbar
$Shell = New-Object -ComObject Shell.Application
$Folder = $Shell.Namespace((Split-Path $explorerPath))
$Item = $Folder.ParseName((Split-Path $explorerPath -Leaf))

# Method to pin to taskbar
$Verb = $Item.Verbs() | Where-Object { $_.Name.Replace('&','') -match 'Pin to Tas&kbar|Pin to Taskbar' }
if ($Verb) {
    $Verb.DoIt()
    Write-Host "File Explorer pinned to taskbar."
} else {
    Write-Host "File Explorer is already pinned or cannot be pinned."
}

# Show seconds in taskbar clock
Set-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" -Name "ShowSecondsInSystemClock" -Type DWord -Value 1

# --- Restart Explorer to apply UI changes ---
Write-Host "Restarting Explorer to apply UI changes..."
Stop-Process -Name explorer -Force
Start-Process explorer

Write-Host ""
Write-Host "Setup complete. Some changes may require a reboot or logout to fully take effect."
