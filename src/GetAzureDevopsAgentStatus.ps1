# $agentId = 7
# $poolId = 1
# $org = "org"
# $url = "https://url/"
# $apiKey = "apikey"

param (
    [string]$agentId,
    [string]$poolId,
    [string]$org,
    [string]$url,
    [string]$apiKey
)

# Use environment variables if parameters are not provided
if (-not $poolId) {
    $poolId = 1
}
if (-not $org) {
    $org = $env:ADO_ORG
}
if (-not $url) {
    $url = $env:ADO_URL
}
if (-not $apiKey) {
    $apiKey = $env:ADO_PAT
}


# Prepare authentication header
$base64AuthInfo = [Convert]::ToBase64String([Text.Encoding]::ASCII.GetBytes(("{0}:{1}" -f "",$apiKey)))
$header = @{Authorization=("Basic {0}" -f $base64AuthInfo) }

# If agentId is provided, get that specific agent; otherwise, get all agents in the pool
if ($agentId -ne "") {
    $agent = (Invoke-RestMethod -Method Get -Uri "$url/$org/_apis/distributedtask/pools/$poolId/agents/$agentId" -Headers $header)

    # Validate agent status
    if (!($agent.Status -eq "online") -or ($agent.Enabled -eq 0)) {
        throw "Agent: [$($agent.Name)]  Enabled: [$($agent.Enabled)]  Last Release State: [$($agent.Status)]"
    }

    return $agent
}
else {
    $agents = (Invoke-RestMethod -Method Get -Uri "$url/$org/_apis/distributedtask/pools/$poolId/agents" -Headers $header)

    # if any agent is offline or disabled, throw an error
    foreach ($agent in $agents.value) {
        if (!($agent.Status -eq "online") -or ($agent.Enabled -eq 0)) {
            throw "Agent: [$($agent.Name)]  Enabled: [$($agent.Enabled)]  Last Release State: [$($agent.Status)]"
        }
    }

    return $agents.value
}