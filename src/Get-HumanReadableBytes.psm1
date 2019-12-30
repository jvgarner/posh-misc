<#
.SYNOPSIS
  Display bytes in a human-readable format
.PARAMETER Bytes
  The bytes to display.  
.INPUTS
  Int64
.OUTPUTS
  String
#>
function Get-HumanReadableBytes
{
    Param(
        [Parameter(ValueFromPipeline = $true, Mandatory = $true, Position = 0)]
        [Int64]$Bytes
    )
    $suffix = "B", "KB", "MB", "GB", "TB", "PB", "EB", "ZB", "YB"
    $i = 0
    while ($Bytes -gt 1kb) 
    {
        $Bytes = $Bytes / 1kb
        $i++
    } 

    "{0:N1} {1}" -f $Bytes, $suffix[$i]
}

Export-ModuleMember -Function Get-HumanReadableBytes