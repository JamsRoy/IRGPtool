
function Update-IRPacFromM365Endpoints {
    [CmdletBinding(SupportsShouldProcess)]
    param(
        [string]$PacOutputPath = "$env:ProgramData\IRGPtool\pac\irgp.pac",
        [switch]$WhatIf
    )
    if (Invoke-IRDryRunGuard -WhatIf:$WhatIf) { return }

    $data = Get-M365Endpoints
    $allowed = New-Object System.Collections.Generic.HashSet[string]

    foreach ($set in $data) {
        $serviceArea = $set.serviceArea
        $category    = $set.category
        $urls        = $set.urls

        if (-not $urls) { continue }

        $isExchange  = ($serviceArea -eq 'Exchange')
        $isIdentity  = ($serviceArea -eq 'Common' -and ($set.notes -match 'Identity|Auth' -or $urls -match 'login.microsoftonline.com'))
        $isOfficeNet = ($serviceArea -eq 'Common' -and ($urls -match '\.office\.net'))

        if ($isExchange -and $category -in @('Optimize','Allow','Default')) {
            $urls | ForEach-Object { [void]$allowed.Add($_) }
        } elseif ($isIdentity -and $category -in @('Optimize','Allow','Default')) {
            $urls | ForEach-Object { [void]$allowed.Add($_) }
        } elseif ($isOfficeNet -and $category -in @('Optimize','Allow')) {
            $urls | ForEach-Object { [void]$allowed.Add($_) }
        }
    }

    @(
        '*.cloud.microsoft',
        'login.microsoftonline.com',
        '*.msftauth.net', '*.msauth.net',
        'autologon.microsoftazuread-sso.com',
        'outlook.office.com', 'outlook.office365.com'
    ) | ForEach-Object { [void]$allowed.Add($_) }

    $pacDir = Split-Path $PacOutputPath
    New-Item -ItemType Directory -Path $pacDir -Force | Out-Null

    $list = $allowed.ToArray() | Sort-Object
    $allowedJsArray = ($list | ForEach-Object { '"{0}"' -f $_ }) -join ",`n        "

    $pac = @"
function FindProxyForURL(url, host) {
    if (isPlainHostName(host) || shExpMatch(host, "*.local")) return "DIRECT";

    var m365Allowed = [
        $allowedJsArray
    ];

    for (var i = 0; i < m365Allowed.length; i++) {
        if (dnsDomainIs(host, m365Allowed[i]) || shExpMatch(host, m365Allowed[i])) {
            return "DIRECT";
        }
    }
    return "PROXY 127.0.0.1:9";
}
"@

    $pac | Set-Content -Path $PacOutputPath -Encoding UTF8
    Write-IRAuditLog -Action 'Update-PAC' -Context @{ Path = $PacOutputPath; Count = $list.Count }
    Write-Host "PAC updated at $PacOutputPath with $($list.Count) allowed entries."
}
