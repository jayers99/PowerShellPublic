#
# Windows PowerShell in Action
#
# Chapter 11 PowerShell Graphical Process Viewer
#
# This script takes the output of the Get-Process cmdlet
# and displays it in a grid on a form using data-binding.
#
. ./winform

$form = Form Form @{
    AutoSize=$true
    Text = "PowerShell Graphical Process Viewer"
}

$sortCriteria="ProcessName"
function update ($sortCriteria="ProcessName")
{
    $grid.DataSource = New-Object Collections.ArrayList `
        (,(gps | sort $sortCriteria |
        select name,id,handles,workingset,cpu))
    $grid.CaptionText = "Process Data Sorted by $sortCriteria"
    $status.Text =
        "Last Updated on $(get-date | out-string)" -replace "`n"
}

$table = form TableLayoutPanel @{
    ColumnCount=6
    Dock="Fill"
    AutoSizeMode = "GrowOnly"; AutoSize = $true
}
$form.Controls.Add($table)

[void] $table.RowStyles.Add((style))
[void] $table.RowStyles.Add((style -percent 50))
1..3 | %{
    [void] $table.RowStyles.Add((style))
}
1..4 | %{
    [void] $table.ColumnStyles.Add((style column 17))
}

$menu = new-menustrip $form {
    new-menu File {
        new-menuitem "Update" { update }
        new-separator
        new-menuitem "Quit" { $form.Close() }
    }
    new-menu Help {
        new-menuitem "About" {
            message (
                "PowerShell Process Viewer`n`n" +
                "Windows Forms Demo Applet`n`n" +
                "From Windows PowerShell in Action`n" +
                "Manning Publications Co. 2007"
            )
        }
    }
}
$table.controls.add($menu)
$table.SetColumnSpan($menu, 6)

$grid = Form DataGrid @{
    Dock="fill"
    CaptionText = "PowerShell Graphical Process Viewer"
}
$table.Controls.Add($grid)
$table.SetColumnSpan($grid, 6)

function New-Button($label,$action)
{
    $b = form button @{text=$label; anchor = "left,right" }
    $b.add_Click($action)
    $table.Controls.Add($b)
}
New-Button "Name" {update ProcessName}
New-Button "Id" {update Id}
New-Button "Handles" {update Handles}
New-Button "WorkingSet (WS)" {update WS}
New-Button "CPU" {update cpu}

$status = form label @{
    Dock="fill"
    FlatStyle="popup"
    BorderStyle="fixed3d"
}
$table.Controls.Add($status)
$table.SetColumnSpan($status, 6)
Update

$form.Add_Shown({$form.Activate()})
[void] $form.ShowDialog()

