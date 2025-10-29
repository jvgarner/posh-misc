<#
.SYNOPSIS
Create an archive of the specified folder

.DESCRIPTION
Create an archive of the specified folder

.EXAMPLE
Invoke-ArchiveFolder

.NOTES

#>

function Invoke-ArchiveNotesFolder {
    Param(
        [Parameter(ValueFromPipeline = $true, Position = 0)]
        [string]$Path = "_notes",

        [switch]$WhatIf
    )
    
    Copy-Item -Path $Path -Destination ".\archive\_notes\$(Get-FileNameSafeTimeStamp)" -Recurse -Force -WhatIf:$WhatIf

}
New-Alias iaf Invoke-ArchiveNotesFolder
Export-ModuleMember -Function * -Alias *