<#
.SYNOPSIS
  Generate a version 4 UUID string. The guid generated is a Version 4 UUID (Universally Unique Identifier).
.OUTPUTS
  System.String
.PARAMETER UpperCase
  Output the guid with uppercase letters.
.EXAMPLE
  Get-Guid
  Output: 307d054a-5698-4c1e-9016-056c93fb5b29
.EXAMPLE
  Get-Guid -UpperCase
  Output: 8D2A76B4-87B2-4E11-B601-A17478D581BE
.EXAMPLE
  guid -u
  Output: 224CFCAD-0661-4052-80E9-C8C50FF81311
#>
function Get-Guid {
    Param(
        [Parameter(Mandatory = $false)]
        [Alias("u")]
        [switch]$UpperCase
    )
    
    if($UpperCase)
    {
        return [guid]::NewGuid().ToString().ToUpperInvariant()
    }
    return [guid]::NewGuid().ToString()
}

New-Alias guid Get-Guid
New-Alias uuid Get-Guid
Export-ModuleMember -Function * -Alias *