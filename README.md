Batchy Patchy is a product that performs updates for Windows, desktop applications, and (loosely) Microsoft Store applications.

Update methodology:
 - Windows: PSWindowsUpdate (PowerShell module)
 - Desktop applications: Windows Package Manager
 - Microsoft Store applications: N/A (opens Microsoft Store)

The batch file called 'auto_update' provides user-facing (main) functionality when clicked, which runs a PowerShell script containing the afformentioned updates.