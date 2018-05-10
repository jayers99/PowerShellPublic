#
# Windows PowerShell in Action
#
# Chapter 8 Script to add a CustomClass "keyword" to PowerShell
#
# This script defines a set of functions in the global namespace
# that add the adility to create custom classes in PowerShell.
#

$global:__ClassTable__ = @{}

function global:__new_instance ([scriptblock] $definition)
{

    function elementSyntax ($msg)
    {
        throw "class element syntax: $msg"
    }

    function note ([string]$name, $value)
    {
        if (! $name)
        {
            elementSyntax "note name <value>"
        }
        new-object management.automation.PSNoteProperty `
            $name,$value
    }

    function method ([string]$name, [scriptblock] $script)
    {
        if (! $name) {
            elementSyntax "method name <value>"
        }
        new-object management.automation.PSScriptMethod `
            $name,$script
    }

    $object = new-object Management.Automation.PSObject

    $members = &$definition

    foreach ($member in $members) {
        if (! $member) {
            write-error "bad member $member"
        } else {
            $object.psobject.members.Add($member)
        }
    }

    $object
}

function global:CustomClass
{
    param ([string] $type, [scriptblock] $definition)

    if ($global:__ClassTable__[$type]) {
        throw "type $type is already defined"
    }

    # create and discard an instance to make sure the
    # definition scriptblock is valid.
    __new_instance $definition > $null

    # add the definition to the instance table.
    $global:__ClassTable__[$type] = $definition
}

function global:new ([string] $type)
{
    $definition = $__ClassTable__[$type]
    if (! $definition) {
        throw "$type is undefined"
    }
    __new_instance $definition
}

function remove-class ([string] $type)
{
    $__ClassTable__.remove($type)
}

