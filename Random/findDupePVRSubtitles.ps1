param([String] $Folder)
$FILETYPES = "*.dvr-ms"
$objShell = New-Object -ComObject Shell.Application
$iTotalFiles = 0
$iCurrentFile = 0
$subTitleList = @()

function getMetaDataKeys($path)
{
	$file = split-path $path -leaf
	$path = split-path $path
	$objFolder = $objShell.namespace($path)
	$objFile = $objFolder.parsename($file)
	$result = @{}
	Write-Host "*******************************************************************"
	#21,183,179
	0..266 | % {
		if ($objFolder.getDetailsOf($objFile, $_))
		{
			Write-Host $_, $objFolder.getDetailsOf($objFolder.items, $_), $objFolder.getDetailsOf($objFile, $_)
			$result[$($objFolder.getDetailsOf($objFolder.items, $_))] = $objFolder.getDetailsOf($objFile, $_)
		}
	}
	Write-Host "*******************************************************************"
}

function getMP3MetaData($path)
{
	# Get the file name, and the folder it exists in
	$file = split-path $path -leaf
	$path = split-path $path
	$objFolder = $objShell.namespace($path)
	$objFile = $objFolder.parsename($file)
	$result = @{}
	21,183,179 | % {
		if ($objFolder.getDetailsOf($objFile, $_))
		{
			$result[$($objFolder.getDetailsOf($objFolder.items, $_))] = $objFolder.getDetailsOf($objFile, $_)
		}
	}

	return $result
}

# MAIN FUNCTION

$startDir = "."

# Do a recursive DIR in the starting directory, include everything with the attributes of a music file.
# Again we filter the result by excluding everything that is a Container.
$dirResult = get-childitem -force -path $startDir -recurse -include $FILETYPES | where{! $_.PSIsContainer}

# Make a note of how many hits we got, so we can show the progress to the client.
$iTotalFiles = $dirResult.Count
if($dirResult)
{
	foreach($dirItem in $dirResult)
	{
		# Up the counter for how many files we've processed so that we can show progress
		$iCurrentFile +=1

		# Get the metadata for the file
		#getMetaDataKeys($dirItem.FullName)
		$fileData = getMP3MetaData($dirItem.FullName)
		
		# Find the path where we the song should be stored
		$title = $fileData["Title"]
		if (!$title) { $title = $null }
		$subTitle = $fileData["Subtitle"]
		if (!$SubTitle) { $subTitle = $null }
		#Write-Host $dirItem, $title, - $subTitle, - $fileData["Date released"]
		if (!($subTitle -eq $null)){
			foreach ($a in $subTitleList){
				if ($subTitle -eq $a[0]){
					#write-host $subTitle, $dirItem, $dirItem.length
					#Write-Host $a[0], $a[1], $a[1].length
					if ($dirItem.length -gt $a[1].length){
						#Write-Host "should del", $a[0], $a[1], $a[1].length	
						Write-Host $a[1]
					
					}else{
						#Write-Host "should del", $subTitle, $dirItem, $dirItem.length
						Write-Host $dirItem
					}
				}
			}
		}
		
		$subTitleList += ,($subtitle, $dirItem)
	}
}



#foreach ($I in $subTitleList){$I}

