<#
.SYNOPSIS
    Add a journal entry to the journal file.
.EXAMPLE
    Add-JournalEntry
.PARAMETER Entry
  The text to add to today's journal file.
#>
function Add-JournalEntry { 
    Param(
        [Parameter(ValueFromPipeline = $true, Mandatory = $true, Position = 0)]
        [String]$JournalEntry
        #,
        # [Parameter(ValueFromPipeline = $true, Mandatory=$false, Position = 1)]
        # [string]$Tags = ''
    )
    $date = (Get-Date 0:00).AddDays(-([int](Get-date).DayOfWeek)+1).ToString("yyyy-MM-dd");
    $filename = $date + ".txt";
    $path = Join-Path $env:DID_JOURNAL_PATH $filename;

    if (-not(Test-Path $path -PathType Leaf))
    {
        try {
            $null = New-Item -ItemType File -Path $path -Force -ErrorAction Stop
            Write-Host "The file [$path] has been created."
        }
        catch {
            throw $_.Exception.Message
        }
    }
    $fullEntry = "[" + (Get-Date).ToString("o") + "] " + $JournalEntry;
    Add-Content -Path $path -Value $fullEntry
}

New-Alias -Name aje -value Add-JournalEntry
Export-ModuleMember -Function Add-JournalEntry -Alias aje