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
& "$PSScriptRoot\enable_developer_mode.ps1"

# TODO: https://gallery.technet.microsoft.com/scriptcenter/Script-to-add-an-item-to-f523f1f3/file/75298/1/AddItemToContext.zip
# TODO: https://github.com/lltcggie/waifu2x-caffe/releases/download/1.1.8.4/waifu2x-caffe.zip

# Install other software with installers
& {
    # TODO: How to get newest version?
    $exes = @(
        # Mega
        "https://mega.nz/MEGAsyncSetup.exe"
        # vs-code - It exists as a package, but we want to be able to set the options provided by the installer
        "https://go.microsoft.com/fwlink/?Linkid=852157"
    )
    
    # Install software with a setup.exe
    foreach ($exe in $exes) {
        $secs = (Get-Date).Ticks
        $tmp = "$PSScriptRoot\$secs.exe"
    
        Download $exe $tmp
        & $tmp | Out-Null
        
        Remove-Item $tmp -Recurse
    }
}


Set-WinUserLanguageList da
Enable-WindowsOptionalFeature -Online -FeatureName Microsoft-Windows-Subsystem-Linux