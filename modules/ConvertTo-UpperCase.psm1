<#
.SYNOPSIS
  Converts input text to uppercase. Uses the current culture of the system.
.PARAMETER Text
  The string to convert to uppercase.
.INPUTS
  System.String
.OUTPUTS
  System.String
.EXAMPLE
  ConvertTo-UpperCase "abc"
  Output: ABC
.EXAMPLE
  "hello" | ConvertTo-upperCase
  Output: HELLO
.LINK
  ConvertTo-LowerCase
#>
function ConvertTo-UpperCase {
    Param(
        [Parameter(ValueFromPipeline = $true, Mandatory = $true, Position = 0)]
        [string]$Text
    )
    
    return $Text.ToUpper();
}

New-Alias uc ConvertTo-UpperCase
Export-ModuleMember -Function * -Alias * 