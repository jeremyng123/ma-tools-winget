Write-Host "Disabling Hyper-V on Windows Host to run guest VMs on CPL0"
# https://community.broadcom.com/discussion/disabling-hyper-v-hypervisor-on-windows-11-pro-host-to-get-vmware-17s-cpl0-vs-ulm-monitor-mode

bcdedit /set hypervisorlaunchtype off