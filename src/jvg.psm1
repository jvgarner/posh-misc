# quick navigation functions
# function Set-LocationUserDirectory {
#     Set-Location c:\usr\jvg\
# }
# Set-Alias ~ Set-LocationUserDirectory

# function Set-LocationSrc {
#     Set-Location c:\usr\jvg\src\
# }
# Set-Alias csrc Set-LocationSrc


function Invoke-Weather {
    Invoke-RestMethod wttr.in/Mississauga?q0 -useragent "curl"
}

# TODO: Cleanup script - empty recycle bin, remove downloads, what else?

# To backup: 
# docker config?
# visual studio config?

function Clear-UserData {
    # Cleanup folders
    # Remove bank transaction qfx files from download folder
    Get-ChildItem -Path 'C:\Users\jvg\Downloads' -Filter *.qfx | Remove-Item
    Get-ChildItem -Path 'C:\Users\jvg\Downloads' -Filter *.torrent | Remove-Item

    # Empty recycling bin
    Clear-RecycleBin -Force
}

function Backup-UserData {

    $timestamp = Get-FilenameSafeTimeStamp

    # CONFIG FILES BACKUP
    #Copy-Item C:\Users\jvg\APPDATA\Roaming\Code\User\settings.json C:\users\jvg\Documents\Misc\configs\vscode\$timestamp-settings.json -Force
    Copy-Item C:\Users\jvg\AppData\Local\Packages\Microsoft.WindowsTerminal_8wekyb3d8bbwe\LocalState\settings.json C:\users\jvg\Documents\Misc\configs\windows-terminal\$timestamp-settings.json -Force
    code --list-extensions > C:\users\jvg\Documents\Misc\configs\vscode\$timestamp-extensions-list.txt
    choco list -lo > C:\users\jvg\Documents\Misc\configs\choco\$timestamp-installed-list.txt 

    # 7z.exe a -t7z C:\users\jvg\Documents\backup\Documents.7z 'C:\Users\jvg\Documents\' -mx0
    # Robocopy.exe C:\users\jvg\Documents d:\backups\users\jvg\Documents /MIR /Z /R:1 /W:1
    # Robocopy.exe C:\users\jvg\Documents d:\backups\users\jvg\Documents /MIR /Z /R:5 /W:5 /MT:32 /NP /UNILOG+:c:\Logs\Backups\documents-$timestamp.log
    # Robocopy.exe C:\users\jvg\Music d:\backups\users\jvg\Music /MIR /Z /R:5 /W:5 /MT:32 /NP /UNILOG+:c:\Logs\Backups\music-$timestamp.log

    # local backup to external storage
    #Robocopy.exe C:\users\jvg\Documents \\rohan\jvgbackups\ /MIR /Z /MT:4 /XJ

    # DOCUMENTS TO CLOUD BACKUP
    #Set-Location -Path X:\jvg\backups
    Set-Location -Path C:\users\jvg\Documents\
    Duplicacy backup -vss
    if ($LASTEXITCODE -eq 0)
    {
        New-BurntToastNotification -Text "User Data Backup Success"
    }

    if ($LASTEXITCODE -ne 0)
    {
        New-BurntToastNotification -Text "User Data Backup Failure" -SnoozeAndDismiss
    }
}

function Backup-Cloud {
    Set-Location -Path x:\jvg\backup-dummy\ 
    Duplicacy copy -from default -to onedrive
    if ($LASTEXITCODE -eq 0)
    {
        New-BurntToastNotification -Text "Cloud Data Backup Success"
    }
    if ($LASTEXITCODE -ne 0)
    {
        New-BurntToastNotification -Text "Cloud Data Backup Failure" -SnoozeAndDismiss
    }
}

function Backup-Plex {
    # PLEX BACKUP
    #Remove-Item X:\Archive\plex.7z -Force -ErrorAction SilentlyContinue
    Get-Process 'Plex Media Server' | Stop-Process
    # 7z.exe a -t7z X:\Archive\plex.7z 'C:\Users\jvg\AppData\Local\Plex Media Server\' -mx0 -xr!Cache -xr!Logs
    7z.exe u -uq0 -mx9 X:\jvg\Archive\plex.7z 'C:\Users\jvg\AppData\Local\Plex Media Server\'
    Start-Process "C:\Program Files (x86)\Plex\Plex Media Server\Plex Media Server.exe"
    if ($LASTEXITCODE -eq 0)
    {
        New-BurntToastNotification -Text "Plex Data Backup Success"
    }
    if ($LASTEXITCODE -ne 0)
    {
        New-BurntToastNotification -Text "Plex Data Backup Failure" -SnoozeAndDismiss
    }
}

Set-Alias jvgBackup Backup-UserData 
Set-Alias jvgClean Clear-UserData 
Set-Alias jvgWeather Invoke-Weather 
Export-ModuleMember -Function * -Alias * 

# Set-Alias jvgEdit code c:\Users\jvg\Documents\Source\public\posh-misc\src\