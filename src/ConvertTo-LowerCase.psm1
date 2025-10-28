<#
.SYNOPSIS
  Lowercase the input
.DESCRIPTION
  Lowercase the input
.INPUTS
  System.String[]
.OUTPUTS
  Input as Lowercase
#>

function ConvertTo-LowerCase {
    Param(
        [Parameter(ValueFromPipeline = $true, Position = 0)]
        [string]$Input = ""
    )
    
    return $Input.ToLower();
}

New-Alias -Name lc -value ConvertTo-LowerCase
Export-ModuleMember -Function ConvertTo-LowerCase -Alias lc