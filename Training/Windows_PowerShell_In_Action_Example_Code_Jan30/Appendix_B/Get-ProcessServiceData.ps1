#
# Windows PowerShell in Action
#
# Appendix B - the Get-ProcessServiceData script
#
# This script shows how to combine data from two different
# sources into a single object, in effect doing a "join" operation.
#

get-process | foreach {$processes = @{}} {
    $processes[$_.processname] = $_}
get-service |
    where {$_.Status -match "running" -and
        $_.ServiceType -eq "Win32OwnProcess" } |
    foreach {
        new-object psobject |
            add-member -pass NoteProperty Name $_.Name |
            add-member -pass NoteProperty PID $processes[$_.Name].Id |
            add-member -pass NoteProperty WS $processes[$_.Name].WS |
            add-member -pass NoteProperty Description $_.DisplayName |
            add-member -pass NoteProperty FileName `
                $processes[$_.Name].MainModule.FileName
     } |
     export-csv -notype ./service_data.csv

"Created output file ./service_data.csv"

