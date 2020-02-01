<#
.SYNOPSIS
Throw away all pending changes and revert to the last git commit.

.DESCRIPTION
Throw away all pending changes and revert to the last git commit.

.EXAMPLE
Invoke-GitHardClean

#>

function Invoke-GitHardClean 
{ 
    $title    = 'Confirm'
    $question = 'This command will throw away all pending changes. Are you sure you want to proceed?'
    $choices  = '&Yes', '&No'

    $decision = $Host.UI.PromptForChoice($title, $question, $choices, 1)
    if ($decision -eq 0) {
        git reset --hard HEAD;
        git clean -f -d;
        git checkout master
    } else {
        Write-Host 'Cancelled'
    }
}

New-Alias githc Invoke-GitHardClean
Export-ModuleMember -Function * -Alias *