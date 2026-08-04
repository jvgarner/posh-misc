<#
.SYNOPSIS
  Deletes old Docker Desktop data and trims the vhdx file to reclaim disk space.
.PARAMETER RemoveImages
  Deletes all images from the Docker Desktop data directory.
.PARAMETER RemoveAnonymousVolumes
  Deletes all anonymous volumes from the Docker Desktop data directory.
.PARAMETER TrimVhdx
  Trims the vhdx file to reclaim disk space.
.EXAMPLE
  Remove-DockerDesktopData -RemoveImages
#>
function Remove-DockerDesktopData {
  Param(
      [Parameter(ValueFromPipeline = $true, Position = 0)]
      [string]$DockerDataPath = "$env:USERPROFILE\AppData\Local\Docker\wsl\disk",

      [Alias("images")]
      [switch]$RemoveImages,

      [Alias("volumes")]
      [switch]$RemoveAnonymousVolumes,

      [Alias("vhdx")]
      [switch]$TrimVhdx
  )

      $dockerExePath = Join-Path -Path $env:ProgramFiles -ChildPath "Docker\Docker\Docker Desktop.exe"
      $needsDockerEngine = $RemoveAnonymousVolumes -or $RemoveImages

      if ($needsDockerEngine) {
        $dockerReady = $false

        try {
          docker version --format '{{.Server.Version}}' 1>$null 2>$null
          $dockerReady = ($LASTEXITCODE -eq 0)
        } catch {
          $dockerReady = $false
        }

        if (-not $dockerReady) {
          if (-not (Test-Path $dockerExePath)) {
            throw "Docker Desktop executable not found at $dockerExePath"
          }

          Write-Output "Starting Docker Desktop so prune operations can run..."
          Start-Process -FilePath $dockerExePath -ErrorAction SilentlyContinue | Out-Null

          for ($i = 0; $i -lt 60; $i++) {
            try {
              docker version --format '{{.Server.Version}}' 1>$null 2>$null
              if ($LASTEXITCODE -eq 0) {
                $dockerReady = $true
                break
              }
            } catch {
              $dockerReady = $false
            }

            Start-Sleep -Seconds 2
          }

          if (-not $dockerReady) {
            throw "Docker engine did not become ready in time. Try opening Docker Desktop once manually, then rerun."
          }
        }
      }

  if($RemoveAnonymousVolumes) {
      docker volume prune -f
  }

  if($RemoveImages) {
      docker system prune -a -f
  }

  if($TrimVhdx) {
      $dockerCliPath = Join-Path -Path $env:ProgramFiles -ChildPath "Docker\Docker\DockerCli.exe"
      $vhdxPath = Join-Path -Path $DockerDataPath -ChildPath "docker_data.vhdx"

      try {
        Write-Output "Stopping Docker Desktop..."

        if (Test-Path $dockerCliPath) {
          & $dockerCliPath -Shutdown 2>$null | Out-Null
        }

        $service = Get-Service -Name "com.docker.service" -ErrorAction SilentlyContinue
        if ($service -and $service.Status -ne "Stopped") {
          Stop-Service -Name "com.docker.service" -Force -ErrorAction SilentlyContinue
        }

        Get-Process -ErrorAction SilentlyContinue |
          Where-Object {
            $_.ProcessName -in @("Docker Desktop", "Docker Desktop Backend") -or
            $_.ProcessName -like "com.docker.*"
          } |
          Stop-Process -Force -ErrorAction SilentlyContinue

        # Force all WSL VMs down so the Docker VHDX can be compacted.
        & wsl.exe --shutdown 2>$null | Out-Null

        $trimSucceeded = $false

        if (-not (Test-Path $vhdxPath)) {
          Write-Warning "VHDX file not found at $vhdxPath"
        } elseif (-not (Get-Command Optimize-VHD -ErrorAction SilentlyContinue)) {
          Write-Warning "Optimize-VHD not found. Install/enable Hyper-V PowerShell module and run as Administrator."
        } else {
          for ($i = 0; $i -lt 20; $i++) {
            try {
              if ($i -eq 0) {
                Write-Output "Trimming VHDX: $vhdxPath"
              }

              Optimize-VHD -Path $vhdxPath -Mode Full -ErrorAction Stop
              $trimSucceeded = $true
              break
            } catch {
              if ($i -eq 19) {
                Write-Warning "Failed to trim VHDX after retries: $($_.Exception.Message)"
              } else {
                Start-Sleep -Seconds 1
              }
            }
          }

          if (-not $trimSucceeded) {
            Write-Warning "Docker/WSL may still be holding the VHDX. Try closing all WSL terminals, then rerun with admin PowerShell."
          }
        }
      }
      finally {
        Write-Output "Starting Docker Desktop..."
        if (Test-Path $dockerExePath) {
          Start-Process -FilePath $dockerExePath -ErrorAction SilentlyContinue | Out-Null
        } else {
          Write-Warning "Docker Desktop executable not found at $dockerExePath"
        }
      }
  }
}

New-Alias cleandocker Remove-DockerDesktopData
Export-ModuleMember -Function * -Alias *