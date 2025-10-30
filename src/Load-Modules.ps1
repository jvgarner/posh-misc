# partially inspired by https://gist.github.com/jchandra74/5b0c94385175c7a8d1cb39bc5157365e
# Setup steps
<# 
Set-PSRepository -Name PSGallery -InstallationPolicy Trusted
Install-Module -Name 'PSReadLine' -AllowClobber -Force -SkipPublisherCheck
Install-Module -Name 'posh-git' -AllowClobber
Install-Module -Name 'z' -AllowClobber
Install-Module -Name 'oh-my-posh' -AllowClobber
Install-Module -Name 'Get-ChildItemColor' -AllowClobber

Install-PSResource PSCalendar

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

        Set-Alias grep Select-String -Scope Global 

        # Personal modules
        $modulespath = 'c:\src\personal\posh-misc\modules\'
        Get-ChildItem ($modulespath + "*.psm1") | ForEach-Object { Import-Module $_.FullName }
    }

    function cpwd {
        Get-Location | Set-Clipboard
    }

    function cguid {
        Get-Guid | Set-Clipboard
    }

    function cgid {
        Get-IsoDate | Set-Clipboard 
    }

    function cpaths {
        Get-Paths | Set-Clipboard
    }

    function pomodoro {
        timer "20m"
    }

    function wifi {
        netsh wlan connect name="SEWIFI"
    }

    function wifit {
        netsh wlan disconnect
        netsh wlan connect name="SEWIFI"
    }

    function cheat {
        Write-Output ''
        Write-Output 'Misc Reminders'
        Write-Output '============================='
        Write-Output "code `$PROFILE - Edit your profile"
        Write-Output "type a partial command then use F8 key to search history"

        Write-Output ''
        Write-Output 'Misc Custom or Useful Aliases'
        Write-Output '============================='
        Write-Output 'alpha - Get-Alphabet'
        Write-Output 'emoji - Get-Emoji'
        Write-Output 'gcb - Get-Clipboard'
        Write-Output 'gid - Get-IsoDate'
        Write-Output 'guid - Get-Guid - Get a random guid'
        Write-Output 'lc - ConvertTo-LowerCase'
        Write-Output 'lorem - Get-LoremIpsum'
        Write-Output 'nato - ConvertTo-Nato - convert text to nato equivalent'
        Write-Output 'paths - Get-Paths - all paths, one per line'
        Write-Output 'rn - current datetime and a calendar'
        Write-Output 'scb - Set-Clipboard'
        Write-Output 'sh - Select-CommandHistory - search FULL command history'
        Write-Output 'uc - ConvertTo-UpperCase'
        Write-Output 'z - cd improved'

        Write-Output ''
        Write-Output 'Unix-Clone Commands'
        Write-Output '============================='
        Write-Output 'cat - Get-Content'
        Write-Output 'cd - Set-Location'
        Write-Output 'cls - Clear-Host'
        Write-Output 'cp - Copy-Item'
        Write-Output 'echo - Write-Output'
        Write-Output 'history - Get-History'
        Write-Output 'kill - Stop-Process'
        Write-Output 'ls - Get-ChildItemColor'
        Write-Output 'lsw - Get-ChildItemColorFormatWide'
        Write-Output 'man - Get-Help'
        Write-Output 'mv - Move-Item'
        Write-Output 'pwd - Get-Location'
        Write-Output 'rm - Remove-Item'
        Write-Output 'touch - Set-FileTime'
        Write-Output 'wc - Get-FileContentData'
        Write-Output 'which - Get-Command' 
    }

    Initialize-Modules
}