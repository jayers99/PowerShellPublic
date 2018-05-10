#
# Windows PowerShell in Action
#
# Chapter 12 Script to file contents from an MSI package.
#

param($msifile = $(throw "You must specify an MSI file to list"))

# We need to make sure the path is absolute
$msifile = resolve-path $msifile
 
$installer = new-object -com WindowsInstaller.Installer
$database = $installer.InvokeMethod("OpenDatabase",$msifile,0);
$view = $database.InvokeMethod("OpenView","Select FileName FROM File")
$view.InvokeMethod("Execute")
$r = $view.InvokeMethod("Fetch")
$r.InvokeParamProperty("StringData",1)
while($r -ne $null)
{
    $r = $view.InvokeMethod("Fetch")
    if( $r -ne $null)
    {
        $r.InvokeParamProperty("StringData",1)
    }
}
