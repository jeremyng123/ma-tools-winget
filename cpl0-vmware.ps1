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

Write-Host "Disabling Hyper-V on Windows Host to run guest VMs on CPL0"
# https://community.broadcom.com/discussion/disabling-hyper-v-hypervisor-on-windows-11-pro-host-to-get-vmware-17s-cpl0-vs-ulm-monitor-mode

bcdedit /set hypervisorlaunchtype off

Write-Host "Switching off VirtualizationBasedSecurity..."
Set-ItemProperty -Path "HKLM:\System\CurrentControlSet\Control\DeviceGuard" -Name "EnableVirtualizationBasedSecurity" -Value 0 -Force
# GPO should be linked to registry
# run this command to ensure GPO is updated
gpupdate /force 


Write-Host "Actions completed."
