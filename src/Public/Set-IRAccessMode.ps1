
function Set-IRAccessMode {
    [CmdletBinding(SupportsShouldProcess)]
    param(
        [Parameter(Mandatory)][string]$User,
        [Parameter(Mandatory)][ValidateSet('OWAOnly','Normal')][string]$Mode,
        [string]$RestrictedGroup = 'IRGP-Restricted',
        [switch]$WhatIf
    )
    if (Invoke-IRDryRunGuard -WhatIf:$WhatIf) { return }
    Import-Module ActiveDirectory -ErrorAction Stop

    $u = Get-ADUser -Identity $User -ErrorAction Stop
    if ($Mode -eq 'OWAOnly') {
        Add-ADGroupMember -Identity $RestrictedGroup -Members $u.SamAccountName -ErrorAction Stop
        Write-IRAuditLog -Action 'Restrict-User' -Context @{ User = $u.SamAccountName; Group = $RestrictedGroup }
        Write-Host "User '$($u.SamAccountName)' restricted (OWA only)."
    } else {
        Remove-ADGroupMember -Identity $RestrictedGroup -Members $u.SamAccountName -Confirm:$false -ErrorAction SilentlyContinue
        Write-IRAuditLog -Action 'Unrestrict-User' -Context @{ User = $u.SamAccountName; Group = $RestrictedGroup }
        Write-Host "User '$($u.SamAccountName)' restored to normal."
    }
}
