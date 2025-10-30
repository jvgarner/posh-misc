<#
.SYNOPSIS
  Get the current date in ISO format eg YYYY-MM-DD
.PARAMETER Date
  Override the return date.
.OUTPUTS
  System.String
.EXAMPLE
  Get-IsoDate
  Output: 2025-10-25
.EXAMPLE 
  Get-IsoDate '2010-4-5'
  Output: 2010-04-05
.EXAMPLE 
  Get-IsoDate 'jan 5'
  Output: 2010-01-05
#>
function Get-IsoDate 
{
    Param(
        [Parameter(ValueFromPipeline = $true, Position = 0)]
        [Alias("d")]
        [DateTime]$Date = (Get-Date)
    )
    $Date.ToString('yyyy-MM-dd')
}

New-Alias gid Get-IsoDate 
Export-ModuleMember -Function * -Alias * 