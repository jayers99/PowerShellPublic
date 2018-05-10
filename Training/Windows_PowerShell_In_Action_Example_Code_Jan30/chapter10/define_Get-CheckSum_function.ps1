#
# Windows PowerShell in Action
#
# Chapter 10 The Get-CheckSum function
#
# Defines a (not very good) checksum function that simply
# adds up all of the bytes in file file.
#
function global:Get-CheckSum (
    $path=$(throw "You must specify a file to checksum")
)
{
    $sum=0
    get-content -encoding byte -read -1 $path | %{
        foreach ($byte in $_) { $sum += $byte }
    }
    $sum
}

