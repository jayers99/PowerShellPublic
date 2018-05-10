$computers = "dcont07"

foreach ($computer in $computers) {
    write-host `n

    if (Test-Connection -ComputerName $computer -Quiet) 
    {
        write-host Processing server $computer -ForegroundColor yellow
        $Opt = New-CimSessionOption -Protocol Dcom
        $Session = New-CimSession -ComputerName $computer -SessionOption $Opt

        $OS = Get-CimInstance -Class Win32_OperatingSystem –CimSession $session
        $OS1 = Get-CimInstance -class Win32_PhysicalMemory –CimSession $session |Measure-Object -Property capacity -Sum
        $Bios = Get-CimInstance -Class Win32_BIOS –CimSession $session
        $SerialNumber = $Bios | Select-Object -ExpandProperty serialnumber
        $CS = Get-CimInstance -Class Win32_ComputerSystem –CimSession $session
        $CPU = Get-CimInstance -Class Win32_Processor –CimSession $session
        $drives = Get-CimInstance -Class Win32_LogicalDisk –CimSession $session
        $OSRunning = $OS.caption + " " + $OS.OSArchitecture + " SP " + $OS.ServicePackMajorVersion
        $TotalAvailMemory = ([math]::round(($OS1.Sum / 1GB),2))
   
        $TotalMem = "{0:N2}" -f $TotalAvailMemory
        $date = Get-Date

    
    } else {
        write-host "computer off line"
    }
}
