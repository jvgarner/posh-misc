<#
.SYNOPSIS
    Place the current location into the clipboard.
.EXAMPLE
    Set-ClipboardToLocation
#>
function Set-ClipboardToLocation { 
    Get-Location | Set-Clipboard 
}

New-Alias -Name pwdscb -value Set-ClipboardToLocation
Export-ModuleMember -Function * -Alias *