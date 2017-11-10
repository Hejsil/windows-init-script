. "$PSScriptRoot\common\funcs.ps1"

$extensions = @(
    "ms-vscode.cpptools"
    "ms-vscode.csharp"
    "ms-vscode.PowerShell"
    "twxs.cmake"
    "IBM.output-colorizer"
    "tiehuis.zig"
)

DownLoadAndRunExe "https://go.microsoft.com/fwlink/?Linkid=852157"

foreach ($ext in $extensions) 
{
    code --install-extension $ext
} 