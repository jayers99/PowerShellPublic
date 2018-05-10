#
# Windows PowerShell in Action
#
# Chapter 10 Create example XML file.
#
# Create the XML file used in some of the examples.
#

@'
<top BuiltBy = "Windows PowerShell">
    <a pronounced="eh">
        one
    </a>
    <b pronounced="bee">
        two
    </b>
    <c one="1" two="2" three="3">
        <one>
            1
        </one>
        <two>
            2
        </two>
        <three>
            3
        </three>
    </c>
    <d>
        Hello there world
    </d>
</top>
'@ > $PWD\fancy.xml

