# $url = "https://url/"
# $org = "org"
# $project = "SUMMITT"
# $apiKey = "apikey"

# Usage:
# script.ps1 <project> <org> <url> <apiKey>

param (
    [string]$project,
    [string]$org,
    [string]$url,
    [string]$apiKey
)

# Use environment variables if parameters are not provided
if (-not $url) {
    $url = $env:ADO_URL
}
if (-not $apiKey) {
    $apiKey = $env:ADO_PAT
}
if (-not $org) {
    $org = $env:ADO_ORG
}
if (-not $project) {
    $project = $env:ADO_PROJECT
}


# Prepare authentication header
$base64AuthInfo = [Convert]::ToBase64String([Text.Encoding]::ASCII.GetBytes(("{0}:{1}" -f "", $apiKey)))
$header = @{ Authorization = ("Basic {0}" -f $base64AuthInfo) }

# Get all repositories for the given project
$reposUri = "$url/$org/$project/_apis/git/repositories?api-version=7.0"
$reposResponse = Invoke-RestMethod -Method Get -Uri $reposUri -Headers $header
$reposResponse.value | Sort-Object -Property name
