<#
.SYNOPSIS
    Place a guid into the clipboard.
.EXAMPLE
    Set-ClipboardToGuid
#>
function Set-ClipboardToGuid { 
    Get-Guid | Set-Clipboard 
}

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
New-Alias -Name guidscb -value Set-ClipboardToGuid
Export-ModuleMember -Function * -Alias *