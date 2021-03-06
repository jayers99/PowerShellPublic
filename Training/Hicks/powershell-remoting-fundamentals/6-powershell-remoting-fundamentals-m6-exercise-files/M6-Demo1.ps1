#demo using PSRemoting over SSL

#This is file of demo commands to run individually not a script to run start to finish. 

#region Requesting a cert from AD

#use the Certificate server from the server to be configured

# start https://chi-dc04.globomantics.local/certsrv/

#endregion

#region getting the cert

$computer = "chi-core01"

#get certificate thumbprint
$cert = invoke-command { dir cert:\localmachine\my | where {$_.EnhancedKeyUsageList -match "Server Authentication"} | select -first 1 } -computername $computer

$cert

#or use other non PowerShell means to get the certificate thumbprint

#get from AD
$ad = Get-ADComputer $computer -property Certificates
$ad.Certificates
#get thumbprint
$ad.Certificates.GetCertHashString()

#endregion

#region configure WSMan

#need to create an entirely new listener
Connect-WSMan -ComputerName $computer
dir WSMan:\$computer\Listener\L* -Recurse

#provider help won't display properly with ShowWindow
#so copy to clipboard and paste in a new tab
#search for HTTPS
help wsman | clip

get-command -noun wsman*

help Get-WSManInstance -ShowWindow  #see Example 5

#not case-sensitive
Get-WSManInstance -resourceuri winrm/config/listener -selectorset @{address="*";transport="HTTP"} -ComputerName $computer

#doesn't exist
Get-WSManInstance -resourceuri winrm/config/listener -selectorset @{address="*";transport="HTTPS"} -ComputerName $computer

help New-WSManInstance -ShowWindow  #see Example 1
 
#resolve the DNS name to get IP
#if multi-homed you'll need to decide what IP address to use configure 
#a listener accordingly
$dns = Resolve-DnsName -Name $computer -TcpOnly

#hashtable of settings for the new instance
$settings =  @{
Address = $dns.IPAddress
Transport = "HTTPS"
CertificateThumbprint = $cert.Thumbprint
Enabled = "True"
Hostname = $cert.DnsNameList.unicode
} 

#review new settings
$settings

#define a hashtable of parameters to spalt to New-WSManInstance
$newParams = @{
resourceuri = 'winrm/config/listener'
selectorset = @{Address="*";Transport="HTTPS"} 
ValueSet = $settings 
ComputerName = $computer
}

#verify
$newParams
$newParams.selectorset

#create the new instance
New-WSManInstance @newParams

#verify
#we can re-use same parameter by removing ValueSet
$newParams.Remove("ValueSet")
Get-WSManInstance @newparams

#verify the change in WSMan
dir WSMan:\chi-core01\Listener\L* -Recurse

Disconnect-WSMan -ComputerName $computer

# To Remove it 
# Remove-WSManInstance -resourceuri winrm/config/listener -selectorset @{address="*";transport="https"} -ComputerName $computer

#endregion

#region Configure the firewall to allow HTTPS

#list current rules
get-netfirewallrule -name WINRM-HTTP* -CimSession $computer | 
Select PSComputername,Name,Description,Profile,Enabled

$rule = get-netfirewallrule -name WINRM-HTTP-In* -CimSession $computer | 
where { $_.profile -match "domain"}

$rule

help New-NetFirewallRule

$paramHash = @{
 Name = $rule.name.replace("HTTP","HTTPS") DisplayName = $rule.displayname.replace("HTTP","HTTPS") Enabled = "True" Profile = $rule.profile PolicyStore = $rule.policystoreSource Direction = 'Inbound' Action = 'Allow' Description = $rule.description.replace("5985","5986") LocalPort = 5986 Protocol = 'TCP' CimSession = $computer}

New-NetFirewallRule @paramHash

#Group Policy is better choice for managing firewalls

# remove the rule to reset the demo
# get-netfirewallrule Winrm-https* -CimSession $computer | Remove-NetFirewallRule -whatif


#endregion

#region Using remoting with SSL

test-wsman -ComputerName chi-core01 -UseSSL

test-wsman -ComputerName chi-core01.globomantics.local -UseSSL

invoke-command { dir c:\ -Hidden } -computer chi-core01.globomantics.local -UseSSL

Enter-PSSession chi-core01.globomantics.local -UseSSL
#look at connections
netstat
exit

#endregion
