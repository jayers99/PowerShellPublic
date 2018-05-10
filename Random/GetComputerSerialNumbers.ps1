# get the serial number for a list of computers

$ErrorActionPreference = "silentlycontinue"

foreach ($Computer in get-content d:\batch\lists\ComputerList.txt) 
{
	$ComputerSerial = $null
	$Computer = $Computer.Trim()
	if ($Computer -eq "") {continue}
	if ($Computer -like "\\*")
	{
		$Computer = $Computer.TrimStart("\\")
	}	

	$ServerName = $Computer.ToUpper()
    
    $ping = new-object System.Net.NetworkInformation.Ping
    $Reply = $ping.send($Computer)
    
    if($Reply.status -eq "success") 
	{
		$ComputerSerial = gwmi -ComputerName $Computer win32_SystemEnclosure -property "SerialNumber" |
			Select-Object -expand SerialNumber
		trap
		{
			Write-Host "Error Getting"
		}
		Write-Host $Computer "`t" $ComputerSerial
    }
	
	else
	{
        Write-Host "$ServerName is not online - skipping"    
    }
}