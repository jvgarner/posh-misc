# $octopusURL = "https://xxx.yyy.com/" #Octopus URL
# $octopusAPIKey = "API-xxxxxx" #Octopus API Key

$octopusURL = $args[0]
$octopusAPIKey = $args[1]

##PROCESS##
$header = @{ "X-Octopus-ApiKey" = $octopusAPIKey }
$machines = (Invoke-RestMethod -Method Get -Uri "$octopusURL/api/machines/all" -Headers $header) #| Where-Object {$_.IsDisabled -eq "false" } | select -First 1

Write-Host $machines

foreach ($m in $machines | Where-Object {$_.IsDisabled -eq 0})
{
    if ($m.HasLatestCalamari -eq 0)
    {
        throw "Machine: $($m.Name) HasLatestCalamari: $($m.HasLatestCalamari)"
    }
}