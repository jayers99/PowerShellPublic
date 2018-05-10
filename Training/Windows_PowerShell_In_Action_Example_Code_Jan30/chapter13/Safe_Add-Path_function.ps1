#
# Windows PowerShell in Action
#
# Chapter 13 Define a safe AddPath function
#
function global:Add-Path {
    param (
        [string]$path = (write-error `
            "Usage: add-path [-path] path [[-scope] {System | User}] [-save]"),
        [string]$scope = "User",
        [switch]$save
    )
    
    $AvailScopes = "System", "User"
    if ($AvailScopes -notcontains $scope)
    {
        $OFS=","
        write-error ("$scope is an unknown value for scope. " +
            "Please specify one of these values: $AvailScopes.")
        return
    }
    
    $wsh = new-object -com wscript.shell
    $pathTable = @{}
    $AvailScopes | % {$pathTable[$_] = $wsh.Environment($_).Item("Path")}
    $PathTable[$scope] += ";$path"
    $env:path = "$($pathTable['System']);$($pathTable['User'])"
    
    if ($save)
    {
        $wsh.Environment($scope).Item("Path") = $pathTable[$scope]
    }
} 
