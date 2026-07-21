<#
.SYNOPSIS
  Deletes package cache directories for npm.
.EXAMPLE
  Remove-NpmPackageCaches
#>
function Remove-NpmPackageCaches {
    npm cache clean --force
}

New-Alias cleannpm Remove-NpmPackageCaches
Export-ModuleMember -Function * -Alias *