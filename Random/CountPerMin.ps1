$files = gci *.xml | Sort-Object LastWriteTime
$fileMinute = 0
$batchMinute = 0
$fileCount = 0


foreach ($file in $files)
{
	$fileMinute = ((Get-Item $file).LastWriteTime.Hour.ToString("00") + (Get-Item $file).LastWriteTime.Minute.ToString("00"))
	if ($fileMinute -ne $batchMinute)
	{
		if ($batchMinute -ne 0) {write ($batchMinute.ToString() + ", " + $fileCount)}
		#if ($batchMinute -ne 0) {write ($fileCount)}
		$batchMinute = $fileMinute
		$fileCount = 1
	}
	else
	{
		$fileCount ++
	}
}

