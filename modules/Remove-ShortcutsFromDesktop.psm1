<#
.SYNOPSIS
Delete any shortcut (lnk) file from the user desktop.
#>
function Remove-ShortcutsFromDesktop {
    # Define the path to the current user's desktop
    $desktopPath = [System.Environment]::GetFolderPath("Desktop")

    # Get all .lnk files in the desktop folder
    $shortcutFiles = Get-ChildItem -Path $desktopPath -Filter *.lnk -File

    # Delete each shortcut file
    foreach ($file in $shortcutFiles) {
        try {
            Remove-Item -Path $file.FullName -Force
            Write-Host "Deleted: $($file.Name)"
        } catch {
            Write-Host "Failed to delete: $($file.Name) - $($_.Exception.Message)"
        }
    }
}

Export-ModuleMember -Function * -Alias *