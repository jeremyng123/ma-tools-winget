# MA Tools Winget
This repository is to automate installation of all the tools that I have deemed necessary or useful for MARE (Malware Analysis Reverse Engineer)

# Getting Started
Make sure you have winget installed
```batch
winget --version
```

> [!NOTE] If there is no winget:
> Install winget with this command (https://learn.microsoft.com/en-us/windows/package-manager/winget/):
> ```powershell
> Add-AppxPackage -RegisterByFamilyName -MainPackage Microsoft.DesktopAppInstaller_8wekyb3d8bbwe
> ```

# Tools installed
- SystemInformer
- Git
- Microsoft Sysinternals Suite
- Oracle Java 21 (LTS)
- Python 3.12
- Microsoft.WinDbg
- 7zip.7zip
- Microsoft.VisualStudio BuildTools & Community
- WiresharkFoundation.Wireshark
- ImHex Editor
- Google.Chrome
- Adobe Acrobat Reader
- voidtools.Everything
- Obsidian
- VMware Workstation Pro 17.6 (downloads and install from archive.org. Installer will be deleted after installation)

# Misc
I have also created other PowerShell scripts to:
1. remove Hyper-V to ensure guest VMs run on CPL0. Read [here](https://community.broadcom.com/discussion/disabling-hyper-v-hypervisor-on-windows-11-pro-host-to-get-vmware-17s-cpl0-vs-ulm-monitor-mode) for more information
2. a reg.exe command to restore old context menu (only for Windows 11)
3. added a submodule [Win11Debloat](https://github.com/Raphire/Win11Debloat) (Special thanks to Raphire!) to remove bloatware that comes shipped with Microsoft Windows 11 OOB.

## Caveat about CPL0 VMware
This subsection is to briefly explain what we are looking out for.

Since Win8+, Windows are typically installed on a hypervisor (Hyper-V) so that the Hypervisor communicates between the Bare Metal and the actual Windows. However, this meant that VMware will be running on User Mode Level (UML). When VMs are running at UML, the CPU is emulated on a software. This causes a few issues:
1. Guest Windows VM will be running on a single core with a single thread
2. Guest VMs experience will feel sluggish
3. Snapshots take significantly longer time

To avoid this, we need our main Windows to run on Bare Metal (by extension, we must disable virtualization security). Through this way, the guest VMs on VMware can now run directly on the hypervisor (VMware is on hypervisor, while the guest VMs it manages is bridged to VMware). In other words, our Guest VM needs to run on CPU Privileged Level 0 (CPL0). This is also commonly known as Ring 0 (for the compsci geeks).

I found that the 2 out of 3 phases of the work described in this [forum topic](https://community.broadcom.com/discussion/disabling-hyper-v-hypervisor-on-windows-11-pro-host-to-get-vmware-17s-cpl0-vs-ulm-monitor-mode) was sufficient to let VMware be executed on the hypervisor. This ps1 scripts `.\cpl0-vmware.ps1` hence only contain steps for 2 of the phases. If the execution of this script did not change the Monitor Mode from UML to CPL0, then please follow that topic to complete Phase 3 of the step.

## How to check our Guest VM is running on CPL0?
1. Run any guest VM on VMware Workstation Pro
2. Navigate to the guest VM directory
3. Open the file `vmware.log`
4. Search for `vmx Monitor Mode:`. The value will read either UML or CPL0.

## Installing Windows 11 Guest OS
Use Official [Microsoft Windows Media Creation](https://www.microsoft.com/en-us/software-download/windows11) page.

Choose Windows 11 (multi-edition ISO for x64 devices). You will download an ISO file. Use this ISO file to create a new VM in VMware.

On your host OS, execute `.\get-current-windows-product-key.ps1` to get your current product key which you will use when installing the VM.

# Usage
1. Run this command first in PowerShell admin to execute scripts directly
```powershell
Set-ExecutionPolicy -ExecutionPolicy Bypass
```

2. Navigate to this repository in your PowerShell

3. Install applications
```batch
.\winget-tools.ps1
```

4. Remove Hyper-V
```batch
.\cpl0-vmware.ps1
```

5. Restore old context menu
```batch
.\restore-old-context-menu.ps1
```


# Future works:
- [ ] Output logs/error logs to a log file
- [ ] Installing of VSCode plugins
- [ ] Installing of Obsidian plugins

# Special Mentions:
- [Raphire](https://github.com/Raphire) for the Win11 Debloat scripts
