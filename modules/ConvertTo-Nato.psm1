<#
.SYNOPSIS
  Converts input text to nato strings.
.DESCRIPTION
  Converts input text to nato strings. It generates one line per word so is best used with short phrases, names, etc.
.PARAMETER Text
  The input text to convert to nato strings.
.INPUTS
  System.String
.OUTPUTS
  System.String
.EXAMPLE
  ConvertTo-Nato "abc"
  Output: Alfa Bravo Charlie
.EXAMPLE
  "hello world" | ConvertTo-UpperCase
  Output: 
  Hotel Echo Lima Lima Oscar
  Whiskey Oscar Romeo Lima Delta
#>
function ConvertTo-Nato {
    param (
        [Parameter(ValueFromPipeline = $true, Mandatory = $true, Position = 0)]
        [string]$Text
    )

    $dictionary = @{
        "a" = "Alfa";     "b" = "Bravo";    "c" = "Charlie"; "d" = "Delta"
        "e" = "Echo";     "f" = "Foxtrot";  "g" = "Golf";    "h" = "Hotel"
        "i" = "India";    "j" = "Juliett";  "k" = "Kilo";    "l" = "Lima"
        "m" = "Mike";     "n" = "November"; "o" = "Oscar";   "p" = "Papa"
        "q" = "Quebec";   "r" = "Romeo";    "s" = "Sierra";  "t" = "Tango"
        "u" = "Uniform";  "v" = "Victor";   "w" = "Whiskey"; "x" = "X-ray"
        "y" = "Yankee";   "z" = "Zulu";
        "1" = "One";      "2" = "Two";      "3" = "Three";   "4" = "Four"
        "5" = "Five";     "6" = "Six";      "7" = "Seven";   "8" = "Eight"
        "9" = "Nine";     "0" = "Zero";     "." = "Point";   "-" = "Dash";
        "(" = "Brackets On"; ")" = "Brackets off"; "/" = "Slant"
    }

    $Text.Split(' ') | ForEach-Object {
        $word = $_
        $converted = $word.ToLower().ToCharArray() | ForEach-Object {
            $charStr = [string]$_
            if ($dictionary.ContainsKey($charStr)) {
                $dictionary[$charStr]
            } else {
                $charStr
            }
        }
        Write-Output ($converted -join ' ')
    }
}

New-Alias nato ConvertTo-Nato
Export-ModuleMember -Function * -Alias * 