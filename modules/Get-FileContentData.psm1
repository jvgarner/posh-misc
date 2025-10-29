<#
.SYNOPSIS
  Gets line, word, and character counts for one or more files (wc clone).
.DESCRIPTION
  Mimics the Unix `wc` command by reporting line, word, and character counts for each file.
.PARAMETER Paths
  One or more file paths to process.
.PARAMETER l
  Show only line counts.
.PARAMETER w
  Show only word counts.
.PARAMETER c
  Show only character counts.
.INPUTS
  [string[]] File paths.
.OUTPUTS
  [PSCustomObject] with file statistics.
.EXAMPLE
  Get-FileContentData -Paths .\file.txt
.EXAMPLE
  wc .\file.txt -l
#>

function Get-FileContentData {
    [CmdletBinding(DefaultParameterSetName = 'All')]
    param (
        [Parameter(Mandatory=$true, ValueFromRemainingArguments=$true)]
        [string[]]$Paths,

        [Parameter(ParameterSetName = 'Lines')]
        [switch]$l,

        [Parameter(ParameterSetName = 'Words')]
        [switch]$w,

        [Parameter(ParameterSetName = 'Chars')]
        [switch]$c
    )
    
    function Test-IsTextFile {
        param ([string]$Path)

        try {
            $bytes = [System.IO.File]::ReadAllBytes($Path)
            $sample = $bytes[0..([Math]::Min($bytes.Length - 1, 1024))]
            foreach ($b in $sample) {
                if ($b -lt 9 -or ($b -gt 13 -and $b -lt 32)) {
                    return $false
                }
            }
            return $true
        } catch {
            return $false
        }
    }

    foreach ($Path in $Paths) {
        if (-not (Test-Path $Path)) {
            Write-Warning "File not found: $Path"
            continue
        }

        
        if (-not (Test-IsTextFile -Path $Path)) {
            Write-Warning "Skipping binary file: $Path"
            continue
        }

        $content = Get-Content $Path -Raw
        $lines = ($content -split "`r?`n").Count
        $words = ($content -split '\s+').Count
        $chars = $content.Length

        $output = [PSCustomObject]@{
            File       = $Path
            Lines      = if ($l -or (-not ($l -or $w -or $c))) { $lines } else { $null }
            Words      = if ($w -or (-not ($l -or $w -or $c))) { $words } else { $null }
            Characters = if ($c -or (-not ($l -or $w -or $c))) { $chars } else { $null }
        }

        $output
    }
}

Set-Alias wc Get-FileContentData
Export-ModuleMember -Function * -Alias * 