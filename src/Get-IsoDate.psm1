<#
.SYNOPSIS
Get the current date in ISO format

.DESCRIPTION
Get the current date in ISO format eg YYYY-MM-DD

#>

function Get-IsoDate 
{
    Param(
        [Parameter(ValueFromPipeline = $true, Position = 0)]
        [DateTime]$Date = (Get-Date)
    )
    #Get-Date -UFormat '+%Y-%m-%d'
    $Date.TryFormat('+%Y-%m-%d')
}

Set-Alias gid Get-IsoDate 
Export-ModuleMember -Function * -Alias * 