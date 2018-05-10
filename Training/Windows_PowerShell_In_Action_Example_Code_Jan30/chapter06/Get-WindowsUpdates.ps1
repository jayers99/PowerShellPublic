#
# Windows PowerShell in Action
#
# Chapter 6 Switch statement example
#
# This script searchs through the Windows update
# log counting certain types of updates.
#

$au=$du=$su=0
switch -regex (cat "$env:windir\windowsupdate.log")
{
    'START.*Finding updates.*AutomaticUpdates' {$au++}
    'START.*Finding updates.*Defender' {$du++}
    'START.*Finding updates.*SMS' {$su++}
}

"Automatic Updates:$au Defender Updates:$du SMS Updates:$su"
