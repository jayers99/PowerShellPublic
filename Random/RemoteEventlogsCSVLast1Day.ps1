$lognames = "system", "application"
$date = Get-Date
$dateBack = $date.AddDays(-1)

foreach ($logname in $lognames)
{
	Get-EventLog -After $dateBack -LogName $logname -EntryType warning, error | select timegenerated, machinename, entrytype, source, EventID, message | Export-Csv \\dcont01\group\batch\csv\$computer.$logname.1days.csv
}
