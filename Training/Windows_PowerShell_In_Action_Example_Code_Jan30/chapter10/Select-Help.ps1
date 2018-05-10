#
# Windows PowerShell in Action
#
# Chapter 10 The Select-Help function
#
# A function that scans through the command file, searching
# for a particular word in either the command name or the short
# help description.
#

function global:Select-Help ($pat = ".")
{
    $cmdHlp="Microsoft.PowerShell.Commands.Management.dll-Help.xml"
    $doc = "$PSHOME\$cmdHlp"
    $settings = new-object System.Xml.XmlReaderSettings
    $settings.ProhibitDTD = $false
    $reader = [xml.xmlreader]::create($doc, $settings)
    $name = $null
    $capture_name = $false
    $capture_description = $false
    $finish_line = $false
    while ($reader.Read())
    {
        switch ($reader.NodeType)
        {
            ([Xml.XmlNodeType]::Element) {
                switch ($reader.Name)
                {
                    "command:name" {
                        $capture_name = $true
                        break
                    }
                    "maml:description" {
                        $capture_description = $true
                        break
                    }
                    "maml:para" {
                        if ($capture_description)
                        {
                            $finish_line = $true;
                        }
                    }
                }
                break
            }
            ([Xml.XmlNodeType]::EndElement) {
                if ($capture_name) { $capture_name = $false }
                if ($finish_description)
                {
                    $finish_line = $false
                    $capture_description = $false
                }
                break
            }
            ([Xml.XmlNodeType]::Text) {
                if ($capture_name)
                {
                    $name = $reader.Value.Trim()
                }
                elseif ($finish_line -and $name)
                {
                    $msg = $name + ": " + $reader.Value.Trim()
                    if ($msg -match $pat)
                    {
                        $msg
                    }
                    $name = $null
                }
                break
            }
        }
    }
    $reader.close()
}

