#create hashtable out of log data
#read in the usage data table
Write-Host "Reading iis log"
$logFilePath = "D:\bla\RawData\Tables\iis-dir1-logs.txt"
$logTable = Import-Csv -Path $logFilePath -Delimiter ' '
#$logTable =  $tempLogTable | Where-Object { $_.'x-dir-transactionId' -ne "-" }
#$logTable | select -First 10

Write-Host "Reading Usage db"
$dbFilePath = "D:\bla\RawData\Tables\UsagePerformanceByGUIDLast7.csv"
$dbTable = Import-Csv -Path $dbFilePath

Write-Host "Reading the app GW log"
$AppGWFilePath = "D:\bla\RawData\Tables\ExtractdataPerformanceGW.csv"
$AppGWTable = Import-Csv -Path $AppGWFilePath
#$AppGWTable | select -first 2

Write-Host "Joining iis log and usage db"
$leftProperties = "Id","Date","UserName","Status:Barcode","Status:OCR","Status:Authenticate","Status:Images","Len(ms):Total","Len(ms):Barcode","Len(ms):OCR","Len(ms):Authenticate","Len(ms):Images"
$rightProperties = "date-utc","time-utc","date-local","time-local","s-ip","s-computername","cs-method","cs-uri-stem","cs-uri-query","s-port","cs-username","c-ip","cs(User-Agent)","sc-status","sc-substatus","time-taken-webServer","sc-bytes","cs-bytes","x-arr-log-id","x-dir-transactionId"
$firstJoined = Join-Object -left $dbTable -right $logTable -Where {$args[0].'Id' -eq $args[1].'x-dir-transactionId'} -LeftProperties $leftProperties -RightProperties $rightProperties -Type AllInBoth #OnlyIfInBoth

Write-Host "Writing first join output"
$firstJoined | select -first 2

Write-Host "Joining app gateway"
$leftProperties = "Id","Date","UserName","Status:Barcode","Status:OCR","Status:Authenticate","Status:Images","Len(ms):Total","Len(ms):Barcode","Len(ms):OCR","Len(ms):Authenticate","Len(ms):Images","date-utc","time-utc","date-local","time-local","s-ip","s-computername","cs-method","cs-uri-stem","cs-uri-query","s-port","cs-username","c-ip","cs(User-Agent)","sc-status","sc-substatus","time-taken-webServer","sc-bytes","cs-bytes","x-arr-log-id","x-dir-transactionId"
$rightProperties = "X-AzureApplicationGateway-LOG-ID","timeGMTStr","timeLocal","instanceId","clientIP","clientPort","httpMethod","requestUri","userAgent","httpStatus","httpVersion","receivedBytes","sentBytes","timeTaken","server-routed","server-status"
$secondJoined = Join-Object -left $firstJoined -right $AppGWTable -Where {$args[0].'x-arr-log-id' -eq $args[1].'X-AzureApplicationGateway-LOG-ID'} -LeftProperties $leftProperties -RightProperties $rightProperties -Type AllInBoth #OnlyIfInBoth

Write-Host "Writing last join output"
$secondJoined | select -first 2
$secondJoined | Export-Csv "D:\bla\RawData\Tables\FullStackLast7Days.csv"
