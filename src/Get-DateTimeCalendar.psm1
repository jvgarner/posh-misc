<#
.SYNOPSIS
    Show current date and time and calendar.
.EXAMPLE
    Get-DateTimeCalendar
#>
Function Get-DateTimeCalendar
{
    Get-Date 
    Get-Calendar
}

New-Alias rn Get-DateTimeCalendar
Export-ModuleMember -Function * -Alias *