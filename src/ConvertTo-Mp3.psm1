<#
.SYNOPSIS
  Creates a sub-directory named mp3, copies input paths to this directory, then converts the 
  contents to mp3. Will convert flac, alac, and ape lossless formats.
  NOTE: Requires ffmpeg to be installed.
.DESCRIPTION
  Creates a sub-directory named mp3, copies input paths to this directory, then converts the 
  contents to mp3. Will convert flac, alac, and ape lossless formats.
  NOTE: Requires ffmpeg to be installed.
.PARAMETER Paths
  The folder path(s) to convert.
.INPUTS
  System.String[]
.OUTPUTS
  A log detailing actions taken.
#>
function ConvertTo-Mp3 {
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
                if(!(Test-Path "mp3" -PathType Container)){
                    New-Item -Path "mp3" -ItemType Container
                }
                $targetPath = Join-Path -Path "mp3" -ChildPath (Get-Item $path).Name
                if(!(Test-Path $targetPath)) {
                    Copy-Item -Path $path -Recurse -Destination $targetPath -Container
                    Get-ChildItem $targetPath -Recurse -Include ('*.flac', '*.ape', '*.alac') | 
                        ForEach-Object -Parallel {
                            $inputPath = $using:targetPath + "\" + $_.Name
                            $output = $using:targetPath + "\" + $_.BaseName + ".mp3"
                            Write-Output "Encoding $output"
                            ffmpeg -i "$inputPath" -ab 320k "$output" -hide_banner -loglevel panic
                            
                            Write-Output "Removing $inputPath"
                            Remove-Item -Path $inputPath -Force 
                        }
                } else {
                    Write-Output "Target path $targetPath already exists; aborting"
                }
            }
        }
    }
}

Export-ModuleMember -Function ConvertTo-Mp3