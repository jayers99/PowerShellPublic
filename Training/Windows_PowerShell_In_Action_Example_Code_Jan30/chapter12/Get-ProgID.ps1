#
# Windows PowerShell in Action
#
# Chapter 12 Functions to get COM ProgIDs
#
# This script defines two different functions for
# showing the COM ProgIDs that are available on the
# system.
#
function global:Get-ProgID1 {
    param ($filter = '.')

    $ClsIdPath = "REGISTRY::HKey_Classes_Root\clsid"
    dir -recurse $ClsIdPath |
        % {if ($_.name -match '\\ProgID$') { $_.GetValue("") }} |
        ? {$_ -match $filter}
}

function global:Get-ProgID2 {
    param ($filter = '.')

    Get-WMIObject Win32_ProgIDSpecification |
        select-object ProgID,Description |
        ? {$_.ProgId -match $filter}
}

