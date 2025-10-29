<#
.SYNOPSIS
  Deletes bin and obj directories plus some optional other directories.
.PARAMETER RemoveVsDirectory
  Deletes .vs directories which contain local visual studio settings such as build configuration, startup projects, etc.
.PARAMETER RemovePackages
  Removes packages directories.
.PARAMETER RemoveGit
  Removes git directories (repositories).
.PARAMETER WhatIf
  Outputs the directories that would be deleted.
.EXAMPLE
  Remove-VisualStudioBuildDirectories -RemoveVsDirectory
#>
function Remove-VisualStudioBuildDirectories {
  Param(
      [Parameter(ValueFromPipeline = $true, Position = 0)]
      [string]$Path = ".",

      [Alias("rmvs")]
      [switch]$RemoveVsDirectory,

      [Alias("rmpkg")]
      [switch]$RemovePackages,

      [Alias("rmgit")]
      [switch]$RemoveGit,

      [switch]$WhatIf
  )
  [System.Collections.ArrayList]$folders = 'bin', 'obj' 
  
  if($RemoveVsDirectory) {
      $folders.Add('.vs')
  }

  if($RemovePackages) {
      $folders.Add('packages')
  }

  if($RemoveGit) {
      $folders.Add('.git')
  }

  Get-ChildItem $Path -Recurse -Directory -Include $folders -Force | Remove-Item -Recurse -Force -WhatIf:$WhatIf
}

New-Alias vsclean Remove-VisualStudioBuildDirectories
Export-ModuleMember -Function * -Alias *