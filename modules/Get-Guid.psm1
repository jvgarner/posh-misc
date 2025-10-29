<#
.SYNOPSIS
    Generate a guid.
.EXAMPLE
    Get-Guid
#>
function Get-Guid {
    [guid]::NewGuid().ToString().ToUpperInvariant()
}

New-Alias -Name guid -value Get-Guid
Export-ModuleMember -Function * -Alias *