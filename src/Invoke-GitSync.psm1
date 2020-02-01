<#
.SYNOPSIS
Syncs every upstream branch on origin.

.DESCRIPTION
Syncs every upstream branch on origin.

.EXAMPLE
Invoke-GitSync

.NOTES
Will not run if there are unstashed or uncommitted changes.
#>

function Invoke-GitSync {
    if((git rev-parse --is-inside-work-tree)) {
        $gitStatus = Get-GitStatus
        $hasChange = ($gitStatus.Working.Count -gt 0) -or ($gitStatus.Index.Count -gt 0)
        if($hasChange) {
            Write-Host "Please commit or stash changes before attempting to run this script."
        } else {
            $currentBranch = Get-GitBranch
            # git stash --include-untracked
            git fetch upstream # todo: make -p an option to prune all branches?
            git checkout master
            
            # For each remote upstream branch:
            # 1. checkout branch locally and then pull with rebase from upstream
            # 2. If 1 fails, create and checkout the branch and set it to track upstream
            # 3. If 1 or 2 succeed, push to origin
            git branch -a | Where-Object { $_ -match "remotes/upstream*" } |  ForEach-Object { $_.Substring(19) } | 
            ForEach-Object { 
                (((git checkout $_) -and (git pull --rebase upstream $_)) -or (git checkout -b $_ --track upstream/$_)) -and (git push origin $_)
            }

            git checkout $currentBranch 
            # git stash apply
        }
    }
}
New-Alias gitsync Invoke-GitSync
Export-ModuleMember -Function * -Alias *