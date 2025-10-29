<#
.SYNOPSIS
  Lowercase the text
.DESCRIPTION
  Lowercase the text
.INPUTS
  System.String[]
.OUTPUTS
  Text as Lowercase
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

Set-Alias lc ConvertTo-LowerCase 
Export-ModuleMember -Function * -Alias * 