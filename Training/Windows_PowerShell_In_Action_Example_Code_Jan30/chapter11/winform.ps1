#
# Windows PowerShell in Action
#
# Chapter 11 winform Library functions
#
# This script defines a library of functions that help
# with building WinForm applications in PowerShell. This
# library is used by other examples in chapter 11.
#

[void][reflection.assembly]::LoadWithPartialName("System.Drawing")
[void][reflection.assembly]::LoadWithPartialName("System.Windows.Forms")

function point {new-object System.Drawing.Point $args}
function size {new-object System.Drawing.Size $args}
function Form ($control,$properties)
{
    $c = new-object "Windows.Forms.$control"
    if ($properties)
    {
        foreach ($prop in $properties.keys)
        {
            $c.$prop = $properties[$prop]
        }
    }
    $c
}

function Drawing ($control,$constructor,$properties)
{
    $c = new-object "Drawing.$control" $constructor
    if ($properties.count)
    {
        foreach ($prop in $properties.keys) {$c.$prop = $properties[$prop]}
    }
    $c
}


function RightEdge ($x, $offset=01)
{
    $x.Location.X + $x.Size.Width + $offset
}
function LeftEdge ($x, $offset=1)
{
    $x.Location.X
}
function BottomEdge ($x, $offset=1)
{
    $x.Location.Y + $x.Size.Height + $offset
}
function TopEdge ($x, $offset=1) {
    $x.Location.Y
}

function Message ($string, $title='PowerShell Message')
{ 
    [windows.forms.messagebox]::Show($string, $title)
}

function New-Menustrip ($form, $menu)
{
    $ms = Form MenuStrip
    [void]$ms.Items.AddRange((&$menu))
    $form.MainMenuStrip = $ms
    $ms
}
function New-Menu($name,$items)
{
    $menu = Form ToolStripMenuItem @{Text = $name}
    [void] $menu.DropDownItems.AddRange((&$items))
    $menu
}
function New-Menuitem($name,$action)
{
    $item = Form ToolStripMenuItem @{Text = $name}
    [void] $item.Add_Click($action)
    $item
}
function New-Separator { Form ToolStripSeparator }

function Style ($rowOrColumn="row",$percent=-1)
{
    if ($percent -eq -1)
    {
        $typeArgs = "AutoSize"
    }
    else
    {
        $typeArgs = "Percent",$percent
    }
    new-object Windows.Forms.${rowOrColumn}Style $typeArgs
}

