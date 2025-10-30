<#
.SYNOPSIS
Show current date and time and calendar.
.EXAMPLE
Get-DateTimeCalendar
Output:
Thursday, October 30, 2025 9:13:10 AM

               October 2025

 Sun   Mon   Tue   Wed   Thu   Fri   Sat
  28    29    30     1     2     3     4
   5     6     7     8     9    10    11
  12    13    14    15    16    17    18
  19    20    21    22    23    24    25
  26    27    28    29    30    31     1
.LINK
Get-Date
Get-Calendar
#>
Function Get-DateTimeCalendar
{
    Get-Date 
    Get-Calendar
}

New-Alias rn Get-DateTimeCalendar
Export-ModuleMember -Function * -Alias *