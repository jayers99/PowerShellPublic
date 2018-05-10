#
# Windows PowerShell in Action
#
# Chapter 12 PowerShell script to list codecs
#

function WMIDateStringToDate($dtmDate)
{
    [datetime] ($dtmDate -replace
        '^(....)(..)(..)(..)(..)(..)(.*)$','$2/$3/$1 $4:$5:$6')
}
get-wmiobject Win32_CodecFile |
    %{ $_ | fl Manufacturer, Name, Path, Version, Caption,
        Drive, Extension, FileType, Group,
        @{l="Creation Date"
            e={WMIDateStringToDate $_.CreationDate}},
        @{l="Install Date"
            e={WMIDateStringToDate $_.InstallDate}},
        @{l="Last Modified Date"
            e={WMIDateStringToDate $_.LastModified}} }

