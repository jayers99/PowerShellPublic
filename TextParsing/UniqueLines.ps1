$filename = ""
$A = $(foreach ($line in Get-Content $filename) {$line.tolower().split(" ")}) | sort | Get-Unique
$A.count