. "$PSScriptRoot\common\funcs.ps1"

$link = "https://github.com/sampalmer/set-default-browser/releases/download/1.2.1/SetDefaultBrowser.1.2.1.zip"
$path = "$PSScriptRoot\set_browser"

DownloadAndExtractZip "$link" "$path"
& "$path\SetDefaultBrowser.exe" "Google Chrome" | Out-Null
Remove-Item $path -Recurse