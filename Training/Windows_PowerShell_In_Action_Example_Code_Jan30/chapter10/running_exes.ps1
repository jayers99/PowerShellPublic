#
# Windows PowerShell in Action
#
# Chapter 10 Utilities for running programs
#
# External programs don't understand PowerShell's 
# wildcard (globbing) syntax. These wraper functions
# are a way to work around those limitations.
#

function global:notepad
{
    $args | %{ notepad.exe (resolve-path $_).ProviderPath }
}

function global:run-exe
{
    $cmd, $files = $args
    $cmd = @(get-command -type application $cmd)[0].Definition
    $files | %{ & $cmd (resolve-path $_).ProviderPath}
}

