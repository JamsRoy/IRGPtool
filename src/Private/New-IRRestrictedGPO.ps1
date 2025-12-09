
function New-IRRestrictedGPO {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory)][string]$GpoName,
        [Parameter(Mandatory)][string]$RestrictedGroup,
        [Parameter()][string]$LinkTarget = (Get-ADDomain).DistinguishedName,
        [Parameter()][string]$PacPath = "$env:ProgramData\IRGPtool\pac\irgp.pac"
    )

    Import-Module GroupPolicy -ErrorAction Stop

    $gpo = Get-GPO -Name $GpoName -ErrorAction SilentlyContinue
    if (-not $gpo) { $gpo = New-GPO -Name $GpoName }

    New-GPLink -Guid $gpo.Id -Target $LinkTarget -LinkEnabled Yes -ErrorAction SilentlyContinue | Out-Null

    try {
        Set-GPPermissions -Name $GpoName -TargetName 'Authenticated Users' -TargetType Group -PermissionLevel None -ErrorAction SilentlyContinue
    } catch {}
    Set-GPPermissions -Name $GpoName -TargetName $RestrictedGroup -TargetType Group -PermissionLevel GpoApply

    Set-GPRegistryValue -Name $GpoName `
        -Key 'HKCU\Software\Microsoft\Windows\CurrentVersion\Internet Settings' `
        -ValueName 'AutoConfigURL' -Type String -Value ("file://{0}" -f $PacPath)

    Write-IRAuditLog -Action 'New-IRRestrictedGPO' -Context @{ GPO = $GpoName; Group = $RestrictedGroup; PAC = $PacPath }
}
