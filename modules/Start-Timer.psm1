<#
.SYNOPSIS
  Start a timer in the background.
.PARAMETER TimeSpanText
  The length of time to set the timer for. Accepts values like '1h30m15s', '45m', or '10s', etc.
.PARAMETER Message
  The message to display when the timer is complete.
#>
function Start-Timer {
    param (
        [Parameter(Mandatory, Position = 0)]
        [string]
        $TimeSpanText,

        [Parameter()]
        [string]
        $Message = "Timer complete!"
    )
    
    $duration = ConvertTo-TimeSpan $TimeSpanText;
    $now = Get-Date -Format "HH:mm:ss"
    $jobName = "Timer-" + $now + $TimeSpanText 
    Start-Job -Name $jobName -ScriptBlock { 
        param($duration, $Message)
        Start-Sleep -Duration $duration
        $dismissButton = New-BTButton -Content "Dismiss" -Arguments "dismiss"
        New-BurntToastNotification -Text $Message -Button $dismissButton
    } -ArgumentList $duration, $Message | Out-Null
}

New-Alias timer Start-Timer
Export-ModuleMember -Function * -Alias *