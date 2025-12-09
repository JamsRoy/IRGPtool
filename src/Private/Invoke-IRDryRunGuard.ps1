
function Invoke-IRDryRunGuard {
    param([switch]$WhatIf)
    if ($WhatIf.IsPresent) {
        Write-Host "WhatIf: No changes will be made."
        return $true
    }
    return $false
}
