<#
.SYNOPSIS
  Deletes package cache directories for nuget.
.EXAMPLE
  Remove-NugetPackageCaches
#>
function Remove-NugetPackageCaches {
    dotnet nuget locals all --clear
}

New-Alias cleannuget Remove-NugetPackageCaches
Export-ModuleMember -Function * -Alias *