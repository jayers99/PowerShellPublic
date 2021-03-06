#demo 1 to many

#region one command for many servers

#define a group of computer names
$computers = "chi-core01","chi-core02","chi-web02","chi-fp02","chi-hvr2"

#icm is an alias for Invoke-Command
icm { get-ciminstance win32_operatingsystem } -ComputerName $computers | select PSComputername,Caption,InstallDate | format-list

#can run non-PowerShell commands
icm { tzutil /g } -computername chi-fp02
#challenges with multiple computers
icm { tzutil /g } -ComputerName $computers
#create an object
icm { [pscustomobject]@{"TimeZone"= (tzutil /g)} } -ComputerName $computers

#you can hide computername and runspace
icm { [pscustomobject]@{"TimeZone"= (tzutil /g)} } -ComputerName $computers | Select * -exclude runspaceid

#using local variables
$log = "System"
icm { get-eventlog $log -Newest 5} -computername $computers

help about_remote_variables -ShowWindow

::
icm { get-eventlog $using:log -Newest 5} -computername $computers | 
Format-Table -Group PSComputername -property TimeWritten,Source,Message
::

#or using parameters in the scriptblock
$sb = {param($log,$count) Get-eventlog $log -Newest $count }

#parameters are positional
#need to specify all parameters or set defaults in the scriptblock
icm $sb -computername $computers -ArgumentList "Security",1 | Select Message,PSComputername

#using scripts
get-content S:\Get-DriveUtilization.ps1
#test locally
S:\Get-DriveUtilization.ps1
icm -FilePath S:\Get-DriveUtilization.ps1 -computername $computers -HideComputerName | Select * -ExcludeProperty RunspaceID

cls

#endregion


