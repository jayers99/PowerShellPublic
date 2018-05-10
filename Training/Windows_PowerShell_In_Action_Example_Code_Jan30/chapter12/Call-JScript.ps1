#
# Windows PowerShell in Action
#
# Chapter 12 Demonstrate calling JScript from PowerShell
#

function Call-JScript
{
    $sc = New-Object -ComObject ScriptControl
    $sc.Language = 'JScript'
    $sc.AddCode('
	function getLength(s)
        {
	    return s.length
	}
	function Add(x, y)
        {
	    return x + y
	}
    ')
    $sc.CodeObject
}

$js = Call-JScript
"Length of 'abcd' is " + $js.getlength("abcd")
"2 + 5 is $($js.add(2,5))"
