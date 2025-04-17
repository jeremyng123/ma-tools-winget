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
- VMware Workstation Pro 17.6 (downloads and install from archive.org. Installer will be deleted after installation)

# Misc
I have also created other PowerShell scripts to:
1. remove Hyper-V to ensure guest VMs run on CPL0. Read [here](https://community.broadcom.com/discussion/disabling-hyper-v-hypervisor-on-windows-11-pro-host-to-get-vmware-17s-cpl0-vs-ulm-monitor-mode) for more information
2. a reg.exe command to restore old context menu (only for Windows 11)
3. added a submodule [Win11Debloat](https://github.com/Raphire/Win11Debloat) (Special thanks to Raphire!) to remove bloatware that comes shipped with Microsoft Windows 11 OOB.

# Usage
1. Run this command first in PowerShell admin to execute scripts directly
```powershell
Set-ExecutionPolicy -ExecutionPolicy Bypass
```

2. Navigate to this repository in your PowerShell

3. Install applications
```powershell
.\winget-tools.ps1
```

4. Remove Hyper-V
```powershell
.\cpl0-vmware.ps1
```

5. Restore old context menu
```powershell
.\restore-old-context-menu.ps1
```


# Future works:
- [ ] Output logs/error logs to a log file

# Special Mentions:
- [Raphire](https://github.com/Raphire) for the Win11 Debloat scripts
