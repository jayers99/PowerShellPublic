Get-ADComputer
Get-ADComputer -Filter * | where {$_.Enabled -eq $true} | select Name
$computers = Get-ADComputer -Filter * | where {$_.Enabled -eq $true}
