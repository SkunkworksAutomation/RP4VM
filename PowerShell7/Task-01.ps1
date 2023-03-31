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

# GATHER LICENSING INFORMATION
$Licenses = get-pluginlicenses -Plugins $PluginVMs
$Licenses | Export-Csv .\licenses.csv -NoTypeInformation