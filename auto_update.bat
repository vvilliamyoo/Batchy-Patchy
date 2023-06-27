@echo off
cd /d "%~dp0"
powershell.exe -ExecutionPolicy Bypass -File "batch_update.ps1"