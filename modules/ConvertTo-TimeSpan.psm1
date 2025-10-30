<#
.SYNOPSIS
  Converts input text in formats like '1h30m15s', '45m', or '10s' to a TimeSpan object.
.PARAMETER TimeValue
  The input text to convert to a TimeSpan.
.INPUTS
  System.String
.OUTPUTS
  TimeSpan
.EXAMPLE
  ConvertTo-TimeSpan "4h"
  Output:
    Days              : 0
    Hours             : 4
    Minutes           : 0
    Seconds           : 0
    Milliseconds      : 0
    Ticks             : 144000000000
    TotalDays         : 0.166666666666667
    TotalHours        : 4
    TotalMinutes      : 240
    TotalSeconds      : 14400
    TotalMilliseconds : 14400000
.EXAMPLE
  "3h4s" | ConvertTo-TimeSpan
  Output: 
    Days              : 0
    Hours             : 3
    Minutes           : 0
    Seconds           : 4
    Milliseconds      : 0
    Ticks             : 108040000000
    TotalDays         : 0.125046296296296
    TotalHours        : 3.00111111111111
    TotalMinutes      : 180.066666666667
    TotalSeconds      : 10804
    TotalMilliseconds : 10804000
#>
function ConvertTo-TimeSpan {
    param (
        [Parameter(ValueFromPipeline, Mandatory)]
        [string]$TimeValue
    )

    # Initialize values
    $hours = 0
    $minutes = 0
    $seconds = 0

    # Match patterns like 1h, 30m, 15s
    if ($TimeValue -match '((\d+)h)?((\d+)m)?((\d+)s)?') {
        if ($matches[2]) { $hours = [int]$matches[2] }
        if ($matches[4]) { $minutes = [int]$matches[4] }
        if ($matches[6]) { $seconds = [int]$matches[6] }

        return New-TimeSpan -Hours $hours -Minutes $minutes -Seconds $seconds
    } else {
        throw "Invalid format. Use something like '1h30m15s', '45m', or '10s'."
    }
}

Export-ModuleMember -Function * -Alias * 