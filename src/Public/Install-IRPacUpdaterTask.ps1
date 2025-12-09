
function Install-IRPacUpdaterTask {
    [CmdletBinding()]
    param(
        [string]$TaskName = 'IRGP-PAC-WeeklyUpdate',
        [string]$Script = 'Update-IRPacFromM365Endpoints',
        [string]$RunAs = 'SYSTEM',
        [string]$Schedule = 'Weekly'
    )
    $action = New-ScheduledTaskAction -Execute 'powershell.exe' -Argument "-NoProfile -WindowStyle Hidden -Command "Import-Module IRGPtool; $Script""
    $trigger = New-ScheduledTaskTrigger -Weekly -DaysOfWeek Sunday -At 3am
    Register-ScheduledTask -TaskName $TaskName -Action $action -Trigger $trigger -RunLevel Highest -User $RunAs | Out-Null
    Write-Host "Scheduled task '$TaskName' created (weekly, Sunday 03:00)."
}
