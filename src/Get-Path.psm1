<#
.SYNOPSIS
Get path vars as a list.

.DESCRIPTION
Get path vars as a list.

#>

function Get-Path 
{ 
    $env:path -split ";" 
}