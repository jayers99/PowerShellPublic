#
# Windows PowerShell in Action
#
# Chapter 8 TypeData example.
#
# This script demonstrates using Update-TypeData
# to load an extension to an existing .NET type.
# It adds a new method Sum().
#
# Because a type definition can only be loaded once
# per PowerShell session in version 1, this script
# uses a useful technique for testing this type of
# activity. From PowerShell, you can pass a
# scriptblock to a new instance of PowerShell. This
# new process will execute the scriptblock then return
# two the calling process when done. This allows a script
# to isolate activities to another process if desired.
#

"Starting new PowerShell process"
powershell {

    "Loading the SumMethod file..."
    Update-TypeData SumMethod.ps1xml

    "Sum the numbers from 1 to 5."
    (1,2,3,4,5).Sum()

    "Sum the numbers from 1 to 100."
    (1..100).Sum()

    # As always, "sum" is a polymorphic operation so
    # it can be applied to strings as well as numbers

    "Add an array of strings together."
    ("One","Two","Three","Four","Five").Sum()

    "Add the lengths of all of the files in this directory together"
    (dir | %{ $_.length }).Sum()

}
