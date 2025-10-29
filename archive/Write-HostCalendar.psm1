<#
.SYNOPSIS
    Show calendar. Similar to cal in *nix but does not support any options. 
    Does not output objects and intended for visual use only.
.EXAMPLE
    Write-HostCalendar
.EXAMPLE
    Write-HostCalendar -Date 2025-01-15
#>
Function Write-HostCalendar
{
    # TODO: Add "A" parameter
    Param(
        [Parameter(Position=0)]
        [DateTime]$Date = (Get-Date)
    )

    $dateFormat = new-object System.Globalization.DateTimeFormatInfo
    $title = (Get-Date($date) -Format $dateFormat.YearMonthPattern)
    Write-Host -NoNewline $title.PadLeft(((21 - $title.Length) / 2) + $title.Length)
    Write-Host ""

    # output headers with two character values
    for($i=0; $i -le 6; $i++) {
        Write-Host -NoNewline (" " +  $dateFormat.AbbreviatedDayNames[$i].Substring(0,2))
    }

    # Get colours so we can invert them for the current day
    $bgc = [Console]::ForegroundColor
    $fgc = [Console]::BackgroundColor

    [DateTime]$first = [DateTime]::new($date.Year, $date.Month, 1)
    [DateTime]$last = $first.AddMonths(1).AddDays(-1);
    [DateTime]$day=$first
    do {
        Write-Host "" # wrap each week
        for ($i=0; $i -le 6; $i++) {
            if ($day.DayOfWeek.value__ -eq $i -and $day -le $last) {
                if ($day.Date -eq (Get-Date).Date) {
                    Write-Host -NoNewline " "
                    Write-Host -NoNewline ("{0,2}" -f $day.Day.ToString()) -ForegroundColor $fgc -BackgroundColor $bgc
                } else { 
                    Write-Host -NoNewline ("{0,3}" -f $day.Day.ToString())
                }
                $day = $day.AddDays(1)
            } else {
                Write-Host -NoNewline "   "
            }
        }
    }
    While ($day -le $last)
    Write-Host "`n" # force empty line at end
}

#New-Alias cal Write-HostCalendar
Export-ModuleMember -Function * -Alias *