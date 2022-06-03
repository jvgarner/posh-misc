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
    # z tab completion
    Import-Module z
    
    # posh-git
    Import-Module posh-git 
    $env:POSH_GIT_ENABLED = $true
    
    # gci color
    Import-Module Get-ChildItemColor
    Set-Alias lsw Get-ChildItemColorFormatWide -option AllScope
    
    # Chocolatey
    $ChocolateyProfile = "$env:ChocolateyInstall\helpers\chocolateyProfile.psm1"
    if (Test-Path($ChocolateyProfile)) {
        Import-Module "$ChocolateyProfile"
    }
    
    # Personal modules
    $modulespath = 'c:\src\personal\posh-misc\src\'
    Get-ChildItem ($modulespath + "*.psm1") | ForEach-Object {Import-Module (Join-Path $modulespath $_.Name)} | Out-Null
}