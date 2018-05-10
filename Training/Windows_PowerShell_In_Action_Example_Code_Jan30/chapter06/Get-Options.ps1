#
# Windows PowerShell in Action
#
# Chapter 6 Switch statement example
#
# This example shows how the switch statement
# can be used to parse a collection of options.
#
# Although this isn't usually needed in PowerShell
# (PowerShell has direct support for argument parsing),
# it illustrates how this might be done if you
# need to parse an option syntax that doesn't match
# PowerShell's.
#

# Set up the collection of options to parse
$options="-a -b Hello -c".split()

# parse the options into variables...
$a=$c=$d=$false
$b=$null
switch ($options)
{
'-a' {$a=$true; continue}
'-b' {[void] $switch.movenext(); $b= $switch.current; continue}
'-c' {$c=$true; continue}
'-d' {$d=$true; continue}
}

# Now display the result...
"a=$a b=$b c=$c d=$d"
