<#
.SYNOPSIS
  Set-FileTime updates the creation, access, and write time of each file to the current time. 
  Path arguments that do not exist will be created unless NoCreate is specified. Similar to 
  touch in *NIX systems with several of the same parameters and aliases.
.PARAMETER Paths
  The file or files to update or create. Accepts wildcards for finding files to update.
.PARAMETER Date
  The date to use when updating the file information.
.PARAMETER LastWriteTime
  Update the last write (aka modified) time
.PARAMETER LastAccessTime
  Update the last access time
.PARAMETER CreatedTime
  Update the created time
.PARAMETER NoCreate
  Only update existing files; do not create them
.PARAMETER Reference
  A file to copy access and write times from
.PARAMETER NoDereference
  Command will skip symbolic link instead of updating referenced file. 
  Note that differs from -h flag with unix touch command. 
.INPUTS
  System.String[]
.OUTPUTS
  System.IO.FileSystemInfo
.EXAMPLE
  # Create files foo.txt and bar.txt and set the creation, write, and access time to now
  Set-FileTime foo.txt,bar.txt
.EXAMPLE
  # Update the creation datetime to next year on all files and directories in the current directory
  Set-FileTime * -CreationTime -Date (Get-Date).AddYears(1)
.EXAMPLE
  # If the file a.txt exists, set the last access datetime to yesterday.
  Set-FileTime a.txt -NoCreate -LastAccessTime -Date (Get-Date).AddDays(-1)
#>
function Set-FileTime {
  Param(
    [Parameter(ValueFromPipeline = $true, Mandatory = $true, Position = 0)]
    [string[]]$Paths,

    [Parameter(Mandatory = $false, Position = 1)]
    [Alias("d")]
    [Alias("t")]
    [DateTime]$Date = (Get-Date),
    
    [Parameter(Mandatory = $false)]
    [Alias("m")]
    [Switch]$LastWriteTime = $false,

    [Parameter(Mandatory = $false)]
    [Alias("a")]
    [Switch]$LastAccessTime = $false,

    [Parameter(Mandatory = $false)]
    [Alias("cr")] # unfortunately c is taken already s an alias for NoCreate
    [Switch]$CreationTime = $false,

    [Parameter(Mandatory = $false)]
    [Alias("c")]
    [Switch]$NoCreate = $false,

    [Parameter(Mandatory = $false)]
    [Alias("r")]
    [string]$Reference,

    [Parameter(Mandatory = $false)]
    [Alias("h")]
    [Switch]$NoDereference = $false,

    [Parameter()]
    [Switch]$Force
  )

  begin {
    $touched = New-Object System.Collections.ArrayList
    if ($Reference -and (Test-Path $Reference)) {
      $crTime = (Get-Item $Reference).CreationTime
      $lwTime = (Get-Item $Reference).LastWriteTime
      $laTime = (Get-Item $Reference).LastAccessTime
    } else {
      $crTime = $Date
      $lwTime = $Date 
      $laTime = $Date 
    }

    function updateFileTimes($path) {
      if (!$path) {
        return
      }

      $resolvedPaths = resolve-path $path -ErrorAction SilentlyContinue
      foreach ($rpath in $resolvedPaths) {
        $rpath = (Get-Item $rpath)
        if($rpath.LinkType -and $NoDereference) {
          continue
        }

        # If no specific time types are specified, update them all
        $noneSelected = (!$LastAccessTime -and !$LastWriteTime -and !$CreationTime)
        if ($LastAccessTime -or $noneSelected) {
          $rpath.LastAccessTime = $laTime
        }
        
        if ($LastWriteTime -or $noneSelected) {
          $rpath.LastWriteTime = $lwTime
        }

        if ($CreationTime -or $noneSelected) {
          $rpath.CreationTime = $crTime
        }

        $touched.Add($rpath) > $null
      }
    }
  }
  
  process {
    if (!$Paths) {
      return
    }

    foreach($path in $Paths) {
      if (test-path $path) {
        updateFileTimes($path)
      } else {
        if (!$NoCreate) {
          # This will create the file if it doesn't already exist, but won't modify existing file.
          Add-Content -Path $path -Value $null
        }
        updateFileTimes($path)
      }
    }
  }

  end {
    $touched
  }
}

New-Alias touch Set-FileTime
Export-ModuleMember -Function * -Alias *