msiexec.exe /i https://stable.just-install.it | Out-Null
Set-ExecutionPolicy Bypass; Invoke-Expression ((New-Object System.Net.WebClient).DownloadString("https://chocolatey.org/install.ps1"))

$software = @(
    "7zip"
    "audacity"
    "autohotkey"
    "battlenet"
    "bcuninstaller"
    "ccleaner"
    "cmake"
    "qbittorrent"
    "discord"
    "everything-search"
    "flux"
    "geforce-experience"
    "gimp"
    "git"
    "google-chrome"
    "handbrake"
    "imageglass"
    "inkscape"
    "jetbrains-toolbox"
    "lockhunter"
    "obs-studio"
    "origin"
    "python27"
    "sharex"
    "spotify"
    "steam"
    "thunderbird"
    "virtualbox"
    "virtualbox-extpack"
    "windirstat"
    "wget"
    "mingw"
    "foobar2000"
    "rufus"
    "mpv"
    "cs-script"
    "graphviz.portable"
    "gnucash"
    "openhardwaremonitor"
    "bulkrenameutility.install"
    "scriptcs"
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