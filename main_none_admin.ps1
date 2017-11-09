. "$PSScriptRoot\common\funcs.ps1"

if (!(IsAdmin) )
{
    Write-Output "Run as admin."
    exit
}

& "$PSScriptRoot\install_drivers.ps1"
& "$PSScriptRoot\move_user_folders.ps1"
& "$PSScriptRoot\debloat_windows.ps1"
& "$PSScriptRoot\install_software.ps1"
& "$PSScriptRoot\install_exes.ps1"
& "$PSScriptRoot\set_default_browser.ps1"
& "$PSScriptRoot\enable_developer_mode.ps1"

Set-WinUserLanguageList da
Enable-WindowsOptionalFeature -Online -FeatureName Microsoft-Windows-Subsystem-Linux