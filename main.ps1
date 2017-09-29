# Get the ID and security principal of the current user account
$myWindowsID=[System.Security.Principal.WindowsIdentity]::GetCurrent()
$myWindowsPrincipal=new-object System.Security.Principal.WindowsPrincipal($myWindowsID)

# Get the security principal for the Administrator role
$adminRole=[System.Security.Principal.WindowsBuiltInRole]::Administrator

# Check to see if we are currently running "as Administrator"
if (!$myWindowsPrincipal.IsInRole($adminRole))
{
    echo "Run as admin"
    exit
}

#########################################################################################
# Actual script                                                                         #
#########################################################################################

Add-Type -assembly "system.io.compression.filesystem"

function Download([string]$url, [string]$destination)
{
    Invoke-WebRequest -Uri $url -OutFile $destination
}

function DownloadAndExtractZip([string]$zip_url, [string]$destination)
{
    $temp_file = "$PSScriptRoot\tmp.zip"
    echo $temp_file

    Download $zip_url $temp_file
    [io.compression.zipfile]::ExtractToDirectory($temp_file, $destination)
    Remove-Item $temp_file
}

# Todo: https://github.com/lltcggie/waifu2x-caffe/releases/download/1.1.8.4/waifu2x-caffe.zip

# Debloat Windows
& {
    ls -Recurse *.ps1 | Unblock-File
    ls -Recurse *.psm1 | Unblock-File
    Set-ExecutionPolicy Unrestricted

    $full = "Debloater"
    DownloadAndExtractZip "https://github.com/W4RH4WK/Debloat-Windows-10/archive/master.zip" "$PSScriptRoot\$full"

    echo "Debloating Windows."
    
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

    echo "Use Snappy Driver to install all the drivers you need."
    echo "This script will continue when you close Snappy Drivers."

    & "$PSScriptRoot\$full\${name}_x64_$version.exe" | Out-Null
}

msiexec.exe /i https://stable.just-install.it

# TODO: How to get newest version?
$exes = @(
    # Discord
    "https://discordapp.com/api/download?platform=win",
    # Mega
    "https://mega.nz/MEGAsyncSetup.exe",
    # Steam
    "https://steamcdn-a.akamaihd.net/client/installer/SteamSetup.exe",
    # Google Chrome
    "https://dl.google.com/tag/s/appguid%3D%7B8A69D345-D564-463C-AFF1-A69D9E530F96%7D%26iid%3D%7B0719C32B-B43C-7352-7D99-9EFB82A9ADBE%7D%26lang%3Den%26browser%3D5%26usagestats%3D0%26appname%3DGoogle%2520Chrome%26needsadmin%3Dprefers%26ap%3Dx64-stable-statsdef_1%26installdataindex%3Ddefaultbrowser/update2/installers/ChromeSetup.exe",
    # Visual Studio Code
    "https://go.microsoft.com/fwlink/?Linkid=852157",
    # Jetbrains Toolbox
    "https://download.jetbrains.com/toolbox/jetbrains-toolbox-1.4.2492.exe",
    #Battlenet
    "https://www.battle.net/download/getInstallerForGame?os=win&locale=enGB&version=LIVE&gameProgram=BATTLENET_APP",
    # 7zip
    "http://www.7-zip.org/a/7z1604-x64.exe",
    # Lock Hunter
    "http://lockhunter.com/exe/lockhuntersetup_3-2-3.exe"
    # Gimp
    "https://download.gimp.org/mirror/pub/gimp/v2.8/windows/gimp-2.8.22-setup.exe"
    # Image Glass
    "https://github.com/d2phap/ImageGlass/releases/download/4.1.7.26/ImageGlass_4.1.7.26.exe"
    # Git
    "https://github.com/git-for-windows/git/releases/download/v2.14.1.windows.1/Git-2.14.1-64-bit.exe"
    # Microsoft Visual C++ Redistributable for Visual Studio 2017
    "https://go.microsoft.com/fwlink/?LinkId=746572"
    # Build Tools for Visual Studio 2017
    "https://www.visualstudio.com/thank-you-downloading-visual-studio/?sku=BuildTools&rel=15"
    # .NET Framework
    "https://www.microsoft.com/net"
    # Thunder Bird
    "https://download.mozilla.org/?product=thunderbird-52.3.0-SSL&os=win&lang=da"
    # Virtual box
    "http://download.virtualbox.org/virtualbox/5.1.28/VirtualBox-5.1.28-117968-Win.exe"
)

# Install software with a setup.exe
foreach ($exe in $exes) {
    $secs = (Get-Date).Ticks
    $tmp = "Temp$secs.exe"

    Download $exe "$PSScriptRoot\$tmp"
    & "$PSScriptRoot\$tmp" | Out-Null
}

# Create AppModelUnlock if it doesn't exist, required for enabling Developer Mode
$RegistryKeyPath = "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\AppModelUnlock"
if (-not(Test-Path -Path $RegistryKeyPath)) {
    New-Item -Path $RegistryKeyPath -ItemType Directory -Force
}

# Add registry value to enable Developer Mode
New-ItemProperty -Path $RegistryKeyPath -Name AllowDevelopmentWithoutDevLicense -PropertyType DWORD -Value 1

Enable-WindowsOptionalFeature -Online -FeatureName Microsoft-Windows-Subsystem-Linux
pause