
# Operation

1. Run `Ensure-IRFoundation` to create `IRGP-Restricted` and the GPO. This also places the PAC at `%ProgramData%\IRGPtool\pac\irgp.pac` and sets `AutoConfigURL` for the restricted users.
2. Run `Update-IRPacFromM365Endpoints` to generate the allowlist and write the PAC.
3. Use `Set-IRAccessMode -User <sam> -Mode OWAOnly` to restrict a user.
4. Test on endpoint: `Test-IRUserEffect`.

## Scheduled updates (optional)
`Install-IRPacUpdaterTask` creates a weekly SYSTEM task to run the updater (Sunday 03:00).

## Troubleshooting
- PAC not applied: `gpresult /R /USER <sam>`; verify GPO applied.
- OWA failing: rerun `Update-IRPacFromM365Endpoints` to refresh endpoints; ensure endpoint has access to `endpoints.office.com`.

## References
- Office 365 endpoints service: https://learn.microsoft.com/en-us/microsoft-365/enterprise/urls-and-ip-address-ranges
- PAC via GPO: https://4sysops.com/archives/assigning-proxy-settings-in-windows-automatically-with-a-pac-file/
