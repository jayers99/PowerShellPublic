#
# Windows PowerShell in Action
#
# Chapter 11 Invoke-WebServer script
#
# This script implements a toy webserver application
# written in PowerShell. by default, it listens on port 80.
# To try it out, run the script and then open
#   http://localhost/3*15
# in you web browser.
#

param($port=80) 

[void][reflection.Assembly]::LoadWithPartialName("System.Net.Sockets")  

function html ($content, $title)
{
    @"
    <html>
        <head>
            <title>Example PowerShell Web Server Page</title>
        </head>
        <body>
        $content
        </body>
    </html>
"@
}

function SendResponse($sock, $string)  
{ 
    if ($sock.Connected) 
    { 
        $bytesSent = $sock.Send([text.Encoding]::Ascii.GetBytes($string))  
        if ( $bytesSent -eq -1 ) 
        { 
            Write-Host ("Send failed to " + $sock.RemoteEndPoint)
        } 
        else 
        { 
            Write-Host ("Sent $bytesSent bytes to " + $sock.RemoteEndPoint)
        } 
    } 
} 

function SendHeader(
    [net.sockets.socket] $sock,
    $length, 
    $statusCode = "200 OK",
    $mimeHeader="text/html",
    $httpVersion="HTTP/1.1"
)
{ 
    $response = "HTTP/1.1 $statusCode`r`nServer: " +
        "Localhost`r`nContent-Type: $mimeHeader`r`n" +
        "Accept-Ranges:bytes`r`nContent-Length: $length`r`n`r`n"
    SendResponse $sock $response
    write-host "Header sent"
} 

$server = [System.Net.Sockets.TcpListener]$port 
$server.Start() 

$buffer = new-object byte[] 1024  

write-host "Press any key to stop Web Server..."
while($true) 
{ 
    if ($host.ui.rawui.KeyAvailable)
    {
        write-host "Stopping server..."
        break
    }

    if($server.Pending())
    {
        $socket = $server.AcceptSocket()
    }
     
    if ( $socket.Connected )
    {
        write-host ("Connection at {0} from {1}." -f
            (get-date), $socket.RemoteEndPoint )

        [void] $socket.Receive($buffer, $buffer.Length, '0')
        $received = [Text.Encoding]::Ascii.getString($buffer) 

        $received = [regex]::split($received, "`r`n")
        $received = @($received -match "GET")[0]
        if ($received)  
        {
            $expression = $received -replace "GET */" -replace
                'HTTP.*$' -replace '%20',' '

            if ($expression -match '[0-9.]+ *[-+*/%] *[0-9.]+') 
            { 
                write-host "Expression: $expression"

                $expressionResult = . {
                    invoke-expression $expression
                    trap {
                        write-host "Expression failed: $_"
                        "error"
                        continue
                    }
                }
                write-host "Expression result: $expressionResult"

                $result = html @"
                    <table border="2">
                    <tr>
                    <td>Expression</td>
                    <td>$expression</td>
                    </tr>
                    <tr>
                    <td>Result</td>
                    <td>$expressionResult</td>
                    </tr>
                    <tr>
                    <td>Date</td>
                    <td>$(get-date)</td>
                    </tr>
                    </table>
"@
            }
            else
            {
                $message = 'Type expression to evaluate like:'
                $link = '<a href="http://localhost/3*5">' +
                    'http://localhost/3*5</a>'
                $result = html @"
                    <table border="2">
                    <tr>
                    <td>$message</td>
                    <td>$link</td>
                    </tr>
                    <tr>
                    <td>Date</td>
                    <td>$(get-date)</td>
                    </tr>
                    </table>
"@
            }
            SendHeader $socket $result.Length
            SendResponse $socket $result
        }
         
        $socket.Close()
    }
    else
    {
        start-sleep -milli 100
    }
}

$server.Stop() 
write-host "Server stopped..."
