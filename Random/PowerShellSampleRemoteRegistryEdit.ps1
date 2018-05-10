$strComputers = "kgambini"
$reg = [Microsoft.Win32.RegistryKey]::OpenRemoteBaseKey('LocalMachine', $strComputer)
$key="SYSTEM\CurrentControlSet\Services\SharedAccess\Parameters\FirewallPolicy\DomainProfile"
$regKey = $reg.OpenSubKey($key)
$EnableFirewallValue = $regkey.GetValue("EnableFirewall")
$EnableFirewallValue

$regKey = $reg.OpenSubKey($key, $True)
$regkey.SetValue("EnableFirewall", 0)

$EnableFirewallValue = $regkey.GetValue("EnableFirewall")
$EnableFirewallValue