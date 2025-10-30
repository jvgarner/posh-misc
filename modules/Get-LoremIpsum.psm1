<#
.SYNOPSIS
  Get dummy text in the Lorem ipsum tradition.
.PARAMETER Count
  The number of times to output the lorem ipsum text. Defaults to 1.
#>
function Get-LoremIpsum {
      Param(
        [Parameter(ValueFromPipeline = $true, Position = 0)]
        [Alias("c")]
        [Int]$Count = 1
    )
  for ($i = 0; $i -lt $Count; $i++) {
    Write-Output "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis knostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum."
  }  
}

New-Alias lorem Get-LoremIpsum 
Export-ModuleMember -Function * -Alias * 
