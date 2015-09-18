function Replace-TrailingZeroesWithK{
<#
    .Synopsis
	
 	 Replaces the final three zeroes in a number with K and returns a string.
     
	.Description 
	 
     Replaces the final three zeroes in a number with K and returns a string.
     
     Converts 35000 to 35K

     Function merely converts any other number to a string and returns that string.
	 
	.Parameter Input
	
	 Represents the input to be converted. General assumption is that it will be an integer.
	 
	.Example
	
	 Replace-TrailingZeroesWithK -Input 35000

     Returns 35K

    .Example
	
	 Replace-TrailingZeroesWithK -Input 1500

     Returns 1500 since it does not have three trailing zeroes to replace.
	 
	.Link
	 http://www.github.com/joshatwell/powershell
	 
	.Notes
	
	====================================================================
	Disclaimer: This script is written as best effort and provides no 
	warranty expressed or implied. Please contact the author(s) if you 
	have questions about this script before running or modifying
	====================================================================
#>
param(
		[Parameter(
        Mandatory=$True)]
        $input
)

If($input.ToString().EndsWith("000")){
$front = $input.ToString().SubString(0,$input.ToString().Length-3)
$end = ($input.ToString()).Substring($input.ToString().Length-3)

$replace = $front + ($end).Replace("000","K")
}Else{
$replace = $input.ToString()
}
Return $replace
}