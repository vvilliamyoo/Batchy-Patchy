# Prompt for administrator privileges
if (-not ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator")) {
    $arguments = "& '" + $MyInvocation.MyCommand.Path + "'"
    Start-Process powershell -Verb RunAs -ArgumentList $arguments
    Exit
}

# Check for PSWindowsUpdate module
$moduleName = "PSWindowsUpdate"
$installedModules = Get-Module -Name $moduleName -ListAvailable
Write-Host "Checking for $moduleName module"
if ($installedModules) {
    Write-Host "$moduleName module is installed"
} 
else {
    Write-Host "$moduleName module is not installed; installing now"
    Install-Module $moduleName
    Write-Host "Done"
}
Start-Sleep -Seconds 1

# Search for available Windows updates
Write-Host "Checking for Windows updates"
Get-WindowsUpdate -AcceptAll -Install
Write-Host "Done"
Start-Sleep -Seconds 1

# Run "winget upgrade --all"
Write-Host "Running 'winget upgrade --all'"
Start-Process -FilePath "winget" -ArgumentList "upgrade --all" -NoNewWindow -Wait
Write-Host "Done"
Start-Sleep -Seconds 1

# Prompt the user to open the Microsoft Store
$response = Read-Host "Open the Microsoft Store? [y] or [n]"
if ($response -eq "y" -or $response -eq "Y") {
    Start-Process "ms-windows-store:"
}

# Pause before closing
Write-Host "Press any key to exit"
$null = $Host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")
