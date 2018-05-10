#get logs n number of days back
$daysBack = 7
$machineListPath = "C:\Batch\Lists\All10"
$tempFilePath = "C:\Batch\WebLogs\ExtractdataPerformanceWSTemp.txt"
$outputFilePath = "C:\Batch\WebLogs\ExtractdataPerformanceWS.txt"

$currentDate = get-date
$utcDateTime = $currentDate.ToUniversalTime()
#$utcDateTime.ToString("yyyy-MM-dd")

if (Test-Path $tempFilePath) { Remove-Item $tempFilePath }
if (Test-Path $outputFilePath) { Remove-Item $outputFilePath }

Get-ChildItem $machineListPath |
ForEach-Object {
    Write-Host ("CurrentHost: {0}" -f $_.BaseName)
    For ($i=0; $i -le $daysBack; $i++) {
        $logDate = $utcDateTime.AddDays(-$i)
        $fileNameDatePart = $logDate.ToString("yyyy") + $logDate.ToString("MM") + $logDate.ToString("dd")
        #$fileNameDatePart
        $filePath = "\\" + $_.BaseName + "\C$\inetpub\logs\AdvancedLogs\iis-dir1-" + $_.BaseName + "_D" + $fileNameDatePart + "*.log"
        if (Test-Path $filePath) {
            Write-Host ("       File: {0}" -f $filePath)
            Get-Content $filePath | 
            Select-String "/bla.webapi/api/extractdata" |
            Add-Content $tempFilePath
            }
        }
    }

Add-Content $outputFilePath "date-utc time-utc date-local time-local s-ip s-computername cs-method cs-uri-stem cs-uri-query s-port cs-username c-ip cs(User-Agent) sc-status sc-substatus time-taken-webServer sc-bytes cs-bytes x-arr-log-id x-dir-transactionId"
Add-Content $outputFilePath (Get-Content -Path $tempFilePath | Sort-Object -Descending)
del $tempFilePath
copy-Item -Path $outputFilePath -Destination \\tsclient\D\Temp\AppGWLogs -Force