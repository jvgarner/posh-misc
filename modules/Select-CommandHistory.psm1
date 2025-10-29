function Select-CommandHistory {
    Param(
        [Parameter(ValueFromPipeline = $false, Mandatory = $true, Position = 0)]
        [string]$SearchString,

        [Parameter(ValueFromPipeline = $false, Mandatory = $false, Position = 1)]
        [int]$MaxResults = 10
    )
    
    $historyPath = (Get-PSReadlineOption).HistorySavePath
    $list = Get-Content $historyPath | Select-String $SearchString

    $list | Select-Object -First $MaxResults

}

New-Alias sh Select-CommandHistory
Export-ModuleMember -Function * -Alias * 