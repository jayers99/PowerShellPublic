#
# Windows PowerShell in Action
#
# Chapter 10 The Dump-Doc function
#
# Defines a function for displaying an XML document.
#
function global:Dump-Doc ($doc="$PWD\fancy.xml")
{
    $settings = new-object System.Xml.XmlReaderSettings
    $doc = (resolve-path $doc).ProviderPath
    $reader = [xml.xmlreader]::create($doc, $settings)
    $indent=0
    function indent ($s) { "    "*$indent+$s }
    while ($reader.Read())
    {
        if ($reader.NodeType -eq [Xml.XmlNodeType]::Element)
        {
            $close = $(if ($reader.IsEmptyElement) { "/>" } else { ">" })
            if ($reader.HasAttributes)
            {
                $s = indent "<$($reader.Name) "
                [void] $reader.MoveToFirstAttribute()
                do
                {
                    $s += "$($reader.Name) = `"$($reader.Value)`" "
                }
                while ($reader.MoveToNextAttribute())
                "$s$close"
            }
            else
            {
                indent "<$($reader.Name)$close"
            }
            if ($close -ne '/>') {$indent++}
        }
        elseif ($reader.NodeType -eq [Xml.XmlNodeType]::EndElement )
        {
            $indent--
            indent "</$($reader.Name)>"
        }
        elseif ($reader.NodeType -eq [Xml.XmlNodeType]::Text)
        {
            indent $reader.Value
        }
    }
    $reader.close()
}

