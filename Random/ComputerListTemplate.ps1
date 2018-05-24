<#
.Synopsis
   Short description
.DESCRIPTION
   Long description
.EXAMPLE
   Example of how to use this cmdlet
.EXAMPLE
   Another example of how to use this cmdlet
#>

#Script Name
#Creator: John Ayers
#Date: 
#Updated: 
#References, if any

#Variables

#Parameters

#Enter Tasks Below as Remarks

param (
    [Parameter(Mandatory=$true)][string]$listpath
)

foreach ($Computer in get-content $listpath) 
{
	$Computer = $Computer.Trim()
	if ($Computer -eq "") {continue}
	if ($Computer -like "\\*")
	{
		$Computer = $Computer.TrimStart("\\")
	}
	
	#$Computer = $Computer + ".<domain>.com"

	$ServerName = $Computer.ToUpper()
    
#	$reply = Test-Connection -Computername $client -BufferSize 16 -Count 1 -Quiet
    
    if($reply.status -eq "True") 
	{
        Write-Host "============================================================================"
		Write-Host "$ServerName is online"
		
		#do something
		
		
    }
	else
	{
        Write-Host "$ServerName is not online - skipping"    
    }
}
