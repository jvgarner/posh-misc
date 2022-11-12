function Select-History {
    Param(
        [Parameter(ValueFromPipeline = $false, Mandatory = $true, Position = 0)]
        [string]$SearchString
    )
    Get-Content (Get-PSReadlineOption).HistorySavePath | Select-String $SearchString
}

Set-Alias sh Select-History
Export-ModuleMember -Function * -Alias * 