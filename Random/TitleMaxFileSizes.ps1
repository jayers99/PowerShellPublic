gci *.xml | %{add-content -path c:\batch\TitleMaxPayloadSizes.csv -value ((Get-Item $_).Length)}

