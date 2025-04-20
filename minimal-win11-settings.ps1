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

# Must be run as Administrator

# --- Step 1: Disable Tamper Protection via Registry (requires reboot to take effect)
Write-Host "Disabling Tamper Protection..." -ForegroundColor Yellow
New-Item -Path "HKLM:\SOFTWARE\Microsoft\Windows Defender\Features" -Force | Out-Null
Set-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows Defender\Features" -Name "TamperProtection" -Value 0 -Type DWord

# --- Step 2: Disable Defender Real-Time Protection
Write-Host "Disabling Windows Defender protections..." -ForegroundColor Yellow
Set-MpPreference -DisableRealtimeMonitoring $true
Set-MpPreference -DisableBehaviorMonitoring $true
Set-MpPreference -DisableBlockAtFirstSeen $true
Set-MpPreference -DisableIOAVProtection $true
Set-MpPreference -DisableScriptScanning $true
Set-MpPreference -SubmitSamplesConsent 2
Set-MpPreference -MAPSReporting 0

# --- Step 3: Add Defender Exclusions (optional but helps avoid detection)
Add-MpPreference -ExclusionPath "C:\Malware", "C:\Users\Public", "C:\Users\ma\AppData\Local\imhex\yara", "C:\Users\ma\Documents", "C:\Users\ma\Downloads"
Add-MpPreference -ExclusionProcess "powershell.exe", "cmd.exe", "explorer.exe"

# --- Step 4: Stop and disable Defender & Firewall
Stop-Service -Name "WinDefend" -Force
Set-Service -Name "WinDefend" -StartupType Disabled

Set-NetFirewallProfile -Profile Domain,Public,Private -Enabled False

# --- Step 5: Disable Windows Updates and related services
Stop-Service -Name "wuauserv","bits","dosvc","usosvc" -Force
Set-Service -Name "wuauserv" -StartupType Disabled
Set-Service -Name "bits" -StartupType Disabled
Set-Service -Name "dosvc" -StartupType Disabled
Set-Service -Name "usosvc" -StartupType Disabled

# --- Step 6: Create Scheduled Task to Re-Disable Settings at Boot (Persistence)
$taskName = "DisableSecurityAtStartup"
$scriptBlock = @"
Set-MpPreference -DisableRealtimeMonitoring \$true
Set-MpPreference -DisableBehaviorMonitoring \$true
Set-MpPreference -DisableBlockAtFirstSeen \$true
Set-MpPreference -DisableIOAVProtection \$true
Set-MpPreference -DisableScriptScanning \$true
Set-MpPreference -SubmitSamplesConsent 2
Set-MpPreference -MAPSReporting 0
Set-Service -Name WinDefend -StartupType Disabled
Stop-Service -Name WinDefend -Force
Set-NetFirewallProfile -Profile Domain,Public,Private -Enabled False
Stop-Service -Name wuauserv,bits,dosvc,usosvc -Force
Set-Service -Name wuauserv -StartupType Disabled
Set-Service -Name bits -StartupType Disabled
Set-Service -Name dosvc -StartupType Disabled
Set-Service -Name usosvc -StartupType Disabled
"@

$startupScript = "$env:ProgramData\disable_security_startup.ps1"
$scriptBlock | Out-File -FilePath $startupScript -Encoding ASCII

Register-ScheduledTask -TaskName $taskName -Trigger (New-ScheduledTaskTrigger -AtStartup) `
  -Action (New-ScheduledTaskAction -Execute "powershell.exe" -Argument "-ExecutionPolicy Bypass -File `"$startupScript`"") `
  -RunLevel Highest -User "SYSTEM" -Force

# --- Final Notice
Write-Host "Security features disabled. Reboot is required to disable Tamper Protection fully." -ForegroundColor Red



# --------------- YOUR XXX ACTIONS END HERE -----------------

Write-Host "Actions completed."
