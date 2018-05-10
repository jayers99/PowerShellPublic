#
# Windows PowerShell in Action
#
# Appendix B - the Get-MachinesMissingHotfixes script
#

param(
    [string[]] $ComputerName = @(),
    [string[]] $HotFix = $(throw "you must specify a hotfix id")
)

$ComputerName += @($input)

if (! $ComputerName)
{
    $ComputerName = "."
}

$myDir = split-path $MyInvocation.MyCommand.Definition
$gh = join-path $myDir Get-HotFixes.ps1

foreach ($name in $ComputerName)
{
    $sps = & $gh $name | foreach { $_.ServicePackInEffect}

    $result = @{name = $name; missing = @() }

    foreach ($hf in $HotFix)
    {
        if ($sps -notcontains $hf)
        {
            $result.missing += $hf
        }
    }
    if ($result.missing.length -gt 0)
    {
        $result
    }
}
