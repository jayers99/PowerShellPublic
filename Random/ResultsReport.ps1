del .\results.csv
add-content -path .\results.csv -value "ID,OTW,Document,State,Result"

foreach ($I in gci . | Where-Object {$_.PSIsContainer -eq $TRUE})
{
$sourceInstitution = 
$Document = gci $I\metadata.xml | %{ [xml] (gc $_) } | %{ $_.Fields.fields} | where { $_.Name -eq "Document" } | %{$_.TextField} | where { $_.Name -eq "Name"} | %{$_.Value}
#gci $I\metadata.xml | %{ [xml] (gc $_) } | %{ $_.Fields.Name}
$State = gci $I\metadata.xml | %{ [xml] (gc $_) } | %{ $_.Fields.fields} | where { $_.Name -eq "Document" } | %{$_.TextField} | where { $_.Name -eq "IssuerCode"} | %{$_.Value}
if (!$state) {$state = "Unknown"}
$Result = gci $I\metadata.xml | %{ [xml] (gc $_) } | %{ $_.Fields.fields} | where { $_.Name -eq "Document" } | %{$_.TextField} | where { $_.Name -eq "Result"} | %{$_.Value}
$otw = gci $I\storydata.xml | %{ [xml] (gc $_) } | %{ $_.collectionpoint.otwkey }

$line = $I.ToString() + "," + $otw + "," + $Document + "," + $State + "," + $Result
write-host $line
add-content -path .\results.csv -value ($line)
}