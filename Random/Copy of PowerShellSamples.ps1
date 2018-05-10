HELP
get-alias | where-object {$_.definition -like "*path*"}
get-command | where-object {$_.name -like "*path*"}






$twodaysago = (get-date).addDays(-2).tostring("yyyyMMdd")
get-childitem -filter *$twodaysago*.trn

does not work - get-childitem -filter {"*" + (get-date).addDays(-3).tostring("yyyyMMdd") + "*.trn"}


Remove-Item *$twodaysago*.trn


works -
get-childitem *.trn | where-object {$_.name -ne "*" + (get-date).addDays(-2).tostring("yyyyMMdd") + "*.trn"} | remove-item

get-childitem *.trn | where-object {$_.name -notlike "Core_backup_" + (get-date).addDays(0).tostring("yyyyMMdd") + "*.trn" -or $_.name -notlike "Core_backup_" + (get-date).addDays(-1).tostring("yyyyMMdd") + "*.trn" -or $_.name -notlike "Core_backup_" + (get-date).addDays(-2).tostring("yyyyMMdd") + "*.trn" }



*** the one
get-childitem *.bak | where-object {$_.name -like "*" + (get-date).addDays(-8).tostring("yyyyMMdd") + "*" -or $_.name -like "*" + (get-date).addDays(-9).tostring("yyyyMMdd") + "*" -or $_.name -like "*" + (get-date).addDays(-10).tostring("yyyyMMdd") + "*" -or $_.name -like "*" + (get-date).addDays(-11).tostring("yyyyMMdd") + "*" -or $_.name -like "*" + (get-date).addDays(-12).tostring("yyyyMMdd") + "*" -or $_.name -like "*" + (get-date).addDays(-13).tostring("yyyyMMdd") + "*"} | remove-item


*************nested loop
foreach ($1 in '1','2','3','4') {
  foreach ($2 in 'a','b','c') {
    write-host $1 $2
}}

function Pause ($Message="Press any key to continue...")
{
Write-Host -NoNewLine $Message
$null = $Host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")
Write-Host ""
}
pause

*************************************************************************
Core Backup Clean Up
*************************************************************************
get-childitem \\server\h$\serverBackup\Core\*.trn | where-object {$_.name -notlike "*" + (get-date).addDays(0).tostring("yyyyMMdd") + "*" -and $_.name -notlike "*" + (get-date).addDays(-1).tostring("yyyyMMdd") + "*" -and $_.name -notlike "*" + (get-date).addDays(-2).tostring("yyyyMMdd") + "*"} | remove-item


$WeeksBack = 0
$DayOffSet = get-date -uformat %u
$dayBack = 8..13

for ($1=0; $1 -lt $dayBack.length; $1++){
    $dayBack[$1] = $dayBack[$1] + $dayOffset + ($weeksBack * 7)
    #write-host $dayback[$1]
}


foreach ($2 in $dayBack){
    get-childitem \\server\h$\serverBackup\Core\*.bak | where-object {$_.name -like "*" + (get-date).addDays(-$2).tostring("yyyyMMdd") + "*"}
}


foreach ($2 in $dayBack){
    get-childitem \\server\h$\serverBackup\Core\*.bak | where-object {$_.name -like "*" + (get-date).addDays(-$2).tostring("yyyyMMdd") + "*"} | remove-item
}

*************************************************************************
*************************************************************************

gci | Where-Object {$_.PSIsContainer -eq $True} | where-object {$_.GetFiles().Count -gt 2} | copy-item -destination c:\temp\steve -recurse


get-alias by definition
get-alias | where-object {$_.Definition -match "Get-Childitem"}


gci | Where-Object {$_.PSIsContainer -eq $True} | gm -name getfiles | select definition | format-table -wrap


*************************************************************************
Nik annotation xml stuff
*************************************************************************
gci "*.xml" | %{ [xml] (gc $_) } | %{ $_.annotations.ethnicity.id}
gci "*.xml" | %{ [xml] (gc $_) } | %{ $_.annotations.ethnicity.image}
gci "*.xml" | %{ [xml] (gc $_) } | %{ $_.annotations.image.split("\")[$_.annotations.image.split("\").length-1] }
gci "*.xml" | %{ [xml] (gc $_) } | %{ [regex]::replace($_.annotations.image, "^.*\\", "") }
gci "*.xml" | %{ [xml] (gc $_) } | %{ split-path $_.annotations.image -leaf }



gci "*.xml" | %{ [xml] (gc $_) } | %{ copy $_.annotations.image $_.annotations.ethnicity.id}
gci "*.xml" | %{ [xml] (gc $_) } | %{ copy [regex]::replace($_.annotations.image, "^.*\\", "") $_.annotations.ethnicity.id}
gci "*.xml" | %{ [xml] (gc $_) } | %{ xcopy (split-path $_.annotations.image -leaf) $_.annotations.ethnicity.id}


*************************************************************************
*************************************************************************



