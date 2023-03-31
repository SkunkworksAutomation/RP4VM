<#
   THIS CODE REQUIRE POWWERSHELL 7.x.(latest)    
   https://github.com/PowerShell/PowerShell/releases/tag/v7.3.3
#>

$global:AuthObject = $null

function set-credentials {
    [CmdletBinding()]
    param (
 
    )
    begin {
        # CHECK TO SEE IF OAUTH2 CREDS FILE EXISTS IF NOT CREATE ONE
        $exists = Test-Path -Path ".\credentials.xml" -PathType Leaf
        if($exists) {
            $Creds = Import-CliXml ".\credentials.xml"
        } else {
            $Creds = Get-Credential -Message "Please specify your credentials."
            $Creds | Export-CliXml ".\credentials.xml"
        }
    }
    process {
     
        # BASE64 ENCODE USERNAME AND PASSWORD AND CREATE THE REQUEST BODY
        $Object = [Convert]::ToBase64String([Text.Encoding]::ASCII.GetBytes(
            ("{0}:{1}" -f $Creds.username,
                (
                    ConvertFrom-SecureString -SecureString $Creds.password -AsPlainText
                )
            )
        )
        )

        $global:AuthObject = @{ Authorization = "Basic $($Object)" }      
        $global:AuthObject | Format-List
    }
}

function get-pluginlicenses {
    [CmdletBinding()]
    param (
        [Parameter( Mandatory=$true)]
        [array]$Plugins      
    )
    begin {}
    process {
        
        $Results = @()
        $Plugins | ForEach-Object {
            
            $Query = Invoke-RestMethod `
            -Uri "https://$($_)/api/v1/licenses" `
            -Method GET `
            -ContentType 'application/json' `
            -Headers  $AuthObject `
            -SkipCertificateCheck


            $Results += $Query
        }
        
        return $Results
    
    } # END PROCESS
} # END FUNCTION


function get-pluginusage {
    [CmdletBinding()]
    param (
        [Parameter( Mandatory=$true)]
        [array]$Plugins      
    )
    begin {}
    process {
        
        $Results = @()
        $Plugins | ForEach-Object {
            
            $Query = Invoke-RestMethod `
            -Uri "https://$($_)/api/v1/licenses/usages" `
            -Method GET `
            -ContentType 'application/json' `
            -Headers  $AuthObject `
            -SkipCertificateCheck
            $Query | Add-Member -MemberType NoteProperty -Name Plugin -Value $_
            $Results += $Query
        }
        
        return $Results
    
    } # END PROCESS
} # END FUNCTION

function get-pluginvcenter {
    [CmdletBinding()]
    param (
        [Parameter( Mandatory=$true)]
        [array]$Plugins    
    )
    begin {}
    process {
        
        $Results = @()
        $Plugins | ForEach-Object {
            
            $Query = Invoke-RestMethod `
            -Uri "https://$($_)/api/v1/vcs" `
            -Method GET `
            -ContentType 'application/json' `
            -Headers  $AuthObject `
            -SkipCertificateCheck

            $Results += $Query
        }
        
        return $Results
    
    } # END PROCESS
} # END FUNCTION

function get-pluginclusters {
    [CmdletBinding()]
    param (
        [Parameter( Mandatory=$true)]
        [array]$Plugins    
    )
    begin {}
    process {
        
        $Results = @()
        $Plugins | ForEach-Object {
            
            $Query = Invoke-RestMethod `
            -Uri "https://$($_)/api/v1/rp-clusters" `
            -Method GET `
            -ContentType 'application/json' `
            -Headers  $AuthObject `
            -SkipCertificateCheck

            $Results += $Query
        }
        
        return $Results
    
    } # END PROCESS
} # END FUNCTION

function get-plugingroups {
    [CmdletBinding()]
    param (
        [Parameter( Mandatory=$true)]
        [array]$Plugins    
    )
    begin {}
    process {
        
        $Results = @()
        $Plugins | ForEach-Object {
            
            $Query = Invoke-RestMethod `
            -Uri "https://$($_)/api/v1/groups" `
            -Method GET `
            -ContentType 'application/json' `
            -Headers  $AuthObject `
            -SkipCertificateCheck

            $Results += $Query
        }
        
        return $Results
    
    } # END PROCESS
} # END FUNCTION

function get-plugincopies {
    [CmdletBinding()]
    param (
        [Parameter( Mandatory=$true)]
        [array]$Plugins,
        [Parameter( Mandatory=$true)]
        [array]$Groups    
    )
    begin {}
    process {
        
        $Results = @()
        $Plugins | ForEach-Object {
            
            foreach($Group in $Groups) {
                $Query = Invoke-RestMethod `
                -Uri "https://$($_)/api/v1/groups/$($Group.id)/copies" `
                -Method GET `
                -ContentType 'application/json' `
                -Headers  $AuthObject `
                -SkipCertificateCheck

                $Results += $Query
            }
            
        }
        
        return $Results
    
    } # END PROCESS
} # END FUNCTION

function get-protectedvms {
    [CmdletBinding()]
    param (
        [Parameter( Mandatory=$true)]
        [array]$Plugins  
    )
    begin {}
    process {
        
        $Results = @()
        $Plugins | ForEach-Object {
                       
            $Query = Invoke-RestMethod `
            -Uri "https://$($_)/api/v1/vms" `
            -Method GET `
            -ContentType 'application/json' `
            -Headers  $AuthObject `
            -SkipCertificateCheck

            # $Results += $Query
            $Query | ForEach-Object {
                $Object = [ordered]@{
                copyId = $_.copyId
                esxClusterId = $_.esxClusterId
                esxClusterName = $_.esxClusterName
                groupId = $_.groupId
                groupName = $_.groupName
                guestOsType = $_.guestOsType
                id = $_.id
                localMacAddressReplication = $_.localMacAddressReplication
                name = $_.name
                protectFutureNewVmdks = $_.protectFutureNewVmdks
                replicaVmdkDiskProvisioningType = $_.replicaVmdkDiskProvisioningType
                replicateVmHardware = $_.replicateVmHardware
                role = $_.role
                rpClusterId = $_.rpClusterId
                rpClusterName = $_.rpClusterName
                status = $_.status
                vcId = $_.vcId
                vcName = $_.vcName
                vmFolderInInventory =$_.vmFolderInInventory
                vmReplicationId = $_.vmReplicationId
                vmToolsVersion = $_.vmToolsVersion
                vmdks = ($_.vmdks | ConvertTo-Json)
                    
                }

                $Results += (New-Object -TypeName pscustomobject -Property $Object)
            }
        }
        
        return $Results
    
    } # END PROCESS
} # END FUNCTION

function get-events {
    [CmdletBinding()]
    param (
        [Parameter( Mandatory=$true)]
        [array]$Plugins,
        [Parameter( Mandatory=$true)]
        [int]$Days
    )
    begin {}
    process {
        
        $Date = Get-Date
        $Start = $Date.AddDays(-$Days)

        $Results = @()
        $Plugins | ForEach-Object {
                       
            $Query = Invoke-RestMethod `
            -Uri "https://$($_)/api/v1/events?startTime=$($Start.toString('yyyy-MM-dd'))T00:00:00.000Z&endTime=$($Date.toString('yyyy-MM-dd'))T23:59:59.999Z" `
            -Method GET `
            -ContentType 'application/json' `
            -Headers  $AuthObject `
            -SkipCertificateCheck

            $Results += $Query
         }

        return $Results
    
    } # END PROCESS
} # END FUNCTION