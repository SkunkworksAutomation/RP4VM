<#
    THIS CODE REQUIRES POWWERSHELL 7.x.(latest)
    https://github.com/PowerShell/PowerShell/releases/tag/v7.3.3
#>

Import-Module .\dell.rp4vm.psm1 -Force
# RP4VM PLUGIN VIRTUAL MACHINES
$PluginVMs = @(
    '192.168.1.80'
)

set-credentials

# GATHER EVENT INFORMATION
$Events = get-events -Plugins $PluginVMs -Days 30
$Events | Export-Csv .\events.csv -NoTypeInformation