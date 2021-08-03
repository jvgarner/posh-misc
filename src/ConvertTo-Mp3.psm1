<#
.SYNOPSIS
  Mirrors a directory and it's sub-directories but re-encodes any FLAC, ALAC, or APE files to mp3
  NOTE: Requires ffmpeg to be installed.
.DESCRIPTION
  Mirrors a directory and it's sub-directories but re-encodes any FLAC, ALAC, or APE files to mp3
  NOTE: Requires ffmpeg to be installed.
.PARAMETER In
  The input path
.PARAMETER Out
  The output path
.INPUTS
  System.String
.OUTPUTS
  Writes out each action taken
#>
function ConvertTo-Mp3 {
  Param
  (
      [Parameter(ValueFromPipeline = $true, Mandatory = $true, Position = 0)]
      [string]$in,

      [Parameter(ValueFromPipeline = $true, Mandatory = $true, Position = 1)]
      [string]$out
  )
  process {  
      if (Test-Path -LiteralPath $in -PathType Container) {
          if (!(Test-Path -LiteralPath $out -PathType Container)) {
              Write-Output "[CREATING] [$out]"
              New-Item -Path $out -ItemType Container | Out-Null
          }

          $inFullPath = (Get-Item -LiteralPath $in).FullName
          $outFullPath = (Get-Item -LiteralPath $out).FullName
          Get-ChildItem -LiteralPath $in -Recurse | ForEach-Object -Parallel {
              # Write-Output $inFullPath
              # Write-Output $outFullPath
              $sourceFile = $_.FullName.ToString()
              $targetFile = $sourceFile.Replace($using:inFullPath, $using:outFullPath)
              #Write-Output $sourceFile 
              #Write-Output $targetFile
              $targetFile = $targetFile.Replace(".flac", ".mp3")
              $targetFile = $targetFile.Replace(".alac", ".mp3")
              $targetFile = $targetFile.Replace(".ape", ".mp3")
              #Write-Output $targetFile
              #(Get-Item $sourceFile).Extension | Write-Output
              if (Test-Path -LiteralPath $sourceFile -PathType Container) {
                  if (!(Test-Path -LiteralPath $targetFile -PathType Container)) {
                      Write-Output "[CREATING] [$targetFile]"
                      New-Item -Path $targetFile -ItemType Container | Out-Null
                  }
              } 
              elseif ((Get-Item -LiteralPath $sourceFile).Extension -in ".flac", ".alac", ".ape") {
                  if (!(Test-Path -LiteralPath $targetFile -PathType Leaf)) {
                      Write-Output "[ENCODING] [$targetFile]"
                      ffmpeg -i "$sourceFile" -ab 320k "$targetFile" -hide_banner -loglevel panic
                  }
                  else {
                      Write-Output "[SKIPPING] [$targetFile]"
                  }
              } 
              else {
                  if (!(Test-Path -LiteralPath $targetFile -PathType Leaf)) {
                      Write-Output "[COPYING] [$targetFile]"
                      New-Item -Force $targetFile | Out-Null
                      Copy-Item -LiteralPath $sourceFile -Destination $targetFile -Force | Out-Null
                  }
                  else {
                      Write-Output "[SKIPPING] [$targetFile]"
                  }
              
              }
          }
      }
  }
}

Export-ModuleMember -Function ConvertTo-Mp3