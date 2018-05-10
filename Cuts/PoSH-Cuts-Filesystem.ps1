
#renaming files
gci *.jpg.jpg | rename-item -newname {$_.name -replace "jpg.jpg","jpg"}
gci *.backimage*, *.frontimage* | %{rename-item -path $_ -newname ($_.name + ".jpg")}
gci *.frontimage* | %{rename-item -path $_ -newname ($_.basename.ToString().Substring(0,36) + ".front" + ".jpg")}
gci *.backimage* | %{rename-item -path $_ -newname ($_.basename.ToString().Substring(0,36) + ".back" + ".jpg")}
gci *.frontimage* | %{rename-item -path $_ -newname ($_.basename.ToString().Substring(0,36) + ".front" + ".jpg") -whatif}

$basePaths = "\\websales1\c$\inetpub\wwwroot\websales1.<domain>.com\MiImages.v2\Images\All\","\\blanas01\MiImages.v2\Images\All"
gci -Path $basePaths -Recurse -Filter *.BackImage.* | 
% {
    #Write-Host $_.FullName
    #Write-Host ($_.Directory.ToString() + "\" + $_.basename.ToString().Substring(0,36) + ".front.jpg")
    $targetFileName = ($_.Directory.ToString() + "\" + $_.basename.ToString().Substring(0,36) + ".back.jpg")
    if (Test-Path $targetFileName) {
        Write-Host ("Target file exists: " + $targetFileName)
        Remove-Item $_.fullname
    } else {
        Write-Host ("allclear: " + $targetFileName)
        Rename-Item -Path $_.fullname -NewName ($_.basename.ToString().Substring(0,36) + ".back.jpg")
    }
}

#some fancy subdir stuff
    #$destSubDir = $_.Name.SubString($_.Name.IndexOf("y="),$_.Name.LastIndexOf("/")-$_.Name.IndexOf("y=")).replace("/","\")
    #$destDir = $destBaseDir
    #Write-Host $destDir
    #if (!(Test-Path $destDir)) { New-Item -ItemType directory -Path $destDir }


gci -path \\websales1\c$\inetpub\wwwroot\websales1.<domain>.com\MiImages.v2\Images\All\*.frontimage.* -Recurse | %{Rename-Item -path $_.fullname -newname ($_.basename.ToString().Substring(0,36) + ".front.jpg")}

if (Test-Path $path) { ... }
if (!(Test-Path $path)) { ... }

gci *.extract.* | 
%{
    write-host ("oldName: " + $_.name)
    $newName = $_.name.tostring().split(".")[0]
    if ($_.name -like "*front*") { 
        $newName = $newName + ".front" + $_.Extension}
    if ($_.name -like "*back*") {
        $newName = $newName + ".back" + $_.Extension}
    write-host ("newName: " + $newName + "`r`n")
    Rename-Item -Path $_ -NewName $newName
}

#get files modified after some data
$dir = "D:\temp\MiImages\Images"
$lastFileDatetime = Get-ChildItem -Path $dir | Sort-Object LastWriteTime -Descending | Select-Object -First 1 | select LastWriteTime
$lastFileDatetime

$newFiles = gci -Path "M:\Current" | where LastWriteTime -GT $lastFileDatetime.LastWriteTime
if ($newFiles -ne $null) {
    cp $newFiles -Destination "d:\Temp\MIImages"
}
else {
    Write-Host No new files
}

| Sort-Object LastWriteTime -Descending

gci m:\current\*.zip | 
ForEach-Object {
    $destDir = "m:\Archive\" + $_.BaseName.tostring().substring(0,1) + "\" + $_.BaseName.tostring().substring(1,1) + "\" + $_.BaseName.tostring().substring(2,1)
    $destDir
    if (-not (Test-Path $destDir)) {
        New-Item -ItemType Directory -Path $destDir
    }
    Move-Item -path $_.fullname -Destination $destDir

}


gci M:\Archive3\*.zip -Recurse | Move-Item -Destination M:\Archive4\

Get-ChildItem -Path $dir | gm

#generate a list of good transactions from mi
Get-ChildItem -Path \\<domain>.com\group\OPEN\jayers\MIImages\Images\RealTest\*.jpg | % {$_.basename.ToString().Substring(0,36)} | select -Unique | % {Write-Output ("," + "'" + $_ + "'")} > d:\temp\miimages\realTest.txt
Get-ChildItem -Path \\<domain>.com\group\OPEN\jayers\MIImages\Images\LoadTest\*.jpg | % {$_.basename.ToString().Substring(0,36)} | select -Unique | % {Write-Output ("," + "'" + $_ + "'")} > Loadtest.txt


#azure move
"c:\Program Files (x86)\Microsoft SDKs\Azure\AzCopy"


#grep sample
$guidtofind = "884d17f9-19ea-4dc7-b0a4-ee8366e88e93"
#$guidtofind = "bef2d320-42a9-496b-8e48-43b9059e78ac"
$jsonLogFilesPath = "D:\Temp\AppGWLogs\insights-logs-applicationgatewayaccesslogbroke\*.json"
gci $jsonLogFilesPath -recurse | 
ForEach-Object{
    #Write-Host $_.FullName
    Get-Content $_ |
    Select-String $guidtofind
}


