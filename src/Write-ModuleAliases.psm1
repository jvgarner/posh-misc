# function Write-ModuleAliases {
#     param (
#         [Parameter(Mandatory)]
#         [string]$ModuleFolder
#     )

#     # Get the full path of this module to exclude it
#     $thisModulePath = $MyInvocation.MyCommand.Path

#     # Get all module files (.psm1, .psd1) excluding this module
#     $modulePaths = Get-ChildItem -Path $ModuleFolder -Recurse -Include *.psm1, *.psd1 |
#         Where-Object {
#             $_.FullName -ne $thisModulePath
#         }

#     foreach ($module in $modulePaths) {
#         try {
#             $importedModule = Import-Module $module.FullName -PassThru -ErrorAction Stop

#             $aliases = Get-Alias | Where-Object { $_.Source -eq $importedModule.Name }

#             if ($aliases) {
#                 #Write-Host "`nModule: $($importedModule.Name)"
#                 foreach ($alias in $aliases) {
#                     Write-Host "Alias: $($alias.Name) -> $($alias.Definition)"
#                 }
#             } else {
#                 #Write-Host "`nModule: $($importedModule.Name) - No aliases found."
#             }

#             Remove-Module $importedModule.Name
#         }
#         catch {
#             Write-Warning "Failed to import module from '$($module.FullName)': $_"
#         }
#     }
# }

# function Write-ModuleAliases {
#     param (
#         [Parameter(Mandatory)]
#         [string]$ModuleFolder
#     )

#     # Get the full path of this module to exclude it
#     $thisModulePath = $MyInvocation.MyCommand.Path

#     # Initialize collection to hold alias info
#     $aliasCollection = @()

#     # Get all module files (.psm1, .psd1) excluding this module
#     $modulePaths = Get-ChildItem -Path $ModuleFolder -Recurse -Include *.psm1, *.psd1 |
#         Where-Object {
#             $_.FullName -ne $thisModulePath
#         }

#     foreach ($module in $modulePaths) {
#         try {
#             $importedModule = Import-Module $module.FullName -PassThru -ErrorAction Stop

#             $aliases = Get-Alias | Where-Object { $_.Source -eq $importedModule.Name }

#             foreach ($alias in $aliases) {
#                 $aliasCollection += [PSCustomObject]@{
#                     #Module     = $importedModule.Name
#                     Alias      = $alias.Name
#                     Definition = $alias.Definition
#                 }
#             }

#             Remove-Module $importedModule.Name
#         }
#         catch {
#             Write-Warning "Failed to import module from '$($module.FullName)': $_"
#         }
#     }

#     # Sort and display the aliases
#     if ($aliasCollection.Count -gt 0) {
#         $aliasCollection | Sort-Object Alias | Format-Table -AutoSize
#     } else {
#         Write-Host "No aliases found in the specified folder."
#     }
# }

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

    # Output as CSV-style table
#    $definitionAliasMap | Sort-Object Definition | Format-Table -AutoSize
    $definitionAliasMap | Sort-Object Definition
}
