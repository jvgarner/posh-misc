<#
.SYNOPSIS
  Gets the size of a directory in bytes.
.PARAMETER Path
  The path of the directory.
.PARAMETER HumanReadable
  Output the value as a human readable string eg 1KB instead of 1024.
.INPUTS
  System.String
.OUTPUTS
  System.String
.EXAMPLE
  Get-DirectorySize
  Output: 124793
.EXAMPLE
  Get-DirectorySize -HumanReadable
  Output: 121.87 KB
.EXAMPLE
  gds -h
  Output: 121.87 KB
#>
function Get-DirectorySize
{
    Param(
        [Parameter(ValueFromPipeline = $true, Position = 0)]
        [string]$Path = ".",

        [Parameter(Mandatory = $false)]
        [Alias("h")]
        [switch]$HumanReadable
    )
    
    # $requiredModule = 'Get-HumanReadableBytes'
    # if (-not (Get-Module -ListAvailable -Name $requiredModule)) {
    #     Write-Error "Required module '$requiredModule' is not installed. Aborting execution."
    #     return
    # }

    $actualSize = (Get-ChildItem $Path -Recurse -Force | Measure-Object -Property Length -Sum).Sum
    if($HumanReadable)
    {
        return Get-HumanReadableBytes($actualSize)
    }
    return $actualSize
}

New-Alias gds Get-DirectorySize
Export-ModuleMember -Function * -Alias * 