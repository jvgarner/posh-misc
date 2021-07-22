<#
.SYNOPSIS
    Get all journal entries in the journal file.
.EXAMPLE
    Get-JournalEntries
#>
function Get-JournalEntries { 
    Param(
        [Parameter(ValueFromPipeline = $true, Mandatory = $false, Position = 0)]
        [Int64]$WeeksBack = 0
    )
    $date = (Get-Date 0:00).AddDays(-([int](Get-date).DayOfWeek)+1).AddDays(-1 * $WeeksBack * 7).ToString("yyyy-MM-dd");
    $filename = $date + ".txt";
    $path = Join-Path $env:DID_JOURNAL_PATH $filename;

    if (-not(Test-Path $path -PathType Leaf)) {
        try {
            Write-Host "No journal entries available. File [$path] not found."
        }
        catch {
            throw $_.Exception.Message
        }
    }
    else {
        Get-Content $path 
    }
}

New-Alias -Name gje -value Get-JournalEntries
Export-ModuleMember -Function Get-JournalEntries -Alias gje