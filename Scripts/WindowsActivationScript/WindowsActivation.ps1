# Elevate Priv
if (!([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator")) { Start-Process powershell.exe "-NoProfile -ExecutionPolicy Bypass -File `"$PSCommandPath`"" -Verb RunAs; exit }

# Check for administrator privileges
If (-NOT ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator"))
{
    Write-Warning "Please run this script as Administrator."
    Pause
    Exit
}

# Detect OS version and edition
$osInfo = Get-ItemProperty "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion"
$edition = $osInfo.ProductName
$releaseId = $osInfo.ReleaseId
$currentBuild = $osInfo.CurrentBuildNumber

Write-Host "Detected OS: $edition (Build $currentBuild, Release $releaseId)"

# Determine if Windows 10 or 11
if ($edition -match "Windows 11") {
    $osType = "Windows11"
} elseif ($edition -match "Windows 10") {
    $osType = "Windows10"
} else {
    Write-Warning "Unsupported or unrecognized Windows edition detected. Proceeding with Windows 10 keys as default."
    $osType = "Windows10"
}

# Check activation status
$activationStatus = (Get-CimInstance SoftwareLicensingProduct | Where-Object { $_.PartialProductKey } | Select-Object -First 1).LicenseStatus
if ($activationStatus -eq 1) {
    Write-Host "Windows is already activated."
} else {
    Write-Host "Windows is NOT activated."
}

Write-Host "Press Enter to continue..."
[void][System.Console]::ReadLine()

# Prompt user edition choices (Education removed)
Write-Host "Select the Windows edition to activate:"
Write-Host "1. Home"
Write-Host "2. Pro"
Write-Host "3. Enterprise"

do {
    $selection = Read-Host "Enter the number corresponding to your edition"
} while ($selection -notin '1','2','3')

# Define keys for Windows 10 and Windows 11 editions
$keys = @{
    "Windows10" = @{
        '1' = 'XXXXX-XXXXX-XXXXX-XXXXX-XXXXX' # Home Edition
        '2' = 'XXXXX-XXXXX-XXXXX-XXXXX-XXXXX' # Pro Edition
        '3' = 'XXXXX-XXXXX-XXXXX-XXXXX-XXXXX' # Enterprise Edition
    }
    "Windows11" = @{
        '1' = 'XXXXX-XXXXX-XXXXX-XXXXX-XXXXX' # Home Edition
        '2' = 'XXXXX-XXXXX-XXXXX-XXXXX-XXXXX' # Pro Edition
        '3' = 'XXXXX-XXXXX-XXXXX-XXXXX-XXXXX' # Enterprise Edition
    }
}

$key = $keys[$osType][$selection]

Write-Host "You selected edition number $selection for $osType. Using the corresponding key."

# Proceed with activation steps
Write-Host "Installing product key..."
Start-Process -FilePath "slmgr.vbs" -ArgumentList "/ipk $key" -Wait
Start-Sleep -Seconds 10

Write-Host "Setting KMS server..."
Start-Process -FilePath "slmgr.vbs" -ArgumentList "/skms kms8.msguides.com" -Wait
Start-Sleep -Seconds 10

Write-Host "Activating Windows..."
Start-Process -FilePath "slmgr.vbs" -ArgumentList "/ato" -Wait
Start-Sleep -Seconds 10

Write-Host "Activation process complete."
Pause
