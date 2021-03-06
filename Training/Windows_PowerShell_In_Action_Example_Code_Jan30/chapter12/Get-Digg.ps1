#
# Windows PowerShell in Action
#
# Chapter 12 Get an RSS feed using COM
#
# This script defines a function to read an RSS feed
# using COM. It then uses the function to read the Digg
# feed and format the result into an HTML page with a set
# links to the feed articles.
#

function Get-ComRSS
{
    param($url = $(throw "You must specify a feed URL to read"))

    $objHTTP = new-object -com winhttp.winhttprequest.5.1
    $objHTTP.Open("GET",$url,$false)
    $objHTTP.SetRequestHeader("Cache-Control", 
        "no-store, no-cache, must-revalidate")
    $objHTTP.SetRequestHeader("Expires",
        "Mon, 26 Jul 1997 05:00:00 GMT")
    $objHTTP.Send()
    $xmlResult = [xml]$objHTTP.ResponseText
    $xmlResult.rss.channel.item | select-object title,link
}

#
# Now use the function to read the Digg feed.
#

$url = "http://digg.com/rss/containertechnology.xml"
filter fmtData {"<p><a href=`"{0}`">{1}</a></p>" -f $_.link,$_.title }

@"
    <html>
	<head>
	    <title>Digg RSS Feed</title>
	</head>
	<body>
	    <p><b>Digg RSS Feeds on $(get-date)</b></p>
	    <ul>
	    $(comrss $url | fmtData)
	</body>
    </html>
"@ > $env:temp\digg_rss.htm 

& $env:temp\digg_rss.htm
