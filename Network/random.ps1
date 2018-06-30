# screw this powershell for dealing with network interfaces sucks








   Autoconfiguration Enabled . . . . : Yes
   Link-local IPv6 Address . . . . . : fe80::700e:1406:344e:2335%5(Preferred) 
   IPv4 Address. . . . . . . . . . . : 10.101.0.90(Preferred) 
   Subnet Mask . . . . . . . . . . . : 255.255.255.0
   Lease Obtained. . . . . . . . . . : Tuesday, June 12, 2018 5:32:44 PM
   Lease Expires . . . . . . . . . . : Saturday, June 16, 2018 12:11:19 PM
   Default Gateway . . . . . . . . . : 10.101.0.1
   DHCP Server . . . . . . . . . . . : 10.101.0.1
   DHCPv6 IAID . . . . . . . . . . . : 77107350
   DHCPv6 Client DUID. . . . . . . . : 00-01-00-01-22-A3-82-B3-98-90-96-A3-0B-37
   DNS Servers . . . . . . . . . . . : 10.101.0.1
                                       10.101.0.1
   Primary WINS Server . . . . . . . : 10.101.0.1
   NetBIOS over Tcpip. . . . . . . . : Enabled




#get the interface i want
$adapter = Get-NetAdapter -Name 'Ethernet'
$adapter


Get-NetIPAddress -AddressFamily IPv4 -InterfaceAlias 'Ethernet' | Get-Member

(Get-NetIPAddress -AddressFamily IPv4 -InterfaceAlias 'Ethernet').IPAddress
(Get-NetIPAddress -AddressFamily IPv4 -InterfaceAlias 'Ethernet').SubnetMask



Get-NetIPConfiguration | Get-Member
(Get-NetIPConfiguration -InterfaceAlias Ethernet).DNSServer.ServerAddresses


Get-NetIPInterface -AddressFamily IPv4 -InterfaceAlias Ethernet



# all my stuff
(Get-NetIPAddress -AddressFamily IPv4 -InterfaceAlias 'Ethernet').IPAddress
(Get-NetIPAddress -AddressFamily IPv4 -InterfaceAlias 'Ethernet').SubnetMask
(Get-NetRoute -AddressFamily IPv4 -DestinationPrefix "0.0.0.0/0").NextHop
(Get-NetIPConfiguration -InterfaceAlias Ethernet).DNSServer.ServerAddresses


$nic_configuration = gwmi -computer .  -class "win32_networkadapterconfiguration" | Where-Object {$_.defaultIPGateway -ne $null}
$IP = $nic_configuration.ip
write-output " IP Address : $IP"

$MAC_Address = $nic_configuration.MACAddress
write-output " MAC Address :  $MAC_Address"

$SubnetMask = $nic_configuration.ipsubnet

Get-WmiObject Win32_NetworkAdapterConfiguration | 
   Where IPEnabled | 
   Select IPSubnet, DNSServerSearchOrder, IpAddress

$params = @{
  "ComputerName" = "."
  "Class" = "Win32_NetworkAdapterConfiguration"
  "Filter" = "IPEnabled=TRUE"
}
$netConfigs = Get-WMIObject @params
foreach ( $netConfig in $netConfigs ) {
  for ( $i = 0; $i -lt $netConfig.IPAddress.Count; $i++ ) {
    if ( $netConfig.IPAddress[$i] -match '(\d{1,3}\.){3}\d{1,3}' ) {
  $ipString = $netConfig.IPAddress[$i]
  $ip = [IPAddress] $ipString
  $maskString = $netConfig.IPSubnet[$i]
  $mask = [IPAddress] $maskString
  $netID = [IPAddress] ($ip.Address -band $mask.Address)
  "IP address: {0}" -f $ip.IPAddressToString
  "Subnet mask: {0}" -f $mask.IPAddressToString
  "Network ID: {0}" -f $netID.IPAddressToString
    }
  }
}