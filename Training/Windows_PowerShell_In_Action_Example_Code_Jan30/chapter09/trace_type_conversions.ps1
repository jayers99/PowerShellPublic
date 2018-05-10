#
# Windows PowerShell in Action
#
# Chapter 9 Examples using Trace-Command
#
# These code snippets show how to use Trace-Command
# to trace the type converter and parameter binding
# operations. Here-strings are used to generate headers
# for each section.
#

###############################
@"

$("="*50)
Trace converting a string to an integer
"@
trace-command -opt all typeconversion {[int] "123"} -pshost

###############################
@"

$("="*50)
Trace converting a string to an XML document
Include timestamps in the output
"@
trace-command -opt all typeconversion -pshost `
    -listen timestamp { [xml] '<h>Hi</h>' }

###############################
@"

$("="*50)
Trace parameter binding
"@
trace-command -opt all parameterbinding -pshost { "c:\" | get-item }

###############################
@"

$("="*50)
Trace parameter binding and type conversion
"@
function foo ([int] $x) {$x}
trace-command -opt all parameterbinding,
    typeconversion -pshost {foo "123"}

