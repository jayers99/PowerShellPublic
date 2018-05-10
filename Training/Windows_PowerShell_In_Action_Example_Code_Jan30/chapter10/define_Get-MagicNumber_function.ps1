#
# Windows PowerShell in Action
#
# Chapter 10 Get-MagicNumber function
#
# This function will get the "magic number"
# from a file.
#
function global:Get-MagicNumber ($path)
{
    $OFS=""
    $mn = Get-Content -encoding byte $path -read 4 -total 4
    $hex1 = ("{0:x}" -f ($mn[0]*256+$mn[1])).PadLeft(4, "0")
    $hex2 = ("{0:x}" -f ($mn[2]*256+$mn[3])).PadLeft(4, "0")
    [string] $chars = $mn| %{ if ([char]::IsLetterOrDigit($_))
        { [char] $_ } else { "." }}
    "{0} {1} '{2}'" -f $hex1, $hex2, $chars
}

# Examples sowing the use of this function:

get-magicnumber $env:windir/Zapotec.bmp
get-magicnumber $env:windir/explorer.exe
