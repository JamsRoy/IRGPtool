
function Write-IRAuditLog {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory)][string]$Action,
        [Parameter(Mandatory)][hashtable]$Context
    )
    $dir = Join-Path $env:ProgramData 'IRGPtool\logs'
    if (-not (Test-Path $dir)) { New-Item -ItemType Directory -Path $dir -Force | Out-Null }
    $entry = [PSCustomObject]@{
        Timestamp = (Get-Date).ToString('s')
        Action    = $Action
        Caller    = $env:USERNAME
        Computer  = $env:COMPUTERNAME
        Context   = ($Context | ConvertTo-Json -Compress)
    }
    $path = Join-Path $dir ('irgp-' + (Get-Date -Format 'yyyyMMdd') + '.log')
    $entry | ConvertTo-Json -Compress | Add-Content -Path $path -Encoding UTF8
}
