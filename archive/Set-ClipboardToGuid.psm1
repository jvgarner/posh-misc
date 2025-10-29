<#
.SYNOPSIS
    Place a guid into the clipboard.
.EXAMPLE
    Set-ClipboardToGuid
#>
function Set-ClipboardToGuid { 
    Get-Guid | Set-Clipboard 
}

New-Alias -Name guidscb -value Set-ClipboardToGuid
Export-ModuleMember -Function * -Alias *