function Check-MinDotNetVersion {
<#
    .SYNOPSIS
    Checks for Minimum .NET Framework Version from the registery.
    
    .DESCRIPTION
    Function allows user to supply a .NET framework version number and then checks
    the local registry path HKLM:\SOFTWARE\Microsoft\NET Framework Setup\NDP\v4\Full
    for release information of the .NET framework installed. 

    Currently limited to .NET framework 4.5 iterations and higher.  
    Additional capabilities will be added in the future.
    
    .PARAMETER MinVersion
    Provide the minimum version required on the system
    Valid options currently are:
    4.5
    4.5.1
    4.5.2
    4.6

    .EXAMPLE
    PS> Check-MinDotNetVersion -MinVersion 4.5.1
   

    .NOTES
Author(s):
Josh Atwell    josh.c.atwell@gmail.com

====================================================================
|                        Disclaimer:                               |
| This script is written as best effort and provides no warranty   |
| expressed or implied. Please contact author if you have questions|
| about this script before running or modifying.                   |
====================================================================

Requirements:
1. Permissions on local system to inspect the registry
#>
[CmdletBinding()][OutputType('System.Management.Automation.PSObject')]

    Param
    (
    [parameter(Mandatory=$true,ValueFromPipeline=$false)]
    [ValidateNotNullOrEmpty()]
    [ValidateSet("4.5","4.5.1","4.5.2","4.6")]
    [String]$MinVersion
    )    

    begin {}
    
    process {

        try {
        
        # Define versions based on possible input          
        switch ($minversion) 
        { 
            "4.5" {$inputversion = 378389} 
            "4.5.1" {$inputversion = 378675} 
            "4.5.2" {$inputversion = 379893} 
            "4.6" {$inputversion = 381029} 
            default {$inputversion = 1000000}
        }
        
        $path = 'HKLM:\SOFTWARE\Microsoft\NET Framework Setup\NDP\v4\Full'

        $installedversion = (Get-ItemProperty -Path $path -Name Release).Release
        
        switch ($installedversion) 
        { 
            378389 {$installed = "4.5"} 
            378675 {$installed = "4.5.1"} 
            379893 {$installed = "4.5.2"} 
            381029 {$installed = "4.6"} 
            default {"Could not reference input $minversion"}
        }

        #$installedversion = Get-DotNetVersion

           
        }
        catch [Exception]{
        
            throw "Unable to identify requirements.  Something unexpected happened."
        }    
    }
    end {
    if($installedversion -ge $inputversion){
            Write-Output ".NET requirements of $minversion or greater confirmed for $path" -ForegroundColor Green
            
        }else{
            Write-Output "You need to update your .NET Framework to $minversion or greater for $item" -ForegroundColor Red
        }
        Write-Output "Your installed version is $installed"
    }
}
