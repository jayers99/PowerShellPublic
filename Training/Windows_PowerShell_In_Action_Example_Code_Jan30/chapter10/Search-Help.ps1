#
# Windows PowerShell in Action
#
# Chapter 10 The Search-Help function
#
# A function so search all of the PowerShell help doccuments
# looking for a specific pattern.
#

function global:Search-Help
{
    param ($pattern = $(throw "you must specify a pattern"))
    
    select-string -list $pattern $PSHome\about*.txt |
        %{$_.filename -replace '\..*$'}
   
    dir $PShome\*dll-help.*xml |
        %{ [xml] (get-content -read -1 $_) } |
        %{$_.helpitems.command} |
        ? {$_.get_Innertext() -match $pattern} |
        %{$_.details.name.trim()}
}

