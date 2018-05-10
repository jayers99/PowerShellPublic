#
# Windows PowerShell in Action
#
# Chapter 11 Utility functions for finding types
#
# These functions help find .NET types and members.
#
# Here are some examples that show how to use them:
#  Get-Types
#  Get-Types ^system\.timers | %{ $_.FullName }
#  Get-Types ^system\.timers | Select-Members begin | Show-Members -method
#  
#

function global:Get-Assemblies
{
    [AppDomain]::CurrentDomain.GetAssemblies()
}

function global:Get-Types ($Pattern=".")
{
    Get-Assemblies | %{ $_.GetExportedTypes() } |
        where {$_ -match $Pattern}
}

filter global:Select-Members ($Pattern = ".")
{
    $_.getmembers() | ? {$_ -match $Pattern }
}

filter global:Show-Members ([switch] $Method)
{
    if (!$Method -or $_.MemberType -match "method")
    {
        "[{0}]:: {1}" -f $_.declaringtype, $_
    }
}


