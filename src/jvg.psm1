function jvgWeather {
    Invoke-RestMethod wttr.in/Mississauga?q0 -useragent "curl"
}

function jvgBackup {
    Param(
        [switch]$ExternalBackup
    )
    $timestamp = Get-FilenameSafeTimeStamp

    if($externalBackup){
        Robocopy.exe x:\usr\ d:\usr\ /MIR /R:5 /W:5 /MT:32 /NP /UNILOG+:c:\Logs\Backups\x-usr-$timestamp.log 
        Robocopy.exe x:\media\ d:\media\ /MIR /R:5 /W:5 /MT:32 /NP /UNILOG+:c:\Logs\Backups\x-media-$timestamp.log 
    } else {
        Robocopy.exe C:\usr\ X:\usr\ /MIR /R:5 /W:5 /MT:32 /NP /UNILOG+:c:\Logs\Backups\c-usr-$timestamp.log 
    }
}

function jvgChocoUpgradeAll {
    Param(
        [switch]$AcceptAll
    )
    if($AcceptAll) {
        choco upgrade all -y
    } else {
        choco upgrade all
    }
    
}

function lsw { Get-ChildItem $args -Exclude .*  | Format-Wide Name -AutoSize }

function jvgSolutionClean {
    Param(
        [Alias("vs")]
        [switch]$RemoveVsFolder
    )
    if($RemoveVsFolder){
        Get-ChildItem * -Recurse -Directory -Include 'bin','obj','.vs' -Force | Remove-Item -Recurse -Force 
    } else {
        Get-ChildItem * -Recurse -Directory -Include 'bin','obj' -Force | Remove-Item -Recurse -Force 
    }
    
}

Export-ModuleMember -Function *