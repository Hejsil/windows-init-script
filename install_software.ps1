msiexec.exe /i https://stable.just-install.it | Out-Null
Set-ExecutionPolicy Bypass; Invoke-Expression ((New-Object System.Net.WebClient).DownloadString("https://chocolatey.org/install.ps1"))

$software = @(
    "7zip"
    "audacity"
    "battlenet"
    "cmake"
    "qbittorrent"
    "discord"
    "everything-search"
    "flux"
    "gimp"
    "git"
    "google-chrome"
    "imageglass"
    "inkscape"
    "jetbrains-toolbox"
    "obs-studio"
    "sharex"
    "spotify"
    "steam"
    "foobar2000"
    "mpv"
    "cs-script"
    "openhardwaremonitor"
    "bulkrenameutility.install"
)

foreach ($item in $software) {
    Write-Output "Installing $item through just-install."
    if (!(just-install $item)) {
        Write-Output "Could not install $item through just-install."
        Write-Output "Installing $item through choco."
        if (!(choco install $item -y)) {
            Write-Output "Could not install $item."
        }
    }
}