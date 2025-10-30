<#
.SYNOPSIS
  Create a string that can be used in a filename from a DateTime.
.DESCRIPTION
  Create a string that can be used in a filename from a DateTime.
.PARAMETER Date
  The date and time to use - defaults to current.
.PARAMETER Delimiter
  The string to replace instances of ':' with - defaults to an empty string.
.INPUTS
  DateTime
.OUTPUTS
  String
.EXAMPLE
  Get-FileNameSafeTimeStamp
  Output: 2025-10-30T114625.2337270-0400
.EXAMPLE
  Get-FileNameSafeTimeStamp -Delimiter '.'
  Output: 2025-10-30T11.47.56.8767106-04.00
.EXAMPLE 
  fsts -d 🕛
  Output: 2025-10-30T11🕛49🕛04.4076587-04🕛00
#>
function Get-FileNameSafeTimeStamp {
    Param(
        [Parameter(ValueFromPipeline = $true, Position = 0)]
        [DateTime]$DateTime = (Get-Date),

        [Parameter(Mandatory=$false)]
        [Alias("d")]
        [string]$Delimiter = ''
    )

    return $DateTime.ToString('o').Replace(':', $Delimiter)
}

New-Alias fsts Get-FileNameSafeTimeStamp
Export-ModuleMember -Function * -Alias * 