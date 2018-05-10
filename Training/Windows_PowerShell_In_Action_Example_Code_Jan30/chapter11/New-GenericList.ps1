#
# Windows PowerShell in Action
#
# Chapter 11 New-GenericList function
#
# This function makes it easier to create a .NET
# generic list.
#
# For example:
# $intList = New-GenericList int
# $intList.Add(123)
# $intList.Add(456)
# $intList.count
#   
function global:New-GenericList ([type] $type)
{
    $base = [System.Collections.Generic.List``1]
    $qt = $base.MakeGenericType(@($type))
    , (new-object $qt)
}

