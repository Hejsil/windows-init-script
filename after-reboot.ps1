. $PSScriptRoot\common\funcs.ps1

if (!(IsAdmin))
{
    Write-Output "Run as admin"
    exit
}

# Debloat Windows. Second pass
& {
    Get-ChildItem -Recurse *.ps1 | Unblock-File
    Get-ChildItem -Recurse *.psm1 | Unblock-File
    Set-ExecutionPolicy Unrestricted

    $full = "$PSScriptRoot\Debloater"
    DownloadAndExtractZip "https://github.com/W4RH4WK/Debloat-Windows-10/archive/master.zip" "$full"

    Write-Output "Debloating Windows."
    
    $path = "$full\Debloat-Windows-10-master"
    $scripts = "$path\scripts"

    & "$scripts\disable-windows-defender.ps1"
}

pause