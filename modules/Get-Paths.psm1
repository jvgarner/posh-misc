<#
.SYNOPSIS
  Get path environment variable split into one per line.
.OUTPUTS
  System.String
.EXAMPLE
  Get-Paths
  Output:
    C:\Program Files\PowerShell\7
    C:\WINDOWS\system32
    C:\WINDOWS
    C:\WINDOWS\System32\Wbem
    C:\WINDOWS\System32\WindowsPowerShell\v1.0\
    # etc
#>
function Get-Paths
{ 
    $env:path -split ";" 
}

New-Alias paths Get-Paths
Export-ModuleMember -Function * -Alias * 