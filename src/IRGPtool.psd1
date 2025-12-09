
@{
    RootModule        = 'IRGPtool.psm1'
    ModuleVersion     = '0.1.0'
    GUID              = '2c9a4d12-7e6b-4c2b-9bb0-9f1c3c0c1234'
    Author            = 'James Richardson & Contributors'
    Description       = 'Per-user OWA-only Internet access via PAC + updater from Microsoft 365 endpoints.'
    PowerShellVersion = '5.1'
    FunctionsToExport = @('*')
    PrivateData       = @{
        PSData = @{
            Tags       = @('ActiveDirectory','GroupPolicy','PAC','Microsoft365','ExchangeOnline')
            ProjectUri = 'https://github.com/JamsRoy/IRGPtool'
        }
    }
}
