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
    
    $full = "Debloater"
    DownloadAndExtractZip "https://sdi-tool.org/releases/SDI_R1790.zip" $full

    Write-Output "Debloating Windows. Second pass"
    
    & "$full\disable-windows-defender.ps1"

    Write-Output "Done Debloating. Removing Windows Debloating scripts."
    Remove-Item $full
}

pause