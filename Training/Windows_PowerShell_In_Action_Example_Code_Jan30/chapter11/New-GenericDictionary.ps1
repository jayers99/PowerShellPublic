#
# Windows PowerShell in Action
#
# Chapter 11 New-GenericDictionary function
#
# This function makes it easier to create a .NET
# generic dictionary.
#
# For example:
# $gd = New-GenericDictionary string int
# $gd["red"] = 1
# $gd["blue"] = 2
# $gd

function global:New-GenericDictionary ([type] $keyType, [type] $valueType)
{
    $base = [System.Collections.Generic.Dictionary``2]
    $ct = $base.MakeGenericType(($keyType, $valueType))
    , (New-Object $ct)
}

