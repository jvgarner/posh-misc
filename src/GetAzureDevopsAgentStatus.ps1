# $agentId = 7
# $poolId = 1
# $org = "org"
# $url = "https://url/"
# $apiKey = "apikey"

$agentId = $args[0]
$poolId = $args[1]
$org = $args[2]
$url = $args[3]
$apiKey = $args[4]

##PROCESS##

$base64AuthInfo = [Convert]::ToBase64String([Text.Encoding]::ASCII.GetBytes(("{0}:{1}" -f "",$apiKey)))
$header = @{Authorization=("Basic {0}" -f $base64AuthInfo) }

$agent = (Invoke-RestMethod -Method Get -Uri "$url/$org/_apis/distributedtask/pools/$poolId/agents/$agentId" -Headers $header) #| Where-Object {$_.IsDisabled -eq "false" } | select -First 1

if (!($agent.Status -eq "online") -or ($agent.Enabled -eq 0)) {
    throw "Agent: [$($agent.Name)]  Enabled: [$($agent.Enabled)]  Last Release State: [$($agent.Status)]"
}