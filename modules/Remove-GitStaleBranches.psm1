<#
.SYNOPSIS
  Removes any git branches marked as "gone".
#>
function Remove-GitStaleBranches {
    $requiredModule = 'Posh-Git'
    if (-not (Get-Module -ListAvailable -Name $requiredModule)) {
        Write-Error "Required module '$requiredModule' is not installed. Aborting execution."
        return
    }
    git checkout main
    git branch -vv | Where-Object { $_ -match 'gone\]' } | ForEach-Object { $_.Trim().Split()[0] } | ForEach-Object { git branch -D $_ }
}

New-Alias gitgone Remove-GitStaleBranches
Export-ModuleMember -Function * -Alias *