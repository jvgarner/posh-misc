<#
.SYNOPSIS
  Write the git status for every git repository recursively found within the current directory. Requires posh-git to be installed.
.PARAMETER Fetch
  Executes a "git fetch --all" on every git repository before writing out the status.
.PARAMETER Pull
  Executes a "git pull --all --rebase --quiet --ff-only" on every git repository before writing out the status.
.EXAMPLE
  D:\source\Write-GitStatuses
  Output:
  D:\source\Alpha0\ [main ↓1]
  D:\source\Beta\ [test +1 ~3 -1 !]
  D:\source\Gamma\ [main ≡]
  D:\source\Zeta\ [main ↓5]
#>
function Write-GitStatuses {
  Param(
    [Parameter(Mandatory = $false)]
    [Alias("f")]
    [Switch]$Fetch = $false,

    [Parameter(Mandatory = $false)]
    [Alias("p")]
    [Switch]$Pull = $false,

    [Parameter(Mandatory = $false)]
    [Alias("r")]
    [Switch]$RemoveStale = $false,

    [Parameter(Mandatory = $false)]
    [Alias("s")]
    [Switch]$ShowStaleBranches = $false
  )

    $requiredModule = 'Posh-Git'
    if (-not (Get-Module -ListAvailable -Name $requiredModule)) {
        Write-Error "Required module '$requiredModule' is not installed. Aborting execution."
        return
    }

    $startDir = Get-Location
    Get-ChildItem . -Recurse -Directory -Force | Where-Object Name -eq '.git' | 
        ForEach-Object { 
            $loc = $_.FullName.TrimEnd('.git')
            Set-Location $loc > $null;
            if($RemoveStale) {
                git checkout main
                git pull --all --rebase --quiet --ff-only
                if ($LASTEXITCODE -eq 0) {
                    Remove-GitStaleBranches
                } else {
                    Write-Host "can't prune 'gone' branches - git pull failed with exit code $LASTEXITCODE"
                }
            }elseif($Pull) {
                git pull --all --rebase --quiet --ff-only
            }elseif($Fetch) {
                git fetch --all -q
            }
            
            Write-Host $loc -NoNewLine 
            Write-VcsStatus 

            if($ShowStaleBranches) {
              git branch -vv | Where-Object { $_ -match 'gone\]' } | Write-Host
            }
        }
    Set-Location $startDir 
}

New-Alias gits Write-GitStatuses
Export-ModuleMember -Function * -Alias *