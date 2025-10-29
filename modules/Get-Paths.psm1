<#
.SYNOPSIS
Get path vars as a list.

.DESCRIPTION
Get path vars as a list.

#>

function Get-Paths
{ 
    $env:path -split ";" 
}

New-Alias paths Get-Paths
Export-ModuleMember -Function * -Alias * 