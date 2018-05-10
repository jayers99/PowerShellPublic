#
# Windows PowerShell in Action
#
# Chapter 10 XPath examples
#
# This script runs through the bookstore examples
# in Chapter 10 that illustrate how to use XPath
# navigators from PowerShell.
#

#
# Create the bookstore inventory string
#
$inventory = @"
<bookstore>
    <book genre="Autobiography">
        <title>The Autobiography of Benjamin Franklin</title>
        <author>
            <first-name>Benjamin</first-name>
            <last-name>Franklin</last-name>
        </author>
        <price>8.99</price>
        <stock>3</stock>
    </book>
    <book genre="Novel">
        <title>Moby Dick</title>
        <author>
        <first-name>Herman</first-name>
        <last-name>Melville</last-name>
        </author>
        <price>11.99</price>
        <stock>10</stock>
    </book>
    <book genre="Philosophy">
        <title>Discourse on Method</title>
        <author>
            <first-name>Rene</first-name>
            <last-name>Descartes</last-name>
        </author>
        <price>9.99</price>
        <stock>1</stock>
    </book>
    <book genre="Computers">
        <title>Windows PowerShell in Action</title>
        <author>
            <first-name>Bruce</first-name>
            <last-name>Payette</last-name>
        </author>
        <price>39.99</price>
        <stock>5</stock>
    </book>
</bookstore>
"@

# A function to create an XPath navigator object from
# a string.
function Get-XPathNavigator ($text)
{
    $rdr = [System.IO.StringReader] $text
    $trdr = [system.io.textreader]$rdr
    $xpdoc = [System.XML.XPath.XPathDocument] $trdr
    $xpdoc.CreateNavigator()
}

# create an XPath navigator for our inventory
$xb = get-XPathNavigator $inventory

''
'Find all of the books costing more than $9.00.'
$expensive = "/bookstore/book/title[../price>9.00]"
$xb.Select($expensive) | ft -auto value | Out-String

''
'Now show both the title and the price'
$titleAndPrice = "/bookstore/book[price>9.00]"
$xb.Select($titleAndPrice) | %{[xml] $_.OuterXml} |
    ft -auto {$_.book.price},{$_.book.title} |
    Out-String

''
'Calculate the total price of all books in inventory'
$xb.Select("descendant::book") | % `
    {$t=0} `
    {
        $book = ([xml] $_.OuterXml).book
        $t += [decimal] $book.price * $book.stock
    } `
    {
        "Total price is: `$$t"
    }

''
'Display all of the genres available'
$xi = [xml] $inventory
$xi.SelectNodes("descendant::book/@genre") | Out-String

''
'Display title and price again'
$xi.SelectNodes("descendant::book") |
    ft -auto price, title | Out-String


