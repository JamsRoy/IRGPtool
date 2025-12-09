
# IRGPtool

Per-user **OWA-only** Internet access on shared PCs using a **local PAC file** and a **GPO**, plus an updater that refreshes the allowlist from **Microsoft 365 endpoints**.

## Quick start

```powershell
Import-Module ./src/IRGPtool.psd1
Ensure-IRFoundation
Update-IRPacFromM365Endpoints
Set-IRAccessMode -User jdoe -Mode OWAOnly
```

Test on the endpoint:
```powershell
Test-IRUserEffect
```

Revert user:
```powershell
Set-IRAccessMode -User jdoe -Mode Normal
```

## Prerequisites
- RSAT modules installed on the admin machine: **ActiveDirectory** and **GroupPolicy**.
- Domain-joined Windows 10/11 endpoints.
- Outbound internet access to `endpoints.office.com` for the updater (or use cache).

## References
- Microsoft 365 URLs and IP address ranges: https://learn.microsoft.com/en-us/microsoft-365/enterprise/urls-and-ip-address-ranges
- Microsoft 365 endpoints overview: https://learn.microsoft.com/en-us/microsoft-365/enterprise/microsoft-365-endpoints
- Assigning proxy PAC via GPO on Windows: https://4sysops.com/archives/assigning-proxy-settings-in-windows-automatically-with-a-pac-file/
- Set proxy via GPO (per-user): https://theitbros.com/config-internet-explorer-11-proxy-settings-gpo/
- (Optional) Edge ProxySettings policy: https://learn.microsoft.com/en-us/deployedge/microsoft-edge-browser-policies/proxysettings
