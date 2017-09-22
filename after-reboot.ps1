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
ls -Recurse *.ps1 | Unblock-File
ls -Recurse *.psm1 | Unblock-File
Set-ExecutionPolicy Unrestricted

function Download([string]$url, [string]$destination)
{
    Invoke-WebRequest -Uri $url -OutFile $destination
}

function DownloadAndExtractZip([string]$zip_url, [string]$destination)
{
    $temp_file = ".\tmp.zip"

    Download $zip_url $temp_file
    [io.compression.zipfile]::ExtractToDirectory($temp_file, $destination)
    Remove-Item $temp_file
}

# Debloat Windows. Second pass
. {
    $full = "Debloater"
    DownloadAndExtractZip "https://sdi-tool.org/releases/SDI_R1790.zip" $full

    echo "Debloating Windows. Second pass"
    
    & "$full\disable-windows-defender.ps1"

    echo "Done Debloating. Removing Windows Debloating scripts."
    Remove-Item $full
}

pause