<#
.SYNOPSIS
  Write out the alphabet, in lowercase and uppercase.
#>
function Get-Alphabet {
  Write-Output "abcdefghijklmnopqrstuvwxyz"
  Write-Output "ABCDEFGHIJKLMNOPQRSTUVWXYZ"
}


New-Alias alpha Get-Alphabet 
Export-ModuleMember -Function * -Alias * 
