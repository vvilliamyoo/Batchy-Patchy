# Prompt for administrator privileges
if (-not ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator")) {
    $arguments = "& '" + $MyInvocation.MyCommand.Path + "'"
    Start-Process powershell -Verb RunAs -ArgumentList $arguments
    Exit
}

# Check for PSWindowsUpdate module, search for updates if allowed
. "$PSScriptRoot\functions.ps1"
$moduleName = "PSWindowsUpdate"
$installedModules = Get-Module -Name $moduleName -ListAvailable
Write-Host "Checking for $moduleName"
$exitVar = 0
if ($installedModules) {
    Write-Host "$moduleName is installed"
    Search-Updates
}
else {
    while ($exitVar -ne 1) {
        $response = Read-Host "$moduleName is required for this action but is not installed. Download and install now? [y] or [n]"
        if ($response -eq "y" -or $response -eq "Y") {
            Install-Module $moduleName
            Write-Host "Done"
            Search-Updates
            $exitVar = 1
        }
        elseif ($response -eq "n" -or $response -eq "N") {
            Write-Host "Skipped $moduleName"
            $exitVar = 1
        }
        else {
            Write-Host "Invalid response, please try again"
        }
    }
}
$exitVar = 0
Start-Sleep -Seconds 1

# Run "winget upgrade --all"
Write-Host "Checking for desktop application updates"
Start-Process -FilePath "winget" -ArgumentList "upgrade --all" -NoNewWindow -Wait
Write-Host "Done"
Start-Sleep -Seconds 1

# Prompt the user to open Microsoft Store
while ($exitVar -ne 1) {
    $response = Read-Host "Open Microsoft Store? [y] or [n]"
    if ($response -eq "y" -or $response -eq "Y") {
        Start-Process "ms-windows-store:"
        $exitVar = 1
    }
    elseif ($response -eq "n" -or $response -eq "N") {
        Write-Host "Skipped Microsoft Store"
        $exitVar = 1
    }
    else {
        Write-Host "Invalid response, please try again"
    }
}

# Pause before closing
Write-Host "Press any key to exit"
$null = $Host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")
