HELP
get-alias | where-object {$_.definition -like "*path*"}
get-command | where-object {$_.name -like "*path*"}
# for line comment
/* block comment */

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

metadata.xml
[xml] (gc metadata.xml) | %{ $_.Fields.fields[0].TextField[6].value}
[xml] (gc metadata.xml) | %{ $_.Fields.fields[get.gettextfield].TextField[6].value}
[xml] (gc metadata.xml) | %{ $_.Fields.fields} | where { $_.Name -eq "Document" } | %{$_.TextField} | where { $_.Name -eq "IssuerCode"} | %{$_.Value}

*************************************************************************
stats report for _seized directories
*************************************************************************
foreach ($I in gci . | Where-Object {$_.PSIsContainer -eq $TRUE})
{
$sourceInstitution = 
$Document = gci $I\metadata.xml | %{ [xml] (gc $_) } | %{ $_.Fields.fields} | where { $_.Name -eq "Document" } | %{$_.TextField} | where { $_.Name -eq "Name"} | %{$_.Value}
#gci $I\metadata.xml | %{ [xml] (gc $_) } | %{ $_.Fields.Name}
$State = gci $I\metadata.xml | %{ [xml] (gc $_) } | %{ $_.Fields.fields} | where { $_.Name -eq "Document" } | %{$_.TextField} | where { $_.Name -eq "IssuerCode"} | %{$_.Value}
$Result = gci $I\metadata.xml | %{ [xml] (gc $_) } | %{ $_.Fields.fields} | where { $_.Name -eq "Document" } | %{$_.TextField} | where { $_.Name -eq "Result"} | %{$_.Value}
$otw = gci $I\storydata.xml | %{ [xml] (gc $_) } | %{ $_.collectionpoint.otwkey }

$line = $I.ToString() + "," + $otw + "," + $Document + "," + $State + "," + $Result
write-host $line
add-content -path .\results.csv -value ($line)
}
*************************************************************************
stats report for _seized directories version 2
*************************************************************************
#foreach ($I in gci . | Where-Object {$_.PSIsContainer -eq $TRUE})
#{
$I = "_seized20080827091531945"
$sourceXML = [xml] (gc %I\source.xml)
#$metaXML = [xml] (gc %I\metadata.xml)

$sourceInstitution = $sourceXML.source.institution
$sourceBatch = $sourceXML.source.batch
$sourceSubBatch = $sourceXML.source.subBatch

$Document = gci $I\metadata.xml | %{ [xml] (gc $_) } | %{ $_.Fields.fields} | where { $_.Name -eq "Document" } | %{$_.TextField} | where { $_.Name -eq "Name"} | %{$_.Value}
#gci $I\metadata.xml | %{ [xml] (gc $_) } | %{ $_.Fields.Name}
$State = gci $I\metadata.xml | %{ [xml] (gc $_) } | %{ $_.Fields.fields} | where { $_.Name -eq "Document" } | %{$_.TextField} | where { $_.Name -eq "IssuerCode"} | %{$_.Value}
$Result = gci $I\metadata.xml | %{ [xml] (gc $_) } | %{ $_.Fields.fields} | where { $_.Name -eq "Document" } | %{$_.TextField} | where { $_.Name -eq "Result"} | %{$_.Value}
$otw = gci $I\storydata.xml | %{ [xml] (gc $_) } | %{ $_.collectionpoint.otwkey }

$line = $I.ToString() + "," + $sourceInstitution + "," + $sourceBatch + "," + $sourceSubBatch + "," + $otw + "," + $Document + "," + $State + "," + $Result
#$line = $I.ToString() + "," + $otw + "," + $Document + "," + $State + "," + $Result
write-host $line
add-content -path .\results.csv -value ($line)
#}


*************************************************************************
setting stuff in source.xml
*************************************************************************
foreach ($I in gci . | Where-Object {$_.PSIsContainer -eq $TRUE})
{
write-host $I
$source = (gc $I\source.txt)
$sourcexml = [xml](gc $I\source.xml)
$sourcexml.source.subBatch = $source.ToString()
$target = join-path (get-location) $I\source.xml
$sourcexml.save($target)
}

foreach ($I in gci . | Where-Object {$_.PSIsContainer -eq $TRUE})
{
write-host $I
$xmlStoryData = [xml](gc $I\storydata.xml)
$xmlSource = [xml](gc $I\source.xml)
$xmlSourcexml.source.subBatch = $storyxml.collectionpoint.otwkey
$target = join-path (get-location) $I\source.xml
$sourcexml.save($target)
}

