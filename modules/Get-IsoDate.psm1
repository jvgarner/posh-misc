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
    $Date.ToString('yyyy-MM-dd')
}

Set-Alias gid Get-IsoDate 
Export-ModuleMember -Function * -Alias * 