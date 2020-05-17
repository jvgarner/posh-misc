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
        [int]$Fps = 15,

        [Parameter(ValueFromPipeline = $false, Mandatory = $false)]
        [string]$SubtitleFilename

    )
    $palette="palette${(New-Guid)}.png"
    $filters="fps=$Fps,scale=${Scale}:-1:flags=lanczos"
    if ($srtFile) {
        $filters = "$filters,subtitles='$SubtitleFilename':force_style='Fontsize=24'"
        ffmpeg -v warning -ss $StartTime -t $Duration -i $InputFile -vf "$filters,palettegen" -y $palette
        ffmpeg -v warning -i $InputFile -i $palette -ss $StartTime -t $Duration -lavfi "$filters [x];[x][1:v] paletteuse" -y $OutputFile
    } else {
        ffmpeg -v warning -ss $StartTime -t $Duration -i $InputFile -vf "$filters,palettegen" -y $palette
        ffmpeg -v warning -ss $StartTime -t $Duration -i $InputFile -i $palette -lavfi "$filters [x];[x][1:v] paletteuse" -y $OutputFile
    }
    # $filters="fps=$Fps,scale=${Scale}:-1:flags=lanczos,subtitles='sub.srt':force_style='Fontsize=24'"
    #ffmpeg -v warning -i '.\Black Books 1x2 - Manny''s First Day.mkv' -ss 2:59 -t 12 -vf "subtitles='sub.srt':force_style='Fontsize=24'" -y out.mp4

    
    Remove-Item $palette 
}

Export-ModuleMember -Function ConvertTo-Gif