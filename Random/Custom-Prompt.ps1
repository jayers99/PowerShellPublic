# my favorite
function prompt {Write-Host 'PS> ' -NoNewline -ForegroundColor Yellow; return ""}

function prompt {'PS> '}


function Prompt
{
    $promptString = "PS >"
    Write-Host $promptString -NoNewline -ForegroundColor Yellow
    return " "
}

function prompt {"[$env:USERNAME@$env:COMPUTERNAME]:$(Split-Path $(Get-Location) -Leaf) PS> "}

function prompt {"PS [$env:USERNAME@$env:COMPUTERNAME] $(Split-Path $(Get-Location) -Leaf) >`r`n"}





 