
function Test-IRUserEffect {
    [CmdletBinding()]
    param(
        [string]$User = $env:USERNAME,
        [string]$PacPath = "$env:ProgramData\IRGPtool\pac\irgp.pac"
    )
    Write-Host "Checking GPO application for user '$User'..."
    try {
        gpresult /R /USER $User | Out-Host
    } catch { Write-Warning "gpresult failed: $($_.Exception.Message)" }

    $probes = @(
        'https://outlook.office.com/',
        'https://login.microsoftonline.com/',
        'https://office.com/'
    )
    foreach ($p in $probes) {
        try {
            $r = Invoke-WebRequest -Uri $p -UseBasicParsing -TimeoutSec 10
            Write-Host "[ALLOWED] $p ($($r.StatusCode))"
        } catch { Write-Host "[CHECK] $p — $(($_.Exception.Message).Split([Environment]::NewLine)[0])" }
    }
    try {
        Invoke-WebRequest -Uri 'https://www.bing.com/' -UseBasicParsing -TimeoutSec 10
        Write-Warning "Unexpected: General internet appears allowed."
    } catch {
        Write-Host "[BLOCKED AS EXPECTED] General site (bing)."
    }

    if (Test-Path $PacPath) { Write-Host "PAC present: $PacPath" } else { Write-Warning "PAC missing at $PacPath" }
}
