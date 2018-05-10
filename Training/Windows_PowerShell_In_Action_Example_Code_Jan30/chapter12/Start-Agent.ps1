#
# Windows PowerShell in Action
#
# Chapter 12 Demonstrate using the MSAgent characters
#
# This script uses COM and the MSAgent characters to
# put on a little animated show.
#

param(
    [DateTime]$StartTime = [datetime]::Now.AddMinutes(10),
    $SessionTitle="Wizzo PowerShell Session",
    $Speaker="Bob"
)

function Invoke-MSAgent
{
    param(
        $Messages="Hello",
        $size=250,
        $CharacterName="Merlin",
        $MoveToX=500,
        $MoveToY=500,
        $StartX=0,
        $StartY=0,
        $Async=$false
    )

    $Random = New-Object System.Random
    $CharacterFileName = Join-path $env:windir `
        "msagent\chars\${CharacterName}.acs"
    $AgentControl = New-Object -COMObject Agent.Control.2
    $AgentControl.Connected=$True
    [void]$AgentControl.Characters.Load(
        $CharacterName, $CharacterFileName)

    $Character = $AgentControl.Characters.Item($CharacterName) 
    $AnimationNames = @($Character.AnimationNames)
    $Character.width = $Character.height=$Size
    $action = $Character.MoveTo($StartX,$StartY)
    $action = $Character.Show()
    $action = $Character.MoveTo($MoveToX,$MoveToY)
    #$action = $Character.Play(
    #    $AnimationNames[$Random.Next($AnimationNames.Count)])
    foreach ($Message in @($Messages))
    {
        $action = $Character.Speak($Message)
    }
    $action = $Character.Hide()
    if (!$Async)
    {
       while ($Character.Visible)
       {
            Start-Sleep -MilliSeconds 250
       }
    }
    $Character = $Null
    $AgentControl.Connected=$False
    $AgentControl = $Null
}

function Invoke-Display()
{
    Invoke-MSAgent $Message -Character (Get-RandomElement $Characters) `
        -Size $CharacterSize `
        -MoveToX $Random.Next(500) -MoveToY $Random.Next(500) `
        -StartX  $Random.Next(500) -StartY  $Random.Next(500)
    Start-Sleep $SleepTime
}

function Get-RandomElement($Array)
{
   $Array[ $Random.Next( $Array.Count ) ]
}

$Sleeptime = 20
$CharacterSize = 250
$WiseCracks=(
    "PowerShell Rocks baby",
    # This is misspelled but it has to be to sound correct
    "Hay Hay, My My, the CLI will never die",
    "Powershell is wicked easy to use",
    "Scripting to Infinity and beyond!",
    "Powershell is like, ya know, wicked consistent",
    ("fish heads, fish heads, rolly polly fish heads" +
      "fish heads, fish heads, eat them up yumm"),
    "We like questions, ask them",
    ("Powershell has direct support for " +
        "WMI, ADO, ADSI, XML, COM, and .NET"),
    "Hush up or I'll replace you with a 2 line Powershell script",
    "PowerShell goes to 11",
    "Dude! This totally rocks!",
    "Manning Books are cool!",
    "triple panic abort"
)

# Leverages the .NET Random number generator
$Random=New-Object Random

# Characters are found in .ACS files 
$Path = $(Join-Path $env:windir "msagent\chars\*.acs")
$Characters=@(dir $Path |
    foreach {($_.Name.Split("."))[0]})

while ($True)
{
    $till = $StartTime - [DateTime]::now
    if ($till.TotalSeconds -le 0)
    {
        # Now it is time to go so let's get it going
        $Message = "hay $Speaker, Start the session!!"
        $SleepTime = 10
        $CharacterSize = 600
        while ($true)
        {
            Invoke-Display
        }
    }

    $Message = "$SessionTitle will start in $($Till.Minutes) " +
        "minutes and $($till.Seconds) seconds"
    Invoke-Display

    $Message = Get-RandomElement $WiseCracks 
    Invoke-Display

    $Message = Get-RandomElement $WiseCracks
    Invoke-Display
}



