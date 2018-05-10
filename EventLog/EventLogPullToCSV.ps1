$events = Get-EventLog -newest 10 -ComputerName jayers-pc -LogName Application -EntryType Error, Warning
$events | select -property TimeGenerated, MachineName, EntryType, Source, EventID, Message | Export-Csv  c:\batch\EventLogs\power.csv

#$events | format-list -property *
#$events | format-list -property TimeGenerated, MachineName, EntryType, Source, EventID, Message
#$events | group-object -property EventID, Source -noelement | sort-object -property count –descending
