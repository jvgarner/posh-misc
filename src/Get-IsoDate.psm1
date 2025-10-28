<#
.SYNOPSIS
Get the current date in ISO format

.DESCRIPTION
Get the current date in ISO format eg YYYY-MM-DD

#>

function Get-IsoDate 
{ 
    Get-Date -UFormat '+%Y-%m-%d'
}

Set-Alias gid Get-IsoDate 
Export-ModuleMember -Function * -Alias * 