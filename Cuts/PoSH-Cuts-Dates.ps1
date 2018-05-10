$currentDatetime = get-date
$currentDate = $currentDatetime.Date
$utcDateTime = $currentDate.ToUniversalTime()
$utcDateTime.ToString("yyyy-MM-dd HH:mm:ss.ffff")

$convertStringTodate = [datetime]"1/2/14"

#padded date parts
$utcDateTime.ToString("yyyy")
$utcDateTime.ToString("MM")
$utcDateTime.ToString("dd")
$utcDateTime.ToString("HH")
$utcDateTime.ToString("mm")

$fileDateToCopy = $fileDateToCopy.AddHours(-1)



$currentDatetime = get-date
$currentDate = $currentDatetime.Date

$thisMonth = [datetime]$currentDate.ToString("MM/01/yyyy")

$startDate = [datetime]"5/1/2014"
$endDate = $startDate.AddMonths(1)

do {
    $startDate.ToString("yyyy-MM")
    #$endDate.ToShortDateString()

    $startDate = $startDate.AddMonths(1)
    $endDate = $startDate.AddMonths(1)

}
while ($startDate -lt $thisMonth)
