<#
.SYNOPSIS
  Search the command history.
.PARAMETER Keyword
  The keyword to search for in the command history.
.PARAMETER MaxResults
  The maximum number of results to return - defaults to 10.
.INPUTS
  System.String
.OUTPUTS
  System.String
.EXAMPLE
  "git" | sh
  Output:
    winget install git.git
    git
    git status
    # etc
.EXAMPLE
  Select-CommandHistory "git" 1
  Output:
    winget install git.git
#>
function Select-CommandHistory {
    Param(
        [Parameter(ValueFromPipeline = $true, Mandatory = $true, Position = 0)]
        [string]$Keyword,

        [Parameter(ValueFromPipeline = $false, Mandatory = $false, Position = 1)]
        [int]$MaxResults = 10
    )
    
    $historyPath = (Get-PSReadlineOption).HistorySavePath
    $list = Get-Content $historyPath | Select-String $Keyword

    $list | Select-Object -First $MaxResults

}

New-Alias sh Select-CommandHistory
Export-ModuleMember -Function * -Alias * 