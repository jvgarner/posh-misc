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

# module imports and configurations
Import-Module Get-ChildItemColor
Set-Alias lsw Get-ChildItemColorFormatWide -Option AllScope

Import-Module z -Scope Local 
Import-Module PSReadLine -Scope Local 
Import-Module posh-git -Scope Local 
$env:POSH_GIT_ENABLED = $true
Import-Module oh-my-posh -Scope Local
Set-PoshPrompt -Theme pure

# Import posh-misc modules not published to PSGallery
$modulespath = "~\Documents\Source\public\posh-misc\src\"
Get-ChildItem ($modulespath + "*.psm1") | ForEach-Object {Import-Module (Join-Path $modulespath $_.Name)} | Out-Null