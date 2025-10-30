<#
.SYNOPSIS
  Gets line, word, and character counts for one or more files (wc clone).
.PARAMETER Paths
  One or more file paths to process.
.PARAMETER Lines
  Show only line counts.
.PARAMETER Words
  Show only word counts.
.PARAMETER Chars
  Show only character counts.
.OUTPUTS
  [PSCustomObject] with char, word, and line counts for each file.
.EXAMPLE
  Get-FileContentData -Words -Chars test1.txt test2.txt test3.txt
  Output:
    Words Chars File
    ----- ----- ----
        5    26 test1.txt
        5    30 test2.txt
      288  1502 test3.txt
.EXAMPLE
  Get-FileContentData -Lines test1.txt test2.txt
  Output:
  Lines File
  ----- ----
      1 test1.txt
      5 test2.txt
.EXAMPLE
  wc test1.txt test2.txt test3.txt
  Output:
  Lines Words Characters File
  ----- ----- ---------- ----
      1     5         26 test1.txt
      5     5         30 test2.txt
     32   288       1502 test3.txt
#>
function Get-FileContentData {
    param (
        [Parameter(Mandatory=$true, ValueFromRemainingArguments=$true)]
        [string[]]$Paths,

        [Parameter(Mandatory = $false)]
        [Alias("l")]
        [switch]$Lines,

        [Parameter(Mandatory = $false)]
        [Alias("w")]
        [switch]$Words,

        [Parameter(Mandatory = $false)]
        [Alias("c")]
        [switch]$Chars
    )
    
    foreach ($Path in $Paths) {
        if (-not (Test-Path $Path)) {
            Write-Warning "File not found: $Path"
            continue
        }

        $content = Get-Content $Path -Raw
        $output = [ordered]@{}

        if ($Lines -or (-not ($Lines -or $Words -or $Chars))) {
            $output.Lines = ($content -split "`r?`n").Count
        }

        if ($Words -or (-not ($Lines -or $Words -or $Chars))) {
            $output.Words = ($content -split '\s+').Count
        }

        if ($Chars -or (-not ($Lines -or $Words -or $Chars))) {
            $output.Chars = $content.Length
        }

        $output.File = $Path
        [PSCustomObject]$output
    }
}

New-Alias wc Get-FileContentData
Export-ModuleMember -Function * -Alias * 