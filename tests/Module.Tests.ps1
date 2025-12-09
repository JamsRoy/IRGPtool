
Describe 'IRGPtool module' {
    It 'Loads without error' {
        { Import-Module "$PSScriptRoot/../src/IRGPtool.psd1" -Force } | Should -Not -Throw
    }
}
