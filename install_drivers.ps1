. "$PSScriptRoot\common\funcs.ps1"

$name = "SDI"
$version = "R1790"
$full = "$PSScriptRoot\${name}_$version"

Write-Output "Downloading Snappy Driver version $version..."
DownloadAndExtractZip "https://sdi-tool.org/releases/SDI_R1790.zip" "$full"

Write-Output "Use Snappy Driver to install all the drivers you need."
Write-Output "This script will continue when you close Snappy Drivers."
& "$full\${name}_x64_$version.exe" | Out-Null

Write-Output "Removing Snappy Driver."
Remove-Item $full                   -Recurse
Remove-Item "$PSScriptRoot\logs"    -Recurse
Remove-Item "$PSScriptRoot\indexes" -Recurse
Remove-Item "$PSScriptRoot\drivers" -Recurse