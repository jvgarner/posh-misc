<#
.SYNOPSIS
  Display bytes in a human-readable format
.PARAMETER Bytes
  The bytes to display.  
.INPUTS
  Decimal
.OUTPUTS
  String
#>
function Get-HumanReadableBytes {
    Param(
        [Parameter(ValueFromPipeline = $true, Mandatory = $true, Position = 0)]
        [Decimal]$Bytes
    )

    $suffix = "B", "KB", "MB", "GB", "TB", "PB", "EB", "ZB", "YB"
    $i = 0
    while ($Bytes -ge 1024 -and $i -lt $suffix.Length - 1) {
        $Bytes = $Bytes / 1024
        $i++
    }

    "{0:N2} {1}" -f $Bytes, $suffix[$i]
}

Export-ModuleMember -Function * -Alias *