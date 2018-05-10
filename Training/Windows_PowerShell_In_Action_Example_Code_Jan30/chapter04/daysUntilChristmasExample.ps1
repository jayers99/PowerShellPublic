#
# Windows PowerShell in Action
#
# Chapter 4 "Days Till Xmas" example.
#
# This is a function that will tell you the number
# of days until Christmas for the current year. It was
# written by Jeffrey Snover for his curious daughter.
#

function tillXmas ()
{
    $now = [DateTime]::Now
    [Datetime]( [string] $now.Year + "-12-25") - $Now
}

"There are $((tillXmas).days) days until Xmas."
