#
# Windows PowerShell in Action
#
# Chapter 11 My first form demo script
#
# This function displays the basic form from Chapter 1
#

[void][reflection.assembly]::LoadWithPartialName(
    "System.Windows.Forms")
$form = New-Object Windows.Forms.Form
$form.Text = "My First Form"
$button = New-Object Windows.Forms.Button
$button.text="Push Me!"
$button.Dock="fill"
$button.add_click({$form.close()})
$form.controls.add($button)
$form.Add_Shown({$form.Activate()})
$form.ShowDialog()

