$colProfileList = gci "C:\Documents and Settings"
foreach ($profile in $colProfileList)
{
	if ($colExemptProfileList -notcontains $profile)
	{
		$profile
		(Get-Content "\\dcont01\group\Operations\Batch\RegFiles\IEZonesHigh.reg") | 
			Foreach-Object {$_ -replace "%%ProfileSID%%", $profile} | 
			Set-Content "\\dcont01\group\Operations\Batch\RegFiles\temp\IEZonesHigh_$profile.reg"
		regedit /s "\\dcont01\group\Operations\Batch\RegFiles\temp\IEZonesHigh_$profile.reg"
	}
}
