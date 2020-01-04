<#
.SYNOPSIS
  Updates all choco packages.
.PARAMETER AcceptAll
  Confirm all prompts - Chooses affirmative answer instead of prompting.
.EXAMPLE
  Update-AllChocoPackages -y
.EXAMPLE
  Update-AllChocoPackages
#>
function Update-AllChocoPackages {
    Param(
        [alias("y")]
        [switch]$AcceptAll
    )
    if($AcceptAll) {
        choco upgrade all -y 
    } else {
        choco upgrade all
    }
}

Export-ModuleMember -Function * -Alias *