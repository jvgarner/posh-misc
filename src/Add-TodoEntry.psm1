<#
.SYNOPSIS
    Add a todo entry to the todo file.
.EXAMPLE
    Add-TodoEntry
.PARAMETER Entry
  The text to add to today's todo file.
#>
function Add-TodoEntry { 
    Param(
        [Parameter(ValueFromPipeline = $true, Mandatory = $true, Position = 0)]
        [String]$Entry
    )
    $path = $env:DO_FILE_PATH;

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
    $fullEntry = "☐ " + $Entry;
    $fullEntry | Set-Content temptodofile.txt
    Get-Content $path -ReadCount 5000 | Add-Content temptodofile.txt
    Remove-Item $path
    Move-Item -Path temptodofile.txt -Destination $path -Force
    #Add-Content -Path $path -Value $fullEntry
}

New-Alias -Name ate -value Add-TodoEntry
Export-ModuleMember -Function Add-TodoEntry -Alias ate