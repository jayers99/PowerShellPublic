#demo PowerShell script and Test-WSMan

#region Test-WSMan

help test-wsman

#test locally
test-wsman

test-wsman -ComputerName chi-dc04

test-wsman -computerName chi-dc04 -Authentication Defa
ult

#v2
test-wsman chi-dc02

#failure
test-wsman chi-core02

get-service winrm -computername chi-core02

#but can ping
ping chi-core02

#endregion


#region GPO Script

get-content C:\scripts\ConfigurePSRemoting.ps1

gpmc.msc
dsa.msc

#restart and wait for script policy to apply
restart-computer chi-core02 -Force -Wait -For WinRM

test-wsman chi-core02 -Authentication Default

get-service winrm -computername chi-core02

cls

#endregion

