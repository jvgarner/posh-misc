<#
.SYNOPSIS
    Show current date and time and calendar.
.EXAMPLE
    Write-HostDateTimeCalendar
#>
Function Write-HostDateTimeCalendar
{
    Get-Date 
    Write-HostCalendar
}

New-Alias rn Write-HostDateTimeCalendar
Export-ModuleMember -Function * -Alias *