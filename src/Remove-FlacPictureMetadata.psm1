<#
.SYNOPSIS
  
.DESCRIPTION 
  
.PARAMETER Paths
  The folder path(s) to process.
.INPUTS
  System.String[]
.OUTPUTS
  A log detailing actions taken.
#>
function Remove-FlacPictureMetadata {
    Param(
        [Parameter(ValueFromPipeline = $true, Mandatory = $true, Position = 0)]
        [string[]]$Paths
    )
    
    process {  
        $resolvedPaths = Resolve-Path $Paths -ErrorAction SilentlyContinue
        foreach($path in $resolvedPaths) {
            if ($path -contains "[" -or $path -contains "]") {
                Write-Output "Target path $targetPath contains an unsupported character; aborting"
            } elseif (Test-Path $path -PathType Container) {
                Write-Output "Processing $path "
                metaflac.exe --dont-use-padding --remove --block-type=PICTURE,PADDING "$path\*.flac"
            }
        }
    }
}

Export-ModuleMember -Function Remove-FlacPictureMetadata