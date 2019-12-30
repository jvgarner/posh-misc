# source: http://blog.pkh.me/p/21-high-quality-gif-with-ffmpeg.html

function ConvertTo-Gif {
    Param(
        [Parameter(ValueFromPipeline = $false, Mandatory = $true, Position = 0)]
        [string]$InputFile,

        [Parameter(ValueFromPipeline = $false, Mandatory = $true, Position = 1)]
        [string]$OutputFile,

        [Parameter(ValueFromPipeline = $false, Mandatory = $true, Position = 2)]
        [string]$StartTime, # ie 0:22

        [Parameter(ValueFromPipeline = $false, Mandatory = $true, Position = 3)]
        [decimal]$Duration, # ie 2.5

        [Parameter(ValueFromPipeline = $false, Mandatory = $false)]
        [int]$Scale = 480,

        [Parameter(ValueFromPipeline = $false, Mandatory = $false)]
        [int]$Fps = 15

    )

    
    $palette="palette${(New-Guid)}.png"

    $filters="fps=$Fps,scale=${Scale}:-1:flags=lanczos"

    ffmpeg -v warning -ss $StartTime -t $Duration -i $InputFile -vf "$filters,palettegen" -y $palette
    ffmpeg -v warning -ss $StartTime -t $Duration -i $InputFile -i $palette -lavfi "$filters [x]; [x][1:v] paletteuse" -y $OutputFile
    Remove-Item $palette 
}

Export-ModuleMember -Function ConvertTo-Gif