<#
.SYNOPSIS
  Uppercase the text
.DESCRIPTION
  Uppercase the text
.INPUTS
  System.String[]
.OUTPUTS
  Text as uppercase
#>

function ConvertTo-UpperCase {
    Param(
        [Parameter(ValueFromPipeline = $true, Position = 0)]
        [string]$Text
    )
    
    return $Text.ToUpper();
}

Set-Alias uc ConvertTo-UpperCase
Export-ModuleMember -Function * -Alias * 