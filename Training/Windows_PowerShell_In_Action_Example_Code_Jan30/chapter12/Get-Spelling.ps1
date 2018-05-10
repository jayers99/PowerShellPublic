#
# Windows PowerShell in Action
#
# Chapter 12 Use COM and Word to spell-check a document
#

if ($args.count -gt 0)
{
@"
Usage for Get-Spelling:

Copy some text into the clipboard, then run this script. It
will display the Word spellcheck tool that will let you
correct the spelling on the text you've selected. When you are
done it will put the text back into the clipboard so you can
paste it back into the original document.

"@
    exit 0
}

$shell = new-object -com wscript.shell

# set up Word for our use...
$word = new-object -com word.application
$word.Visible = $false
$doc = $word.Documents.Add()
    
# Copy the contents of the clipboard to Word
$word.Selection.Paste()
    
# See if we need to spell check the text.
# If we do, present the user with the spellcheck dialog,
# otherwise, we do not need to do anything
if ($word.ActiveDocument.SpellingErrors.Count -gt 0)
{
    # Perform the spellcheck
    $word.ActiveDocument.CheckSpelling()
    $word.Visible = $false

    # Select all of the text for copy back to clipboard
    $word.Selection.WholeStory()
    $word.Selection.Copy()
    $shell.PopUp( "The spell check is complete, " +
        "the clipboad holds the corrected text." )
}
else
{
    [void] $shell.Popup("No Spelling Errors were detected.")
}

$x = [ref] 0 
$word.ActiveDocument.Close($x)
$word.Quit()

