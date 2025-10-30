<#
.SYNOPSIS
  Converts input text to lowercase.
.DESCRIPTION
  Converts input text to lowercase. Uses the current culture of the system.
.PARAMETER Text
  The string to convert to lowercase.
.INPUTS
  System.String
.OUTPUTS
  System.String
.EXAMPLE
  ConvertTo-LowerCase "ABC"
  Output: abc
.EXAMPLE
  "HELLO" | ConvertTo-LowerCase
  Output: hello
.LINK
ConvertTo-UpperCase
#>
function ConvertTo-LowerCase {
    Param(
        [Parameter(ValueFromPipeline = $true, Mandatory = $true, Position = 0)]
        [string]$Text
    )

    process {
        Write-Output $Text.ToLower()
    }
}

New-Alias lc ConvertTo-LowerCase 
Export-ModuleMember -Function * -Alias * 