# Check for Administrator privileges
if (-not ([Security.Principal.WindowsPrincipal] `
    [Security.Principal.WindowsIdentity]::GetCurrent()
).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)) {
    
    Write-Host "Restarting with administrative privileges..."

    # Relaunch script with elevated privileges
    $arguments = "& '" + $myInvocation.MyCommand.Definition + "'"
    Start-Process powershell -Verb runAs -ArgumentList $arguments
    exit
}

# --------------- YOUR XXX ACTIONS START HERE ---------------
Write-Host "Running with elevated privileges..."

Write-Host "Installing SystemInformer..."
winget show WinsiderSS.SystemInformer

Write-Host "Installing Git..."
winget install --id Git.Git -e --source winget

Write-Host "Installing Microsoft Sysinternals Suite..."
winget install -e --id Microsoft.Sysinternals -e

Write-Host "Installing Oracle Java 21 (LTS)"
winget install -e --id Oracle.JDK.21

Write-Host "Installing Python 3.12..."
winget install -e --id Python.Python.3.12 --location "C:\Python312"

Write-Host "Installing Microsoft.WinDbg"
winget install Microsoft.WinDbg

Write-Host "Installing 7zip.7zip"
winget install -e --id 7zip.7zip

Write-Host "Installing Microsoft.VisualStudio BuildTools & Community"
winget install --id Microsoft.VisualStudio.2022.BuildTools
winget install --id Microsoft.VisualStudio.2022.Community --addProductLang En-us --add Microsoft.VisualStudio.Workload.NativeDesktop --includeRecommended

Write-Host "Installing WiresharkFoundation.Wireshark"
winget install --id WiresharkFoundation.Wireshark

Write-Host "Installing ImHex Editor"
winget install --id WerWolv.ImHex -e

Write-Host "Installing Google.Chrome"
winget install --id Google.Chrome -e

Write-Host "Installing Adobe Acrobat Reader"
winget install --id Adobe.Acrobat.Reader.64-bit -e

Write-Host "Installing voidtools.Everything"
winget install -e --id voidtools.Everything

Write-Host "Downloading VMware Workstation Pro 17.6"
# Define variables
$url = "https://archive.org/download/vmware-workstation-full-17.6.1-24319023_20241117/VMware-workstation-full-17.6.1-24319023.exe"
$installer = "$env:TEMP\VMware-workstation-full-17.6.1-24319023.exe"
Invoke-WebRequest -Uri $url -OutFile $installer
# Run the installer silently (assumes /silent or /S switch works)
Start-Process -FilePath $installer -ArgumentList "/S" -Wait
# Delete the installer
Remove-Item $installer -Force

# --------------- YOUR XXX ACTIONS END HERE -----------------

Write-Host "Actions completed."
