# $octopusURL = "https://xxx.yyy.com/" #Octopus URL
# $octopusAPIKey = "API-xxxxxx" #Octopus API Key
# $projectSlug = "project"
# $environmentSlug = "environment"

$projectSlug = $args[0]
$environmentSlug = $args[1]
$octopusURL = $args[2]
$octopusAPIKey = $args[3]

##PROCESS##
$header = @{ "X-Octopus-ApiKey" = $octopusAPIKey }
$project = (Invoke-RestMethod -Method Get -Uri "$octopusURL/api/projects/$projectSlug" -Headers $header)
$envs = (Invoke-RestMethod -Method Get -Uri "$octopusURL/api/environments?name=$environmentSlug" -Headers $header) | Select-Object -First 1
$env = $envs.Items | Select-Object -First 1

$ProjectDashboardReleases = (Invoke-WebRequest $octopusURL/api/progression/$($project.Id) -Method Get -Headers $header).content | ConvertFrom-Json
$lastRelease = $ProjectDashboardReleases.Releases.Deployments.$($env.Id) | Select-Object -First 1
# Write-Output "Project: [$($project.Name)]  Environment: [$($env.Name)]  Last Release State: [$($lastRelease.State)]"
if (!($lastRelease.State -eq "Success")) {
    throw "Project: [$($project.Name)]  Environment: [$($env.Name)]  Last Release State: [$($lastRelease.State)]"
}