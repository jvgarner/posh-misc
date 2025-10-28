# partially inspired by https://gist.github.com/jchandra74/5b0c94385175c7a8d1cb39bc5157365e
# Setup steps
<# 
Set-PSRepository -Name PSGallery -InstallationPolicy Trusted
Install-Module -Name 'PSReadLine' -AllowClobber -Force -SkipPublisherCheck
Install-Module -Name 'posh-git' -AllowClobber
Install-Module -Name 'z' -AllowClobber
Install-Module -Name 'oh-my-posh' -AllowClobber
Install-Module -Name 'Get-ChildItemColor' -AllowClobber

# reminder: to update: Update-Module

# install fonts:
# cd c:\tools\ ; git clone https://github.com/powerline/fonts.git; cd fonts; .\install.ps1
#>

If (-Not (Test-Path Variable:PSise)) {  # Only run this in the console and not in the ISE
    function Initialize-Modules {
        # PowerShellGet
        # https://learn.microsoft.com/en-us/powershell/gallery/powershellget/install-powershellget?view=powershellget-3.x
        
        # gci color https://github.com/joonro/Get-ChildItemColor
        # Install-Module Get-ChildItemColor
        Import-Module Get-ChildItemColor
        Set-Alias lsw Get-ChildItemColorFormatWide -Scope Global
        Set-Alias ls Get-ChildItemColor -Scope Global

        # Octopus Deploy https://octopus.com/docs/octopus-rest-api/cli
        # winget install octopusdeploy.cli
        Set-Alias oc octopus -Scope Global 

        # z tab completion https://github.com/badmotorfinger/z
        # Install-Module z -AllowClobber
        Import-Module z
        
        # posh-git https://github.com/dahlbyk/posh-git
        # Install-Module posh-git -Scope CurrentUser -Force
        Import-Module posh-git 
        $env:POSH_GIT_ENABLED = $true 
        
        # winget tab completion
        # https://github.com/microsoft/winget-cli/blob/master/doc/Completion.md
        Register-ArgumentCompleter -Native -CommandName winget -ScriptBlock {
            param($wordToComplete, $commandAst, $cursorPosition)
                [Console]::InputEncoding = [Console]::OutputEncoding = $OutputEncoding = [System.Text.Utf8Encoding]::new()
                $Local:word = $wordToComplete.Replace('"', '""')
                $Local:ast = $commandAst.ToString().Replace('"', '""')
                winget complete --word="$Local:word" --commandline "$Local:ast" --position $cursorPosition | ForEach-Object {
                    [System.Management.Automation.CompletionResult]::new($_, $_, 'ParameterValue', $_)
                }
        }

        # Personal modules
        $modulespath = 'c:\src\personal\posh-misc\src\'
        Get-ChildItem ($modulespath + "*.psm1") | ForEach-Object {Import-Module (Join-Path $modulespath $_.Name)} | Out-Null
    }

    function SqlStart {
        Write-Output '>sudo start-service -Name MSSQLSERVER'
        sudo start-service -Name MSSQLSERVER
    }

    function SqlStop {
        Write-Output '>sudo stop-service -Name MSSQLSERVER'
        sudo stop-service -Name MSSQLSERVER
    }

    function ProfileEdit {
        Write-Output '>code $PROFILE'
        code $PROFILE 
    }

    function RemindMe {
        Write-Output 'scb - Set-Clipboard'
        Write-Output 'gcb - Set-Clipboard'
        Write-Output 'z - cd improved'
        Write-Output 'oc - Octopus Deploy CLI'
        Write-Output 'ls - Get-ChildItemColor'
        Write-Output 'lsw - Get-ChildItemColorFormatWide'
        Get-ChildItemColor 'c:\src\personal\posh-misc\src\'
    }

    Initialize-Modules
}