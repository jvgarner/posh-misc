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

# To backup: 
# docker config?
# visual studio config?

function Backup-UserData {
    Copy-Item C:\Users\jvg\APPDATA\Roaming\Code\User\settings.json c:\usr\jvg\backup\vscode\settings.json -Force
    Copy-Item C:\Users\jvg\AppData\Local\Packages\Microsoft.WindowsTerminal_8wekyb3d8bbwe\LocalState\settings.json c:\usr\jvg\backup\windows-terminal\settings.json -Force
    code --list-extensions > c:\usr\jvg\backup\vscode\extensions-list.txt
    choco list -lo > c:\usr\jvg\backup\choco\installed-list.txt 

    7z.exe a -t7z c:\usr\jvg\backup\plex.7z 'C:\Users\jvg\AppData\Local\Plex Media Server\' -mx0 -xr!Cache -xr!Logs
    7z.exe a -t7z c:\usr\jvg\backup\Documents.7z 'C:\Users\jvg\Documents\' -mx0

    $timestamp = Get-FilenameSafeTimeStamp
    Robocopy.exe c:\usr\ d:\usr\ /MIR /Z /R:5 /W:5 /MT:32 /NP /UNILOG+:c:\Logs\Backups\c-usr-to-d-$timestamp.log

    Remove-Item c:\usr\jvg\backup\Documents.7z -Force
    Remove-Item c:\usr\jvg\backup\plex.7z -Force
}

Set-Alias jvgBackup Backup-UserData 
Set-Alias jvgWeather Invoke-Weather 
Export-ModuleMember -Function * -Alias * 