#
# Windows PowerShell in Action
#
# Chapter 11 Demo script using the Winform library
#
# This function displays a form and sets up a click
# handler for the form so that anywhere you click, you'll
# see the word "Hello" appear.
# generic list.
#
# This is an additional example that is not discussed in the book.

. ./winform

$font = new-object System.Drawing.Font "Verdana", 15
$form = Form Form @{text="My First Interactive Action"}

$form.Text = "My First Interactive Application"

$click = {
    $l = Form Label @{
        Text = "Hello"
        AutoSize = $True
        Location = $_.Location
        Font = $font
    }
    $this.Controls.Add($l)
}

$form.add_Click($click)

$form.Add_Shown({$form.Activate()})
[Windows.Forms.Application]::Run($form)
