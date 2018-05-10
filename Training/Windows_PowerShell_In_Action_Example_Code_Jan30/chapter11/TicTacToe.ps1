#
# Windows PowerShell in Action
#
# Chapter 11 PowerShell Graphics Examples
#
# This script implements a simple Tic-Tac-Toe game
# in PowerShell using WinForms.
#
# This is an additional example, not covered in the book.
#

. ./winform

$form = Form Form @{
    Text = "PowerShell TicTacToe"
    StartPosition = "CenterScreen"
}

$Form.SuspendLayout()

$winningMoves =
    (0, 1, 2),
    (3, 4, 5),
    (6, 7, 8),
    (0, 3, 6),
    (1, 4, 7),
    (2, 5, 8),
    (0, 4, 8),
    (2, 4, 6)

#
# Build a hash table to winning moves to try. The key contains
# the pattern to check, the value is where to move...
#
$WinningMovesToTry = @{
    #012345678
    "OO ......" = 2
    "O O......" = 1
    " OO......" = 0
    "...OO ..." = 5
    "...O O..." = 4
    "... OO..." = 3
    "......OO " = 8
    "......O O" = 7
    "...... OO" = 6
    " ...O...O" = 0
    "O... ...O" = 4
    "O...O... " = 8
    "..O. .O.." = 4
    ".. .O.O.." = 2
    "..O.O. .." = 6
    "O..O.. .." = 6
    "O.. ..O.." = 3
    " ..O..O.." = 0
    ".O..O.. ." = 7
    ".O.. ..O." = 4
    ". ..O..O." = 1
    "..O..O.. " = 8
    "..O.. ..O" = 5
    ".. ..O..O" = 2    
}

#
# The blocking move table is the same as the winning move
# table except X instead of O
#
$BlockingMovesToTry = @{}
foreach ($e in $WinningMovesToTry.GetEnumerator())
{
     $BlockingMovesToTry[ $e.key -replace 'O','X' ] = $e.value
}
$StrategicMovesToTry = @{
    '.... ....' = 4
}

#
# Set a button to the initialized state
#
function InitButton ($button, $buttonNumber)
{
    $button.Text = $buttonNumber
    $button.BackColor = $form.Backcolor
    $button.ForeColor = "black"
    $button.Font = $fonts.Normal
    $button.Enabled = $true
}

function MarkButton ($button, $player)
{
    $button.Enabled = $false
    $button.Text = $player
    $button.Font = $fonts.big
    $button.BackColor = "cyan"
    $button.ForeColor = "black"
}

#
# Reset the game board...
#
function NewGame
{
    $buttonNumber = 1
    $buttons | foreach {
        InitButton $_ ($buttonNumber++)
    }
}

#
# Get the board state as a simple string
#
function getBoardAsString
{
    $result = ""
    foreach ($button in $buttons) {
        $result += $( if ($button.Text -match '[XO]') {$button.Text} else {' '} )
    }
    $result
}

#
# Check for a cat's game (no winner)
#
function CatsGame
{
    if ((getBoardAsString) -notmatch ' ')
    {
        message "`n`nCats Game!`n`nClick OK for a new game.`n"
        NewGame
        return $true
    }
    $false
}

#
# Check to see if any body won...
#
function CheckWin ($buttons, $player)
{
    foreach ($move in $winningMoves)
    {
        $win = $true;
        foreach ($index in $move)
        {
            if ($buttons[$index].Text -notmatch $player)
            {
                $win = $false
                break
            }
        }
        if ($win)
        {
            #
            # Blink the winning row for a while
            # then leave it marked...
            #
            $fg, $bg = "red","white"
            for ($i=0; $i -lt 9; $i++)
            {
                foreach ($index in $move)
                {
                    $buttons[$index].BackColor = $fg
                    $buttons[$index].ForeColor = $bg
                }
                $Form.Update()
                start-sleep -milli 200
                $fg, $bg = $bg, $fg
            }
            
            #
            # Disable the remaining buttons so no more play happens...
            #
            foreach ($button in $buttons)
            {
                $button.Enabled = $false
            }
            return $true
        }
    }
    return $false
}

#
# Figure out the computer's next move...
#
$MoveGenerator = new-object random (get-date).millisecond
function ComputersMove
{
    $board = GetBoardAsString

    # look for potential wins first...
    foreach ($e in $WinningMovesToTry.GetEnumerator())
    {
        if ($board -match $e.key)
        {
            MarkButton $buttons[$e.value] O
            return
        }
    }
    
    # Check blocking moves next...
    foreach ($e in $BlockingMovesToTry.GetEnumerator())
    {
        if ($board -match $e.key)
        {
            MarkButton $buttons[$e.value] O
            return
        }
    }
    
    # Check strategic moves next...
    foreach ($e in $StrategicMovesToTry.GetEnumerator())
    {
        if ($board -match $e.key)
        {
            MarkButton $buttons[$e.value] O
            return
        }
    }
    
    # Otherwise just pick a move at random...
    $limit=100
    while ($limit--)
    {
        $move = $MoveGenerator.next(0,8)
        if ($board[$move] -match ' ')
        {
            MarkButton $buttons[$move] O
            return
        }
    }
    message "ERROR - no valid move found!"
}

#
# Define the button click callback...
#
$buttonClick = {
    if ( CatsGame ) { return }
    
    MarkButton $this X
    if (CheckWin $buttons X)
    {
        message "`nCongradulations!`nYou WIN!!!`n`n`n"
        return
    }
    
    if ( CatsGame ) { return }
    
    ComputersMove
    if (CheckWin $buttons O)
    {
        message "`nToo bad!`nYou lost :-(`n`n`n"
        return
    }
        
    CatsGame
}

#
# now build up the form...
#
$buttons = @()
$buttonNumber = 0
$xPos = 12
$yPos = 30
for ($x=0; $x -lt 3; $x++)
{
    for ($j=0; $j -lt 3; $j++)
    {
        $button = Form Button @{
                Location = Point $xPos $yPos
                Size = Size 50 50 
                                BackColor = $form.BackColor
                TabIndex = $buttonNumber++
            }
        $button.Add_Click($buttonClick)
            
        InitButton $button $buttonNumber    
        $xPos = rightEdge $button 12
        $lastControl = $button
        $Form.Controls.Add($button)
        $buttons += $button
    }
    
    $yPos = bottomEdge $lastControl 12
    $xPos = 12
}
    
$menu = new-menustrip $Form {
    new-menu File {
        new-menuitem "New Game" { NewGame }
        new-separator
        new-menuitem Quit { $Form.Close() }
    }
}

$form.controls.add($menu)

# MainForm
$Form.ClientSize = Size (RightEdge $lastControl 12) (BottomEdge $lastControl 12)

$form.Add_Shown({$form.Activate()})
[void] $form.ShowDialog()
