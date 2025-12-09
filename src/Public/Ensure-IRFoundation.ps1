
function Ensure-IRFoundation {
    [CmdletBinding()]
    param(
        [string]$GpoName = 'IRGP - OWA Only',
        [string]$RestrictedGroup = 'IRGP-Restricted'
    )
    Import-Module ActiveDirectory -ErrorAction Stop

    $pacDir = "$env:ProgramData\IRGPtool\pac"
    New-Item -ItemType Directory -Path $pacDir -Force | Out-Null

    $grp = Get-ADGroup -Filter "Name -eq '$RestrictedGroup'" -ErrorAction SilentlyContinue
    if (-not $grp) {
        $grp = New-ADGroup -Name $RestrictedGroup -GroupScope Global -GroupCategory Security -Path (Get-ADDomain).UsersContainer
        Write-IRAuditLog -Action 'New-ADGroup' -Context @{ Group = $RestrictedGroup }
    }

    $pacPath = Join-Path $pacDir 'irgp.pac'
    if (-not (Test-Path $pacPath)) {
        $starter = (Join-Path $PSScriptRoot '..\..\pac\irgp.pac')
        if (Test-Path $starter) {
            Copy-Item -Path $starter -Destination $pacPath -Force
        } else {
            @"function FindProxyForURL(url, host) {
 return "PROXY 127.0.0.1:9";
}"@ | Set-Content -Path $pacPath -Encoding UTF8
        }
    }

    New-IRRestrictedGPO -GpoName $GpoName -RestrictedGroup $RestrictedGroup -PacPath $pacPath

    Write-Host "Foundation ready: Group '$RestrictedGroup', GPO '$GpoName', PAC '$pacPath'."
}
