# quick navigation functions
function Set-LocationUserDirectory {
    Set-Location c:\usr\jvg\
}
Set-Alias ~ Set-LocationUserDirectory

function Set-LocationSrc {
    Set-Location c:\usr\jvg\src\
}
Set-Alias csrc Set-LocationSrc


function Invoke-Weather {
    Invoke-RestMethod wttr.in/Mississauga?q0 -useragent "curl"
}

# TODO: Cleanup script - empty recycle bin, remove downloads, what else?

function Backup-UserData {
    Param(
        [switch]$ExternalBackup
    )
    $timestamp = Get-FilenameSafeTimeStamp

    if($externalBackup){
        
        Robocopy.exe x:\usr\   d:\usr\   /MIR /R:5 /W:5 /MT:32 /NP /UNILOG+:c:\Logs\Backups\x-usr-$timestamp.log 
        Robocopy.exe x:\media\ d:\media\ /MIR /R:5 /W:5 /MT:32 /NP /UNILOG+:c:\Logs\Backups\x-media-$timestamp.log 
    } else {
        Robocopy.exe C:\usr\ X:\usr\     /MIR /R:5 /W:5 /MT:32 /NP /UNILOG+:c:\Logs\Backups\c-usr-$timestamp.log 
        $target = "X:\usr\jvg\UserDirectory"
        Robocopy.exe $HOME $target /MIR /R:5 /W:5 /MT:32 /NP /XJD /XA:SH /XD AppData IISExpress .vscode .nuget .android .atom .dotnet .docker .eclipse .templateengine docker .omnisharp /UNILOG+:c:\Logs\Backups\c-usr-$timestamp.log 
    }
}

Set-Alias jvgBackup Backup-UserData 
Set-Alias jvgWeather Invoke-Weather 
Export-ModuleMember -Function * -Alias * 