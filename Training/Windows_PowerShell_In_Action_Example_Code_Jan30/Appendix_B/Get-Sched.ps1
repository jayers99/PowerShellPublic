#
# Windows PowerShell in Action
#
# Appendix B - the Get-Sched script
#
# This script shows how to take the text output from
# an existing tool and convert it into PowerShell objects
# so it is easier to work with.
#

$null,$header,$lines,$data = schtasks /query


# return if there are no scheduled tasks
if (! $data) { return }

function Split-String ($s,[int[]] $indexes)
{
    if (! $s ) { return }
    $indexes | foreach {$last=0} {
        [string] $s.substring($last, $_-$last)
        $last = $_+1
    }
    $s.substring($last)
}

$first,$second,$third = $lines.split(" ") |
    foreach { $_.length }
$second+=$first

$h1,$h2,$h3 = split-string $header $first, $second |
    foreach { $_ -replace " " }

$data | foreach {
    $v1, [datetime] $v2, $v3 = split-string $_ $first, $second

    new-object psobject |
        add-member -pass -mem NoteProperty $h1 $v1 |
        add-member -pass -mem NoteProperty $h2 $v2 |
        add-member -pass -mem NoteProperty $h3 $v3
}

