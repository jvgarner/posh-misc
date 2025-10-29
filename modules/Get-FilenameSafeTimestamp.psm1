<#
.SYNOPSIS
  Create a string that can be used in a filename from a DateTime.
.DESCRIPTION
  Create a string that can be used in a filename from a DateTime.
.PARAMETER Date
  The date and time to use - defaults to current.
.PARAMETER ReplacementValue
  The string to replace instances of ':' with.
.INPUTS
  DateTime
.OUTPUTS
  String
#>
function Get-FileNameSafeTimeStamp {
    Param(
        [Parameter(ValueFromPipeline = $true, Position = 0)]
        [DateTime]$Date = (Get-Date),

        [Parameter(Mandatory=$false)]
        [string]$ReplacementValue = '.'
    )

    return $Date.ToString('o').Replace(':', $ReplacementValue)
}

New-Alias fsts Get-FileNameSafeTimeStamp
Export-ModuleMember -Function * -Alias * 