#
# Windows PowerShell in Action
#
# Chapter 12 Demonstrate calling VBScript from PowerShell
#

function Call-VBScript
{
    $sc = New-Object -ComObject ScriptControl
    $sc.Language = 'VBScript'
    $sc.AddCode('
	Function GetLength(ByVal s)
	    GetLength = Len(s)
	End Function
	Function Add(ByVal x, ByVal y)
	    Add = x + y
	End Function
    ')
    $sc.CodeObject
}

$vb = Call-VBScript
"Length of 'abcd' is " + $vb.getlength("abcd")
"2 + 5 is $($vb.add(2,5))"
