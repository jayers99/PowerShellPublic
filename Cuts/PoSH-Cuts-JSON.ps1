$json = Get-Content "D:\Temp\AppGWLogs\PT1Hcudproblem2.json"
$PowerShellRepresentation = $json | ConvertFrom-Json
$PowerShellRepresentation | select -expand records | select -expand properties
 | select time
$PowerShellRepresentation | select -expand records | select time, {$_.properties.clientIp}, {$_.properties.clientPort}, {$_.properties.ruleId}, {$_.properties.message} | export-csv "d:\temp\junk.csv"

#can't really get to export all the attributes
$jsonLog | select -expand records | Format-Table | export-csv "d:\temp\AppGWLogs\export.csv"


#to snap off trailing slash from url
$trailers = "/test/"
$trailers
$newString = $trailers
if ((!($trailers -eq "/") -and ($trailers.Substring(($trailers.Length-1), 1) -eq "/"))){
    $newString = $trailers.Substring(0,($trailers.Length-1))
    $newString
}else{
    $trailers
}


#Azure Application Gateway Access Logs
$csvFilePath = "D:\Temp\AppGWLogs\AppGWAccessLogsExport.csv"
$jsonLogFilesPath = "D:\Temp\AppGWLogs\insights-logs-applicationgatewayaccesslog\*.json"
if (Test-Path $csvFilePath) { Remove-Item  $csvFilePath }
gci $jsonLogFilesPath -recurse | 
ForEach-Object{
    Write-Host $_.FullName
    (Get-Content $_).replace('"clientPort":-', '"clientPort":"-"') |
    ConvertFrom-Json | 
    select -expand records |
    select `
         @{Label="time";Expression={$_.time}} `
        ,@{Label="clientIP";Expression={$_.properties.clientIP}} `
        ,@{Label="clientPort";Expression={$_.properties.clientPort}} `
        ,@{Label="httpMethod";Expression={$_.properties.httpMethod}} `
        ,@{Label="requestUri";Expression={$_.properties.requestUri.ToLower()}} `
        ,@{Label="userAgent";Expression={$_.properties.userAgent}} `
        ,@{Label="httpStatus";Expression={$_.properties.httpStatus}} `
        ,@{Label="httpVersion";Expression={$_.properties.httpVersion}} `
        ,@{Label="receivedBytes";Expression={$_.properties.receivedBytes}} `
        ,@{Label="sentBytes";Expression={$_.properties.sentBytes}} `
        ,@{Label="timeTaken";Expression={$_.properties.timeTaken}} `
        ,@{Label="requestQuery";Expression={$_.properties.requestQuery}}
} |
#where {$_.clientIP -eq "50.202.231.174"} | #bla only
#where {$_.time -ge "2017-02-01"} |
#where {$_.clientIP -in "206.80.14.200", "209.150.94.140"} | #cud only
Sort-Object time -Descending | export-csv $csvFilePath -Append -NoTypeInformation




#Azure Application Gateway Firewall Logs
$csvFilePath = "D:\Temp\AppGWLogs\AppGWFirewallLogsExport.csv"
$jsonLogFilesPath = "D:\Temp\AppGWLogs\insights-logs-applicationgatewayfirewalllog\*.json"
if (Test-Path $csvFilePath) { Remove-Item  $csvFilePath }
gci $jsonLogFilesPath -recurse |
ForEach-Object{
    Write-Host $_.FullName
    (Get-Content $_).replace('"clientPort":-', '"clientPort":"-"') |
    ConvertFrom-Json | 
    select -expand records |
    select `
         @{Label="time";Expression={$_.time}} `
        ,@{Label="clientIP";Expression={$_.properties.clientIP}} `
        ,@{Label="clientPort";Expression={$_.properties.clientPort}} `
        ,@{Label="requestUri";Expression={$_.properties.requestUri.ToLower()}} `
        ,@{Label="ruleId";Expression={$_.properties.ruleId}} `
        ,@{Label="message";Expression={$_.properties.message}} `
        ,@{Label="action";Expression={$_.properties.action}} `
        ,@{Label="detailsMessage";Expression={$_.properties.details.message}} `
        ,@{Label="detailsFile";Expression={$_.properties.details.file}}
} |
#where {$_.clientIP -eq "50.202.231.174"} | #bla only
#where {$_.time -ge "2017-02-01"} |
#where {$_.clientIP -in "206.80.14.200", "209.150.94.140"} | #cud only
Sort-Object time -Descending | export-csv $csvFilePath -Append -NoTypeInformation




gci "D:\Temp\AppGWLogs\rightnow3.json" |
ForEach-Object{
    $_.FullName
    (Get-Content $_).replace('"clientPort":-', '"clientPort":"-"') |
    ConvertFrom-Json | 
    select -expand records |
    where {$_.properties.clientIP -eq "50.202.231.174"} |
    select `
         @{Label="time";Expression={$_.time}} `
        ,@{Label="clientIP";Expression={$_.properties.clientIP}} `
        ,@{Label="clientPort";Expression={$_.properties.clientPort}} `
        ,@{Label="requestUri";Expression={$_.properties.requestUri.ToLower()}} `
        ,@{Label="httpStatus";Expression={$_.properties.httpStatus}} `
        ,@{Label="receivedBytes";Expression={$_.properties.receivedBytes}} `
        ,@{Label="sentBytes";Expression={$_.properties.sentBytes}} `
        ,@{Label="timeTaken";Expression={$_.properties.timeTaken}} `
        ,@{Label="requestQuery";Expression={$_.properties.requestQuery}} |
    Sort-Object time -Descending
}

#bla ip 50.202.231.174
#cud ip 206.80.14.200 or 209.150.94.140



#other appgw attributes



