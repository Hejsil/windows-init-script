. "$PSScriptRoot\common\funcs.ps1"

if (!(IsAdmin) )
{
    Write-Output "Run as admin."
    exit
}

Get-ChildItem -Recurse *.ps1 | Unblock-File
Get-ChildItem -Recurse *.psm1 | Unblock-File

$full = "$PSScriptRoot\Debloater"
DownloadAndExtractZip "https://github.com/W4RH4WK/Debloat-Windows-10/archive/master.zip" "$full"

Write-Output "Debloating Windows."
    
$path = "$full\Debloat-Windows-10-master"
$scripts = "$path\scripts"
$utils = "$path\utils"

& "$scripts\block-telemetry.ps1"
& "$scripts\disable-services.ps1"
#& "$scripts\disable-windows-defender.ps1"
#& "$scripts\experimental_unfuckery.ps1"
& "$scripts\fix-privacy-settings.ps1"
#& "$scripts\optimize-user-interface.ps1"
#& "$scripts\optimize-windows-update.ps1"
& "$scripts\remove-default-apps.ps1"
& "$scripts\remove-onedrive.ps1"
#& "$utils\enable-god-mode.ps1"
#& "$utils\disable-scheduled-tasks.ps1"
#& "$utils\disable-ShellExperienceHost.bat"

Remove-Item $full -Recurse