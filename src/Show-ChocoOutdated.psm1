<#
.SYNOPSIS
Show a notification if there are outdated Choco packages

.DESCRIPTION
Show a notification if there are outdated Choco packages

.EXAMPLE
Show-ChocoOutdated

.NOTES
Depends on burnt toast
#>
function Show-ChocoOutdated {

    $ErrorActionPreference = "Stop"
    Import-Module -Name BurntToast

    $outdated = (choco outdated -r | Select-String '^([^|]+)|.*$').Matches | ForEach-Object {$_.Value}
    $pretty = ($outdated -join ', ')

    If ($outdated.count -gt 0) {
        New-BurntToastNotification -Text "Outdated chocolatey packages", "$pretty"
    }
}

Set-Alias sco Show-ChocoOutdated
Export-ModuleMember -Function * -Alias *