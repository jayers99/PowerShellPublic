#
# Windows PowerShell in Action
#
# Appendix B - the Get-HotFixes script
#

param(
    [string[]] $ComputerNames = @(),
    [string[]] $Properties = @()
)

$ComputerNames += @($input)

if (! $ComputerNames)
{
    $ComputerNames = "."
}

if ($Properties.Length -eq 0)
{
    Get-WmiObject -Class Win32_QuickFixEngineering `
        -ComputerName $ComputerNames
}
else
{
    Get-WmiObject -Class Win32_QuickFixEngineering `
       -ComputerName $ComputerNames |
            select-object $properties
}
