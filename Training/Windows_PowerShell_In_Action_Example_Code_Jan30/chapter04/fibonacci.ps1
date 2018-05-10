#
# Windows PowerShell in Action
#
# Chapter 4 Fibonacci example
#
# This example emits the numbers in the Fibonacci
# sequence below 100.
#

$c=$p=1; while ($c -lt 100) { $c; $c,$p = ($c+$p),$c }
