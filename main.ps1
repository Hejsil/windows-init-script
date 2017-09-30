. $PSScriptRoot\common\funcs.ps1

if (!(IsAdmin) )
{
    Write-Output "Run as admin"
    exit
}

& {
    # We select the drive with most space
    $drives = Get-PSDrive -PSProvider "FileSystem"
    $roots = $drives.Root

    # Root will be array if there are more than one
    if ($roots.GetType() -eq [string]) {
        $root = $roots
    } else {
        $free = $drives.Free
        $i = 0
        $max = $free[$i]
        $index = $i
        foreach ($v in $free) {
            if ($v -gt $max) {
                $max = $v
                $index = $i
            }
            
            $i += 1
        }
        
        $root = $roots[$index]
    }

    # And move all our personal folders to this drive
    Set-KnownFolderPath -KnownFolder "Contacts"    -Path "$($root)Mega\Contacts"
    Set-KnownFolderPath -KnownFolder "Desktop"     -Path "$($root)Mega\Desktop"
    Set-KnownFolderPath -KnownFolder "Documents"   -Path "$($root)Mega\Documents"
    Set-KnownFolderPath -KnownFolder "Downloads"   -Path "$($root)" # I don"t want my download folder in my mega
    Set-KnownFolderPath -KnownFolder "Favorites"   -Path "$($root)Mega\Favorites"
    Set-KnownFolderPath -KnownFolder "Links"       -Path "$($root)Mega\Links"
    Set-KnownFolderPath -KnownFolder "Music"       -Path "$($root)Mega\Music"
    Set-KnownFolderPath -KnownFolder "Pictures"    -Path "$($root)Mega\Pictures"
    Set-KnownFolderPath -KnownFolder "SavedGames"  -Path "$($root)Mega\SavedGames"
    Set-KnownFolderPath -KnownFolder "SEARCH_CSC"  -Path "$($root)Mega\SEARCH_CSC"
    Set-KnownFolderPath -KnownFolder "SEARCH_MAPI" -Path "$($root)Mega\SEARCH_MAPI"
    Set-KnownFolderPath -KnownFolder "SearchHome"  -Path "$($root)Mega\SearchHome"
    Set-KnownFolderPath -KnownFolder "Videos"      -Path "$($root)Mega\Videos"
}

# Todo: https://github.com/lltcggie/waifu2x-caffe/releases/download/1.1.8.4/waifu2x-caffe.zip

# Debloat Windows
& {
    Get-ChildItem -Recurse *.ps1 | Unblock-File
    Get-ChildItem -Recurse *.psm1 | Unblock-File
    Set-ExecutionPolicy Unrestricted

    $full = "Debloater"
    DownloadAndExtractZip "https://github.com/W4RH4WK/Debloat-Windows-10/archive/master.zip" "$PSScriptRoot\$full"

    Write-Output "Debloating Windows."
    
    $path = "$PSScriptRoot\$full\Debloat-Windows-10-master"
    $scripts = "$path\scripts"
    $utils = "$path\utils"

    & "$scripts\block-telemetry.ps1"
    & "$scripts\disable-services.ps1"
    & "$scripts\disable-windows-defender.ps1"
    & "$scripts\experimental_unfuckery.ps1"
    & "$scripts\fix-privacy-settings.ps1"
    & "$scripts\optimize-user-interface.ps1"
    & "$scripts\optimize-windows-update.ps1"
    & "$scripts\remove-default-apps.ps1"
    & "$scripts\remove-onedrive.ps1"
    & "$utils\enable-god-mode.ps1"
    & "$utils\disable-scheduled-tasks.ps1"
    & "$utils\disable-ShellExperienceHost.bat"
}

# Install Drivers with Snappy Drivers
& {
    $name = "SDI"
    $version = "R1790"
    $full = "${name}_$version"
    DownloadAndExtractZip "https://sdi-tool.org/releases/SDI_R1790.zip" "$PSScriptRoot\$full"

    Write-Output "Use Snappy Driver to install all the drivers you need."
    Write-Output "This script will continue when you close Snappy Drivers."

    & "$PSScriptRoot\$full\${name}_x64_$version.exe" | Out-Null
}

msiexec.exe /i https://stable.just-install.it | Out-Null

just-install 7zip
just-install audacity
just-install autohotkey
just-install battlenet
just-install bcuninstaller
just-install ccleaner
just-install cmake
just-install deluge
just-install discord
just-install everything-search
just-install flux
just-install geforce-experience
just-install gimp
just-install git
just-install google-chrome
just-install handbrake
just-install imageglass
just-install inkscape
just-install jetbrains-toolbox
just-install lockhunter
just-install obs-studio
just-install origin
just-install python27
just-install sharex
just-install spotify
just-install steam
just-install thunderbird
just-install virtualbox
just-install virtualbox-extpack
# just-install visual-studio-code
just-install windirstat

Set-ExecutionPolicy Bypass; Invoke-Expression ((New-Object System.Net.WebClient).DownloadString("https://chocolatey.org/install.ps1"))

choco install wget
choco install gnuwin
choco install foobar2000
choco install rufus
choco install mpv
choco install cs-script
choco install graphviz.portable
choco install gnucash
choco install openhardwaremonitor
choco install bulkrenameutility.install
choco install scriptcs

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
    $tmp = "Temp$secs.exe"

    Download $exe "$PSScriptRoot\$tmp"
    & "$PSScriptRoot\$tmp" | Out-Null
}

# Create AppModelUnlock if it doesn"t exist, required for enabling Developer Mode
$RegistryKeyPath = "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\AppModelUnlock"
if (-not(Test-Path -Path $RegistryKeyPath)) {
    New-Item -Path $RegistryKeyPath -ItemType Directory -Force
}

# Add registry value to enable Developer Mode
New-ItemProperty -Path $RegistryKeyPath -Name AllowDevelopmentWithoutDevLicense -PropertyType DWORD -Value 1

Enable-WindowsOptionalFeature -Online -FeatureName Microsoft-Windows-Subsystem-Linux
pause