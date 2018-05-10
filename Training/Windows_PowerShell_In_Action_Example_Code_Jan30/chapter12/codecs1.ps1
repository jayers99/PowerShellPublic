#
# Windows PowerShell in Action
#
# Chapter 12 PowerShell script to list codecs
#

$code = @'
Function WMIDateStringToDate(dtmDate)
    WMIDateStringToDate = CDate(Mid(dtmDate, 5, 2) & "/" & _
        Mid(dtmDate, 7, 2) & "/" & Left(dtmDate, 4) _
            & " " & Mid (dtmDate, 9, 2) & ":" & _
                Mid(dtmDate, 11, 2) & ":" & Mid(dtmDate, _
                    13, 2))
End Function
'@

$vbs = new-object -com ScriptControl 
$vbs.language = 'vbscript' 
$vbs.AllowUI = $false
$vbs.addcode($code)
$vdr = $vbs.CodeObject.WMIDateStringToDate

get-wmiobject Win32_CodecFile |
    %{ $_ | fl Manufacturer, Name, Path, Version, Caption,
        Drive, Extension, FileType, Group,
        @{l="Creation Date"
            e={$vdr.Invoke($_.CreationDate)}},
        @{l="Install Date"
            e={$vdr.Invoke($_.InstallDate)}},
        @{l="Last Modified Date"
            e={$vdr.Invoke($_.LastModified)}} }

