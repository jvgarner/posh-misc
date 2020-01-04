<#
.SYNOPSIS
  Deletes build and (optionally) local vs settings folders.
.PARAMETER RemoveVsDirectory
  Deletes local visual studio settings such as build configuration, startup projects, etc.
.PARAMETER WhatIf
  Outputs the folders that would be deleted.
.EXAMPLE
  Remove-VisualStudioBuildDirectories -RemoveVsDirectory
#>
function Remove-VisualStudioBuildDirectories {
    Param(
        [Parameter(ValueFromPipeline = $true, Position = 0)]
        [string]$Path = ".",

        [Alias("rmvs")]
        [switch]$RemoveVsDirectory,

        [switch]$WhatIf
    )
    
    $folders = if($RemoveVsDirectory) {'bin','obj','.vs'} else {'bin','obj'}
    Get-ChildItem $Path -Recurse -Directory -Include $folders -Force | Remove-Item -Recurse -Force -WhatIf:$WhatIf
}

Export-ModuleMember -Function *