<#
.SYNOPSIS
  Convert the input to the nato alphabet equivalent for the output.
.DESCRIPTION
  Convert the input to the nato alphabet equivalent for the output.
.INPUTS
  System.String[]
.OUTPUTS
  The nato equivalent of the input, one line per word.
#>

function ConvertTo-Nato {
    param (
        [Parameter(Mandatory = $true)]
        [string]$Text
    )

    $dictionary = @{
        "a" = "Alfa";     "b" = "Bravo";    "c" = "Charlie"; "d" = "Delta"
        "e" = "Echo";     "f" = "Foxtrot";  "g" = "Golf";    "h" = "Hotel"
        "i" = "India";    "j" = "Juliett";  "k" = "Kilo";    "l" = "Lima"
        "m" = "Mike";     "n" = "November"; "o" = "Oscar";   "p" = "Papa"
        "q" = "Quebec";   "r" = "Romeo";    "s" = "Sierra";  "t" = "Tango"
        "u" = "Uniform";  "v" = "Victor";   "w" = "Whiskey"; "x" = "X-ray"
        "y" = "Yankee";   "z" = "Zulu"
        "1" = "One";      "2" = "Two";      "3" = "Three";   "4" = "Four"
        "5" = "Five";     "6" = "Six";      "7" = "Seven";   "8" = "Eight"
        "9" = "Nine";     "0" = "Zero"
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

Set-Alias nato ConvertTo-Nato
Export-ModuleMember -Function * -Alias * 