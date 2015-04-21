function Get-TimeDrift{
<#
	.Synopsis
 	 Generates List of Hosts whose time is drifted beyond a specified tolerance.
	 
	 Requires an acceptable drift (Seconds) 
	
	.Example
	 Get-VMHost | Get-TimeDrift | Export-CSV  "C:\Temp\TimeDrift.csv" -NoTypeInformation
	 
	.Example
	 Get-VMHost | Get-TimeDrift -AllowedDifferenceSeconds 60 | Export-Csv "C:\Temp\TimeDrift.csv" -NoTypeInformation
	 
	 Using -AllowedDifferenceSeconds with Integer will set the acceptable drift.
	 
	.Link
	 http://communities.vmware.com/message/1605420
	.Description
====================================================================
Author(s):		Josh Atwell <josh.c.atwell@gmail.com>
				nnedev from VMware Communities
 				
File: 			Get-TimeDrift.ps1
Purpose: 		Get Hosts whose Time is out of tolerance
 
Date:			2011-09-16
Revision: 		1
Items added: 	1. 
				2. 
Items to Add:	1. 
				2. 
 
References:		http://communities.vmware.com/message/1605420
				http://www.chriscolotti.us/vmware/vcloud/gotcha-the-importance-of-ntp-to-vmware-vcloud-director/

====================================================================
Disclaimer: This script is written as best effort and provides no 
warranty expressed or implied. Please contact the author(s) if you 
have questions about this script before running or modifying
====================================================================
#>

Param(
[CmdletBinding()]
[Parameter(ValueFromPipeline=$true,
	Position=0,Mandatory=$true,
	HelpMessage="Provide Hosts")]
	$InputObject,
[Parameter(ValueFromPipeline=$true,
	Position=1,Mandatory=$true,
	HelpMessage="Provide Acceptable Drift [Default = 60s]")]
	[INT]$AllowedDifferenceSeconds = 60
)

Begin {
	$FullReport = @()
}

Process {
	$InputObject | %{    
	    #	Get Host Datetime System
	    $dts = get-view $_.ExtensionData.configManager.DateTimeSystem
	    
	    #	Get Host Time
	    $t = $dts.QueryDateTime()
	    
	    #	Calculate Time Difference in Secconds
	    $s = ( $t - [DateTime]::UtcNow).TotalSeconds
	    
		    #	Check if Time Difference is too much
		    if([math]::abs($s) -gt $AllowedDifferenceSeconds){
		        
		        $row = "" | select HostName, Seconds
		        $row.HostName = $_.Name
		        $row.Seconds = $s
		        
				$FullReport += $row
		    }
	}
}
End{
	Return $FullReport
}
}
#	End Function