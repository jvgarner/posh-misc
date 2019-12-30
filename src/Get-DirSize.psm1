<#
.SYNOPSIS
  Gets the size of a directory.
.DESCRIPTION
  Gets the size of a directory.
.PARAMETER Path
  The path of the directory to get the size of.
.PARAMETER HumanReadable
  Output the value as a human readable string.
.INPUTS
  System.String[]
.OUTPUTS
  Size value as number or string.
#>
function Get-DirSize
{
    Param(
        [Parameter(ValueFromPipeline = $true, Position = 0)]
        [string]$Path = ".",

        [Parameter(Mandatory = $false)]
        [Alias("h")]
        [switch]$HumanReadable
    )
    $actualSize = (Get-ChildItem $Path -Recurse -Force | Measure-Object -Property Length -Sum).Sum
    if($HumanReadable)
    {
        return Get-HumanReadableBytes($actualSize)
    }
    return $actualSize
}

New-Alias -Name gds -value Get-DirSize
Export-ModuleMember -Function Get-DirSize -Alias gds