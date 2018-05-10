#
# Windows PowerShell in Action
#
# Appendix B - the Get-DomainInfo script
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
    Get-WmiObject -Class Win32_NTDomain `
        -ComputerName $ComputerNames
}
else
{
    Get-WmiObject -Class Win32_NTDomain `
       -ComputerName $ComputerNames |
            select-object $properties
}
