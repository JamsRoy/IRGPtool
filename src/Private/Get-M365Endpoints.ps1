
function Get-M365Endpoints {
    [CmdletBinding()]
    param(
        [ValidateSet('Worldwide')]
        [string]$Cloud = 'Worldwide',
        [string]$CachePath = "$env:ProgramData\IRGPtool\cache\m365-endpoints.json"
    )
    $uri = "https://endpoints.office.com/endpoints/$Cloud?clientRequestId=$(New-Guid)"
    $data = $null
    try {
        Write-Verbose "Fetching endpoints from $uri"
        $data = Invoke-RestMethod -Uri $uri -TimeoutSec 60
        if ($data) {
            New-Item -ItemType Directory -Path (Split-Path $CachePath) -Force | Out-Null
            $data | ConvertTo-Json -Depth 6 | Set-Content -Path $CachePath -Encoding UTF8
        }
    } catch {
        Write-Warning "Fetch failed: $($_.Exception.Message). Using cache if present."
        if (Test-Path $CachePath) {
            $data = (Get-Content -Path $CachePath -Raw) | ConvertFrom-Json
        } else {
            throw "No endpoint data available."
        }
    }
    return $data
}
