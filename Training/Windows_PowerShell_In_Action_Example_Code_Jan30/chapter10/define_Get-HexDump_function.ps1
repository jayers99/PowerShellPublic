#
# Windows PowerShell in Action
#
# Chapter 10 The Get-HexDump function
#
# This function will do a structured
# hex dump of the specified path.
#
function global:Get-HexDump (
    $path = $(throw "path must be specified"),
    $width=10,
    $total=-1
)
{
    $OFS=""
    Get-Content -Encoding byte $path -ReadCount $width `
        -totalcount $total | %{
    $record = $_
    if (($record -eq 0).count -ne $width)
    {
        $hex = $record | %{
        " " + ("{0:x}" -f $_).PadLeft(2,"0")}
        $char = $record | %{
        if ([char]::IsLetterOrDigit($_))
            { [char] $_ } else { "." }}
        "$hex $char"
        }
    }
}

