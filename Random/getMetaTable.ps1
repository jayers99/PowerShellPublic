foreach ($I in gci . | Where-Object {$_.PSIsContainer -eq $TRUE})
{
$Document = gci $I\metadata.xml | %{ [xml] (gc $_) } | %{ $_.Fields.Name}
$State = gci $I\metadata.xml | %{ [xml] (gc $_) } | %{ $_.Fields.fields} | where { $_.Name -eq "Document" } | %{$_.TextField} | where { $_.Name -eq "IssuerCode"} | %{$_.Value}
$Result = gci $I\metadata.xml | %{ [xml] (gc $_) } | %{ $_.Fields.fields} | where { $_.Name -eq "Document" } | %{$_.TextField} | where { $_.Name -eq "Result"} | %{$_.Value}
write-host $I", " $Document", " $State", " $Result
}