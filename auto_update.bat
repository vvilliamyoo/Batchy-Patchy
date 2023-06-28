@echo off
cd /d "%~dp0"
powershell.exe -ExecutionPolicy Bypass -File "update_script.ps1"