. "$PSScriptRoot\common\funcs.ps1"

Write-Output "Finding biggest drive..."
$root = GetBiggestDrive

Write-Output "Biggest driver was: $root."
Write-Output "Moving all user folders to $root..."

Set-KnownFolderPath -KnownFolder "Contacts"    -Path "$($root)Mega\Contacts"
Set-KnownFolderPath -KnownFolder "Desktop"     -Path "$($root)Mega\Desktop"
Set-KnownFolderPath -KnownFolder "Documents"   -Path "$($root)Mega\Documents"
Set-KnownFolderPath -KnownFolder "Downloads"   -Path "$($root)Download" # I don"t want my download folder in my mega
Set-KnownFolderPath -KnownFolder "Favorites"   -Path "$($root)Mega\Favorites"
Set-KnownFolderPath -KnownFolder "Links"       -Path "$($root)Mega\Links"
Set-KnownFolderPath -KnownFolder "Music"       -Path "$($root)Mega\Music"
Set-KnownFolderPath -KnownFolder "Pictures"    -Path "$($root)Mega\Pictures"
Set-KnownFolderPath -KnownFolder "SavedGames"  -Path "$($root)Mega\SavedGames"
Set-KnownFolderPath -KnownFolder "SEARCH_CSC"  -Path "$($root)Mega\SEARCH_CSC"
Set-KnownFolderPath -KnownFolder "SEARCH_MAPI" -Path "$($root)Mega\SEARCH_MAPI"
Set-KnownFolderPath -KnownFolder "SearchHome"  -Path "$($root)Mega\SearchHome"
Set-KnownFolderPath -KnownFolder "Videos"      -Path "$($root)Mega\Videos"