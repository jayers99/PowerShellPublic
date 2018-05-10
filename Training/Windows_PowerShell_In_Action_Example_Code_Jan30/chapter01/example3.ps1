#
# Windows PowerShell in Action
#
# Chapter 1 Example 3
#
# Downloads the RSS feed for the PowerShell team
# blog. This example requires network connectivity
# and the time it takes to run is subject to the
# network contitions...
#

([xml](new-object net.webclient).DownloadString(
"http://blogs.msdn.com/powershell/rss.aspx"
)).rss.channel.item | format-table title,link

