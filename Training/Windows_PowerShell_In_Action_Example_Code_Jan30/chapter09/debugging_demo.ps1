#
# Windows PowerShell in Action
#
# Chapter 9 Debugging tools demo
#
# This file shows how the debugging tools can be used
#

./DebuggingLibrary

"First line"
'Now we''ll hit a break point, type "exit" to continue'
bp
$foo = "Hello world"
'Break point with condition, type "$foo" then "exit" to continue'
bp { $true }
'Now define a bunch of functions'
function a { b }
function b { c }
function c { d }
function d { e }
function e {
    'Type "gcs" to see where you are then "exit" to continue'
    bp
}
'Run the top level function until a breakpoint is hit'
a
