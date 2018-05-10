#
# Windows PowerShell in Action
#
# Chapter 12 Demonstrate using WMI methods from PowerShell
#

"`nGet and show the Win32_Process class"
$c = [WMICLASS]"root\cimv2:WIn32_Process"
$c | gm -type methods | out-string

"`nStart a calculator process and show it's information"
$proc = $c.Create("calc.exe")

start-sleep 2
$proc | ft -auto ProcessID, ReturnValue | out-string
get-process calc | ft -auto name,id | out-string

"`nTerminate the calc process"
$query = [WMISEARCHER] `
    "SELECT * FROM Win32_Process WHERE Name = 'calc.exe'"

[object[]] $procs = $query.Get()
$procs.count
$procs[0].name
$procs[0].terminate(0) | out-string


