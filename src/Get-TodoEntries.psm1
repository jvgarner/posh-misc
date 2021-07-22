<#
.SYNOPSIS
    Get all Todo entries in the todo file.
.EXAMPLE
    Get-TodoEntries
#>
function Get-TodoEntries { 
    Param(
        [Parameter(ValueFromPipeline = $true, Mandatory = $false, Position = 0)]
        [switch]$IncludeDone = $false
    )
    # $date = (Get-Date 0:00).AddDays(-([int](Get-date).DayOfWeek)+1).AddDays(-1 * $WeeksBack * 7).ToString("yyyy-MM-dd");
    # $filename = $date + ".txt";
    # $path = Join-Path $env:DID_JOURNAL_PATH $filename;
    $path = $env:DO_FILE_PATH
    if (-not(Test-Path $path -PathType Leaf)) {
        try {
            Write-Host "No todo entries available. File [$path] not found."
        }
        catch {
            throw $_.Exception.Message
        }
    }
    elseif ($IncludeDone){
        Get-Content $path 
    } else {
        Get-Content $path | Select-String -NotMatch -Pattern "@done" -Raw
    }
}

New-Alias -Name gte -value Get-TodoEntries
Export-ModuleMember -Function Get-TodoEntries -Alias gte