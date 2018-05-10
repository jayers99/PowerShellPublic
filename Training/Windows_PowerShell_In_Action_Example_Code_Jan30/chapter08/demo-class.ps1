#
# Windows PowerShell in Action
#
# Chapter 8 Example of how to use the CustomClass script
#
# This script defines a simple point class and then creates
# some instances of this class.
#

# Load the CustomClass library from the current directory. 
# Since class.ps1 explicitly defines things in the global space,
# there is no need to "dot" the file.

./class

#
# Now define a "point" class. Note that the opening brace
# of the class body must be on the same line
# as the CustomClass command.
#
CustomClass point {
    note x 0
    note y 0
    method ToString {
        "($($this.x), $($this.y))"
    }
    method scale {
        $this.x *= $args[0]
        $this.y *= $args[0]
    }
}

# Instantiate and use an instance of class point.

$p = new point
$p | gm noteProperty,ScriptMethod
"Created a point"
$p.tostring()

$p.x=2
$p.y=3
"Set point to new values"
$p.tostring()

$p.scale(3)
"Scaled the point"
$p.tostring()

"Use the point object with the format operator."
"The point p is {0}" -f $p


