#
# Windows PowerShell in Action
#
# Chapter 11 RSS functions
#
# This script defines a function to download RSS
# feeds and a second function that displays the entries
# as a menu to select.
#

function global:Get-RSS ($url)
{
    $wc = New-Object net.webclient
    $xml = [xml](New-Object net.webclient).DownloadString($url)
    $xml.rss.channel.item| select-object title,link
}

function global:Get-RSSMenu (
    $url="http://blogs.msdn.com/powershell/rss.aspx",
    $number=3
)
{
    $entries = get-rss $url | select-object -first $number
    $links = @()
    $entries | % {$i=0} {
        "$i - " + $_.title
        $links += $_.link
        $i++
    }
    while (1)
    {
        $val = read-host "Enter a number [0-$($i-1)] or q to quit"
        if ($val -eq "q") { return }
        $val = [int] $val
        if ($val -ge 0 -and $val -le $i)
        {
            $link = $links[$val]
            "Opening $link`n"
            explorer.exe $link
        }
    }
}


