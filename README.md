# posh-misc
PowerShell scripts I have written and use.

To easily import, clone and add the following to your PowerShell profile (i.e. `code $PROFILE` if using vscode).
```
$modulespath = '(path-to-modules)\posh-misc\src\'
Get-ChildItem ($modulespath + "*.psm1") | ForEach-Object {Import-Module (Join-Path $modulespath $_.Name)} | Out-Null
```
