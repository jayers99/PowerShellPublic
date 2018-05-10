#what providers are avail
Get-PSProvider

#Filesystem
new-psdrive -name PoSH -PSProvider "filesystem" -Root "d:\dropbox\code\posh" -Description "PowerShell Scripts"
new-psdrive -name Group -PSProvider "filesystem" -Root "\\dirfs1\Group" -Description "Group Drive"

#Env
$Env:Path

#Certificates
cd cert:

