#
# Windows PowerShell in Action
#
# Chapter 11 The PowerShell Graphical Calculator
#
# This script implements a simple WinForm calculator.
#
. ./winform

$script:op = ''
$script:doClear = $false
function clr { $result.text = 0 }
[decimal] $script:value = 0

$handleDigit = {
    if ($doClear)
    {
        $result.text = 0
        $script:doClear = $false
    }

    $key = $this.text
    $current = $result.Text
    if ($current -match '^0$|NaN|Infinity')
    {
        $result.text = $key
    } else {
        if ($key -ne '.' -or $current -notmatch '\.')
        {
            $result.Text += $key
        }
    }
}

$handleOp = {
     $script:value = $result.text
     $script:op = $this.text
     $script:doClear = $true
}

$keys = (
    @{name='7'; action=$handleDigit},
    @{name='8'; action=$handleDigit},
    @{name='9'; action=$handleDigit},
    @{name='/'; action = $handleOp},
    @{name='SQRT'; action = {
            trap { $resultl.Text = 0; continue }
            $result.Text = [math]::sqrt([decimal] $result.Text)
        }
    },
    @{name='4'; action=$handleDigit},
    @{name='5'; action=$handleDigit},
    @{name='6'; action=$handleDigit},
    @{name='*'; action = $handleOp},
    @{name='Clr'; action = $function:clr},
    @{name='1'; action=$handleDigit},
    @{name='2'; action=$handleDigit},
    @{name='3'; action=$handleDigit},
    @{name='-'; action = $handleOp},
    @{name='1/x'; action = {
            trap { $resultl.Text = 0; continue }
            $val = [decimal] $result.Text
            if ($val -ne 0)
            {
                $result.Text = 1.0 / $val
            }
        }
    },
    @{name='0'; action=$handleDigit},
    @{name='+/-'; action = {
            trap { $resultl.Text = 0; continue }
            $result.Text = - ([decimal] $result.Text)
        }
    },
    @{name='.'; action=$handleDigit},
    @{name='+'; action = $handleOp},
    @{name='='; action = {
            $key = $this.text
            trap { message "error: $key" "error: $key"; continue }
            $operand = [decimal] $result.text
            $result.text = invoke-expression "`$value $op `$operand"
        }
    },
    @{name='%'; action = $handleOp},
    @{name='sin'; action = {
            trap { $resultl.Text = 0; continue }
            $result.Text = [math]::sin([decimal] $result.Text)
        }
    },
    @{name='cos'; action = {
            trap { $resultl.Text = 0; continue }
            $result.Text = [math]::cos([decimal] $result.Text)
        }
    },
    @{name='tan'; action = {
            trap { $resultl.Text = 0; continue }
            $result.Text = [math]::tan([decimal] $result.Text)
        }
    },
    @{name='int'; action = {
            trap { $resultl.Text = 0; continue }
            $result.Text = [int] $result.Text
        }
    },
    @{name='Sqr'; action = {
            $result.Text = [double]$result.Text * [double]$result.text
        }
    },
    @{name='Quit'; action = {$form.Close()}}
)

$columns = 5

$form = Form Form @{
    Text = "PowerShell Calculator"
    TopLevel = $true
    Padding=5
}

$table = form TableLayoutPanel @{
    ColumnCount = 1
    Dock="fill"
}
$form.controls.add($table)

$menu = new-menustrip $form {
    new-menu File {
	new-menuitem "Clear" { clr }
        new-separator
        new-menuitem Quit { $form.Close() }
    }
}
$table.controls.add($menu)

$cfont = new-object Drawing.Font 'Lucida Console',10.0,Regular,Point,0

$script:result = form TextBox @{
    Dock="fill"
    Font = $cfont
    Text = 0
}
$table.Controls.Add($result)

$buttons = form TableLayoutPanel @{
    ColumnCount = $columns
    Dock = "fill"
}

foreach ($key in $keys) {
    $b = form button @{text=$key.name; font = $cfont; size = size 50 30 }
    $b.add_Click($key.action)
    $buttons.controls.Add($b)
}
$table.Controls.Add($buttons)

$height = ([math]::ceiling($keys.count / $columns)) * 40 + 100
$width = $columns * 58 + 10

$result.size = size ($width - 10) $result.size.height
$form.size = size $width $height
$form.Add_Shown({$form.Activate()})
[void] $form.ShowDialog();
