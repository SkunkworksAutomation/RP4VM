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

# GATHER CLUSTER INFORMATION
$Clusters = get-pluginclusters -Plugins $PluginVMs
$Clusters | Export-Csv .\clusters.csv -NoTypeInformation