#
# Windows PowerShell in Action
#
# Chapter 10 Examples showing basic XML operations
#
# This script walks through the basic operations for
# creating and manipulating XML documents in PowerShell
#
# Note the use of Out-String in displaying the results.
# This is necessary because we're mixing multiple
# object types in the output stream which requires
# us to pre-format the output to get the desired results.
# (See the discussion on formatting the book for more
# information.)
#

"Define an XML document and save it in a variable"
$d = [xml] "<top><a>one</a><b>two</b><c>3</c></top>"

""
"Display the object"
$d

""
"Display the top level"
$d.top | ft -auto | Out-String

""
"Display the element a"
$d.top.a

""
"Change the value of element a"
$d.top.a = "Four"
$d.top.a

""
"Create new elements d and e"
$el= $d.CreateElement("d")
$el.set_InnerText("Hello")
$d.top.AppendChild($el)
$ne = $d.CreateElement("e")
$ne.psbase.InnerText = "World"
$d.top.AppendChild($ne)
$d.top | ft -auto | Out-String

""
"Save the document to a file 'new.xml' then display the file"
$d.save("$PWD\new.xml")
type $PWD\new.xml

""
"Add an attribute to the top element and display the result"
$attr = $d.CreateAttribute("BuiltBy")
$attr.psbase.Value = "Windows PowerShell"
$d.psbase.DocumentElement.SetAttributeNode($attr)
$d.top | ft -auto | Out-String

""
"Save the modified document to 'new.xml' then display the file"
$d.save("c:\temp\new.xml")
type c:\temp\new.xml

""
"Create a new XML object from the file and display it"
$nd = [xml] [string]::join("`n", (gc -read 10kb c:\temp\new.xml))
$nd.Top | ft -auto | Out-String

"And finally remove the file 'new.xml'"
Remove-Item new.xml

