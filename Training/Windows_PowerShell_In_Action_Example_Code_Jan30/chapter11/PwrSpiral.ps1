#
# Windows PowerShell in Action
#
# Chapter 11 PowerShell Graphics Examples
#
# This script draws a spiral using the GDI+.
#

param(
    $opacity=1.0,
    $increment=50,
    $numRevs=20,
    $size=(500,500)
)
if ($args) {throw 'param($opacity=1.0,$increment=50,$numRevs=20)'}

. ./winform

$colors = .{$args} red blue yellow green orange black cyan `
    teal white purple gray
$index=0
$color = $colors[$index++]

#
# Create the basic controls
#
$form = Form Form @{
    TopMost=$true
    Opacity=$opacity
    Size=size $size[0] $size[1]
}
$myBrush = Drawing SolidBrush $color
$pen =  Drawing pen black @{Width=3}
$rec = Drawing Rectangle 0,0,200,200

#
# Routine to draw a spiral on in the form
#
function Spiral($grfx)
{
    $cx, $cy =$Form.ClientRectangle.Width,
        $Form.ClientRectangle.Height
    $iNumPoints = $numRevs * 2 * ($cx+$cy)
    $cx = $cx/2
    $cy = $cy/2
    $np = $iNumPoints/$numRevs
    $fAngle = $i*2.0*3.14159265 / $np
    $fScale = 1.0 - $i / $iNumPoints
    $x,$y = ($cx * (1.0 + $fScale * [math]::cos($fAngle))), 
            ($cy * (1.0 + $fScale * [math]::Sin($fAngle)))
    for ($i=0; $i -lt $iNumPoints; $i += 50)
    {
        $fAngle = $i*2.0*[math]::pi / $np
        $fScale = 1.0 - $i / $iNumPoints
        $ox,$oy,$x,$y = $x,$y,
            ($cx * (1.0 + $fScale * [math]::cos($fAngle))), 
            ($cy * (1.0 + $fScale * [math]::Sin($fAngle)))
        $grfx.DrawLine($pen, $ox, $oy, $x, $y)
    }
}

#
# Form event handler...
#
$handler = {
    $rec.width = $form.size.width
    $rec.height = $form.size.height
    $myBrush.Color = $color
    $formGraphics = $form.CreateGraphics()
    $formGraphics.FillRectangle($myBrush, $rec)

    $form.Text = "Color: $color".ToUpper()
    $color = $colors[$index++]
    $index %= $colors.Length

    $pen.Color = $color
    Spiral $formGraphics
    $formGraphics.Dispose();
}

$timer = new-object system.windows.forms.timer
$timer.interval = 5000
$timer.add_Tick($handler)
$timer.Start()

$Form.add_paint($handler)

$form.Add_Shown({$form.Activate()})
[void] $form.ShowDialog()
