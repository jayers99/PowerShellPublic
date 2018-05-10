#
# Windows PowerShell in Action
#
# Chapter 13 Define a safe Wheres function
#

function global:Wheres
{
    begin {
        if ($args.count -ne 3)
        {
            throw "wheres: syntax <prop> <op> <val>"
        }
        $prop,$op,$y= $args
        $op_fn = $(
            switch ($op)
            {
                eq {{$x.$prop -eq $y}; break}
                ne {{$x.$prop -ne $y}; break}
                gt {{$x.$prop -gt $y}; break}
                ge {{$x.$prop -ge $y}; break}
                lt {{$x.$prop -lt $y}; break}
                le {{$x.$prop -le $y}; break}
                like {{$x.$prop -like $y}; break}
                notlike {{$x.$prop -notlike $y}; break}
                match {{$x.$prop -match $y}; break}
                notmatch {{$x.$prop -notmatch $y}; break}
                default {
                    throw "wh: operator '$op' is not defined"
                }
            }
        )
    }
    process { $x=$_; if( . $op_fn) { $x }}
}

