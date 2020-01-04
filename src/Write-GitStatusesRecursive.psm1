<#
.SYNOPSIS
Write the git status for every git repository found within the current directory.

.DESCRIPTION
Write the git status for every git repository found within the current directory.

.EXAMPLE
Write-GitStatuses

.NOTES
Depends on posh-git 
#>
function Write-GitStatusesRecursive {
    $startDir = Get-Location
    Get-ChildItem . -Recurse -Directory -Force | Where-Object Name -eq '.git' | 
        ForEach-Object { 
            $loc = $_.FullName.TrimEnd('.git')
            Set-Location $loc > $null;
            Write-Host $loc -NoNewLine 
            Write-GitStatus (Get-GitStatus)
            Write-Host "`n"
        }
    Set-Location $startDir 
}
Set-Alias gits Write-GitStatusesRecursive
Export-ModuleMember -Function * -Alias *