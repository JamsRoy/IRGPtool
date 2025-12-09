
# Design

- Per-user restriction via AD group `IRGP-Restricted` + GPO security filtering.
- GPO sets `AutoConfigURL` (PAC) in **User Configuration** to a local path `%ProgramData%\IRGPtool\pac\irgp.pac`.
- PAC allows Microsoft 365 OWA/Identity endpoints only; blocks the rest via a blackhole proxy (`127.0.0.1:9`).

## Why PAC-only?
PAC-only avoids IIS and works for Edge and Chrome via system proxy settings. It is simple to maintain and can be combined later with an Edge-specific policy if needed.

## Endpoint sources
We use Microsoft’s official service for endpoint data and filter to Exchange Online, Identity/Auth, and common resources consumed by OWA.

- URLs & IPs list and guidance: https://learn.microsoft.com/en-us/microsoft-365/enterprise/urls-and-ip-address-ranges
- Endpoint management best practices: https://learn.microsoft.com/en-us/microsoft-365/enterprise/microsoft-365-endpoints
