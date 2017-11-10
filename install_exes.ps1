. "$PSScriptRoot\common\funcs.ps1"

# TODO: https://gallery.technet.microsoft.com/scriptcenter/Script-to-add-an-item-to-f523f1f3/file/75298/1/AddItemToContext.zip
# TODO: https://github.com/lltcggie/waifu2x-caffe/releases/download/1.1.8.4/waifu2x-caffe.zip
# TODO: How to get newest version?
$exes = @(
    # Mega
    "https://mega.nz/MEGAsyncSetup.exe"
)

# Install software with a setup.exe
foreach ($exe in $exes) 
{
    DownLoadAndRunExe $exe
}