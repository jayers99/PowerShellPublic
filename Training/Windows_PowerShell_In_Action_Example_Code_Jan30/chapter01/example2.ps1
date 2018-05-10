#
# Windows PowerShell in Action
#
# Chaper 1 Example 2
#
# This example searches through log files looking logs that
# contain error records...
#
# Note - this may take a while to run and will report errors
# on files it can't access (which is fine for this example).

dir $env:windir\*.log | select-string -List error |
    format-table path,linenumber -auto
