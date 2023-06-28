# Search for available Windows updates
function Search-Updates {
    Write-Host "Checking for Windows updates"
    Get-WindowsUpdate -AcceptAll -Install
    Write-Host "Done"
}
