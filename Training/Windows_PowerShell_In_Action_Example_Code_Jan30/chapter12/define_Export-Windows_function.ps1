#
# Windows PowerShell in Action
#
# Chapter 12 Defines a set of functions for saving
#            and loading a set of web pages,
#

function global:Export-Windows
{
    param($file=(join-path (resolve-path ~/*documents) saved-urls.ps1))

    $shell = new-object -com Shell.Application

    $title = $null
    $shell.Windows() | % {
        if (! $title)
        {
            $title = $_.LocationName
        }
        else
        {
            @"
@{
    title='$($_.LocationName -replace "'","''")'
    url='$($_.LocationUrl -replace "'","''")'
}

"@
                $title = $null
        }
    } | out-file -width 10kb -filepath $file -encoding unicode
}

function global:Get-Windows
{
    param($file=(join-path (resolve-path ~/*documents) saved-urls.ps1))

    & $file
}
        
function global:Import-Windows
{
    param(
        $File=(join-path (resolve-path ~) saved-urls.ps1),
        [switch] $show
    )

    & $file | foreach {
        if ($Show)
        {
            explorer $_.url
        }
        else
        {
            $_
        }
    }
}
