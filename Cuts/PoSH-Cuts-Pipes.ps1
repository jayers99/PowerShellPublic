#progress and user messages
#not writen the pipe
Write-Host

Write-Output

Get-Member

Get-Service | Where-Object {$_.Status -eq "Running"} | Sort-Object -Property Name | select DisplayName -First 10 | ConvertTo-Json

#subexpressions
Get-Service -ComputerName (Get-Content ".\Lists\All.txt")
Get-Service -ComputerName (Get-ADComputer -Filter * | where {$_.Enabled -eq $true})

#error pipes
Get-WmiObject win32_logicaldisk -ComputerName dcont07 2>err.txt 3>warn.txt 4>verbose.txt
#merge those pipes, but only to stream 1 the success stream
Get-WmiObject win32_logicaldisk -ComputerName dcont07 2>&1 3>errors.txt 4>verbose.txt

#foreach .... it does not write to the pipeline
$computers = Get-ADComputer -Filter * | where {$_.Enabled -eq $true}
foreach ($computer in $computers) {
    $computer.name
}