foreach ($I in gci . | Where-Object {$_.PSIsContainer -eq $TRUE})
{
write-host $I
$sourcexml = [xml](gc $I\source.xml)
$newSubBatch = $sourcexml.source.Batch
#$newSumBatch
if ($newSubBatch -like "Wamu*")
{
$newSubBatch = $newSubBatch.substring(4)
#$newSubBatch
}
$sourcexml.source.Batch = $newSubBatch
$target = join-path (get-location) $I\source.xml
$sourcexml.save($target)
}


*************************************************************************
setting a value in xml file

*************************************************************************
gci _seized20080918103830821\storydata.xml | %{ [xml] (gc $_) } | %{ $_.collectionpoint.otwkey.value = "test" }
gci _seized20080918103830821\storydata.xml
$story = [xml](gc storydata.xml)
$story.collectionpoint.otwkey = "anothertest"
$target = join-path (get-location) storydata.xml
$story.save($target)

#write-host $I", " $Document", " $State", " $Result
| out-file results.txt


*************************************************************************
Stuff for bla Intercept
*************************************************************************
foreach ($I in gci . | Where-Object {$_.PSIsContainer -eq $TRUE})
{
$otw = gci $I\storydata.xml | %{ [xml] (gc $_) } | %{ $_.collectionpoint.otwkey }

$target = $otw + ".jpg"
if (Test-Path .\$target) {$target = $otw + "(1)" + ".jpg"}
if (Test-Path .\$target) {$target = $otw + "(2)" + ".jpg"}
if (Test-Path .\$target) {$target = $otw + "(3)" + ".jpg"}
if (Test-Path .\$target) {$target = $otw + "(4)" + ".jpg"}

cp $I\FrontWhite.jpg .\$target
}

foreach ($I in gci . | Where-Object {$_.PSIsContainer -eq $TRUE})
{
	#$I = "_seized20080912155250179"
	$source = [xml] (gc $I\source.xml)
	$sourcebatch = $source.source.batch.tostring()
	if ($sourcebatch -eq "CamerinoBankerBoxes")
		{
			$otw = gci $I\storydata.xml | %{ [xml] (gc $_) } | %{ $_.collectionpoint.otwkey }

			$target = $otw + ".jpg"
			if (Test-Path .\$target) {$target = $otw + "(1)" + ".jpg"}
			if (Test-Path .\$target) {$target = $otw + "(2)" + ".jpg"}
			if (Test-Path .\$target) {$target = $otw + "(3)" + ".jpg"}
			if (Test-Path .\$target) {$target = $otw + "(4)" + ".jpg"}

			cp $I\FrontWhite.jpg .\$target
		}
}


*************************************************************************
Stuff for bla Intercept with mfid for otwid
*************************************************************************
foreach ($I in gci . | Where-Object {$_.PSIsContainer -eq $TRUE})
{
$otw = gci $I\storydata.xml | %{ [xml] (gc $_) } | %{ $_.collectionpoint.otwkey }

$target = "_JustFrontWhite\" + $otw + $I + ".jpg"
if (Test-Path .\$target) {$target = $otw + "(1)" + $I + ".jpg"}
if (Test-Path .\$target) {$target = $otw + "(2)" + $I + ".jpg"}
if (Test-Path .\$target) {$target = $otw + "(3)" + $I + ".jpg"}
if (Test-Path .\$target) {$target = $otw + "(4)" + $I + ".jpg"}

write-host $I
cp $I\FrontWhite.jpg .\$target
}

*************************************************************************
Stuff for bla Intercept to change a value in xml
*************************************************************************
foreach ($I in gci . | Where-Object {$_.PSIsContainer -eq $TRUE})
{
write-host $I
$story = [xml](gc $I\storydata.xml)
$story.collectionpoint.otwkey = "anothertest"
$target = join-path (get-location) $I\storydata.xml
$story.save($target)
}

*************************************************************************
Stuff for bla Intercept to change a value in xml from textfile list
*************************************************************************
foreach ($I in gc list.txt)
{
write-host $I
$story = [xml](gc $I\storydata.xml)
$story.collectionpoint.otwkey = "WamuTimmi"
$target = join-path (get-location) $I\storydata.xml
$story.save($target)
}

