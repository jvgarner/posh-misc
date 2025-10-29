<#
.SYNOPSIS
Write the git status for every git repository found within the current directory.

.DESCRIPTION
Write the git status for every git repository found within the current directory.

.EXAMPLE
Write-GitStatuses

.NOTES
Requires posh-git to be installed
#>
function Write-GitStatusesRecursive {
    $startDir = Get-Location
    Get-ChildItem . -Recurse -Directory -Force | Where-Object Name -eq '.git' | 
        ForEach-Object { 
            $loc = $_.FullName.TrimEnd('.git')
            Set-Location $loc > $null;
            Write-Host $loc -NoNewLine 
            Write-GitStatus (Get-GitStatus)
        }
    Set-Location $startDir 
}

New-Alias gits Write-GitStatusesRecursive
Export-ModuleMember -Function * -Alias *