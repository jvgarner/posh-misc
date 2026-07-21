<#
.SYNOPSIS
  Deletes package cache directories for nuget and npm.
.PARAMETER RemoveNuget
  Removes nuget cache directories.
.PARAMETER RemoveNpm
  Removes npm cache directories.
.EXAMPLE
  Remove-PackageCaches -RemoveNuget -RemoveNpm
#>
function Remove-PackageCaches {
  Param(
      [Alias("nuget")]
      [switch]$RemoveNuget,

      [Alias("npm")]
      [switch]$RemoveNpm
  )
  if($RemoveNuget) {
      dotnet nuget locals all --clear
  }
  if($RemoveNpm) {
      npm cache clean --force
  }
}

New-Alias cleancaches Remove-PackageCaches -nuget -npm
Export-ModuleMember -Function * -Alias *