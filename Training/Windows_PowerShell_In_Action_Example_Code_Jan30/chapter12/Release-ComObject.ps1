#
# Windows PowerShell in Action
#
# Chapter 12 PowerShell Simple script to release a COM object.
#
# This script illustrates how to explicitly release a COM object.
# Although the memory manager will eventually release
# the object for you when it is garbage-collected, that
# may not happen for some significant amount of time.
# By calling this script on the object, the underlying COM
# object will be released immediately and it's resources
# will be freed.

param ($objectToRelease)
[void][System.Runtime.Interopservices.Marshal]::ReleaseComObject(
    $objectToRelease)
