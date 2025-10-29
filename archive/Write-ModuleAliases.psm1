function Write-ModuleAliases {
    param (
        [Parameter(Mandatory)]
        [string]$ModuleFolder
    )

    # Get the full path of this module to exclude it
    $thisModulePath = $MyInvocation.MyCommand.Path
    # Initialize collection to hold definition-alias mapping
    $definitionAliasMap = @()

    # Get all module files (.psm1, .psd1) excluding this module
    $modulePaths = Get-ChildItem -Path $ModuleFolder -Recurse -Include *.psm1, *.psd1 |
        Where-Object {
            $_.FullName -ne $thisModulePath
        }

    foreach ($module in $modulePaths) {
        try {
            $importedModule = Import-Module $module.FullName -PassThru -ErrorAction Stop
            # Get all aliases from the module
            $aliases = Get-Alias | Where-Object { $_.Source -eq $importedModule.Name }

            # Group aliases by their definition
            $grouped = $aliases | Group-Object Definition
            foreach ($group in $grouped) {
                $definitionAliasMap += [PSCustomObject]@{
                    Definition = $group.Name
                    Aliases    = ($group.Group | Select-Object -ExpandProperty Name) -join ', '
                }
            }

            # Also include definitions with no aliases
            $exportedCommands = Get-Command -Module $importedModule.Name | Select-Object -ExpandProperty Name
            foreach ($cmd in $exportedCommands) {
                if (-not ($definitionAliasMap | Where-Object { $_.Definition -eq $cmd })) {
                    $definitionAliasMap += [PSCustomObject]@{
                        Definition = $cmd
                        Aliases    = 'n/a'
                    }
                }
            }

            Remove-Module $importedModule.Name
        }
        catch {
            Write-Warning "Failed to import module from '$($module.FullName)': $_"
        }
    }

    $definitionAliasMap | Sort-Object Definition
}
