#
# Windows PowerShell in Action
#
# Chapter 1 Example 4
#
# This example displays a simple Windows form
# with a single button.
#

[void][reflection.assembly]::LoadWithPartialName(
    "System.Windows.Forms")
$form = new-object Windows.Forms.Form
$form.Text = "My First Form"
$button = new-object Windows.Forms.Button
$button.text="Push Me!"
$button.Dock="fill"
$button.add_click({$form.close()})
$form.controls.add($button)
$form.Add_Shown({$form.Activate()})
$form.ShowDialog()

