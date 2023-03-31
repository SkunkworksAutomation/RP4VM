# Scripts (API version 5.3.2):
## Modules: 
* dell.rp4vm.psm1
    * PowerShell7 module that covers basic interaction with the RP4VM REST API
    * Functions
        * set-credentials: method to set the credentials for API usage
        * get-pluginlicenses: method for getting the license information
        * get-pluginusage: method for getting the license usage
        * get-pluginvcenter: method for getting the vcenter information
        * get-pluginclusters: method for getting the cluster information
        * get-plugingroups: method of setting the ddboost user password, assigned to a protection policy, in PowerProtect Datamanager
        * get-plugincopies: method for getting the copies for a group
        * get-protectedvms: method for getting the rp4vm protected virtual machines
        * get-events: method for getting rp4vm events
    
    * Tasks
        * Task-01: example query for licensing with output to csv
        * Task-02: example query for usage with output to csv
        * Task-03: example query for vcenter information with output to csv
        * Task-04: example query for cluster information with output to csv
        * Task-05: example query for protected virtual machines with output to csv
        * Task-06: example query for groups with output to csv
        * Task-07: example query for copies with output to csv
        * Task-08: example query for events that occured in the past x days