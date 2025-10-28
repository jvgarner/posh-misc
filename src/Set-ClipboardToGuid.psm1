<#
.SYNOPSIS
    Place a guid into the clipboard.
.EXAMPLE
    Set-GuidToClipboard
#>
function Set-GuidToClipboard { 
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
New-Alias -Name guidclip -value Set-GuidToClipboard
New-Alias -Name guidscb -value Set-GuidToClipboard
Export-ModuleMember -Function * -Alias *