<#
.SYNOPSIS
  Uppercase the input
.DESCRIPTION
  Uppercase the input
.INPUTS
  System.String[]
.OUTPUTS
  Input as uppercase
#>

function ConvertTo-UpperCase {
    Param(
        [Parameter(ValueFromPipeline = $true, Position = 0)]
        [string]$Input = ""
    )
    
    return $Input.ToUpper();
}

New-Alias -Name uc -value ConvertTo-UpperCase
Export-ModuleMember -Function ConvertTo-UpperCase -Alias uc