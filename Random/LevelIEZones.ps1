$colProfileList = gci "hklm:\Software\Microsoft\Windows NT\CurrentVersion\ProfileList" | %{$_.PSChildName}
$colExemptProfileList = "S-1-5-18", "S-1-5-19", "S-1-5-20"
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
