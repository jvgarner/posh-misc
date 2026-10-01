Function Move-ItemToRecycleBin {

    [CmdletBinding(SupportsShouldProcess = $true, ConfirmImpact = "Low")]
    param (
        [Parameter(Mandatory = $true, ValueFromPipelineByPropertyName = $true)]
        [Alias("FullName")]
        [string[]] $Path
    )
    Begin {
        $shell = New-Object -ComObject 'Shell.Application'
        New-Variable -Name provider -Scope Private
    }
    Process {

        foreach ($p in $Path) {

            $realPath = $PSCmdlet.GetResolvedProviderPathFromPSPath($p, [ref]$provider)

            $directory = Split-Path -Path $realPath -Parent
            $fileName = Split-Path -Path $realPath -Leaf

            $shellFolder = $shell.Namespace($directory)
            $shellItem = $shellFolder.ParseName($fileName)

            if ($PSCmdlet.ShouldProcess($p, "Move to Recycle Bin")) {

                try {
                    [void] $shellItem.InvokeVerb("delete")
                }
                catch {
                    Write-Error -Exception $_.Exception -Message "Unable to recycle `"$p`""
                }
            }
        }
    }
    End {
        [void] [System.Runtime.InteropServices.Marshal]::ReleaseComObject($shell) 
    }
}