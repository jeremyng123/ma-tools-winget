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

(Get-WmiObject -query 'select * from SoftwareLicensingService').OA3xOriginalProductKey


# --------------- YOUR XXX ACTIONS END HERE -----------------

Write-Host "Actions completed."
