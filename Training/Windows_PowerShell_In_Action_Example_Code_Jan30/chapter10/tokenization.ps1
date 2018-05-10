#
# Windows PowerShell in Action
#
# Chapter 10 Tokenization example
#
# This code snippet shows how to tokenize and expression using
# the .NET regular expression class.
#

#
# Define a regular expression that matches numbers,
# operators or spaces
$pat = [regex] "[0-9]+|\+|\-|\*|/| +"

# Now start the match
$m = $pat.match("11+2 * 35 -4")

# While there are still matches, loop
# and print out each token...
while ($m.Success)
{
    $m.value
    $m = $m.NextMatch()
}

