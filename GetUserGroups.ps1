param(
[Parameter(Mandatory=$True,
HelpMessage="Usage: GetUserGroups username|file")]
[string]$inputfile=$null,
[string]$filter=$null,
[switch]$file=$false
)
	
Import-Module -Name ActiveDirectory
$outputfile = $inputfile + "-ADGroups.log"

#Test to see if input is file
if (Test-Path $inputfile -PathType Leaf){
	$location=Get-Location
	#If it is a file and folder doesn't currently exist, create a folder in the current location for output
	if (-Not (Test-Path $location\GetUserGroups -PathType Container)){
	New-Item -ItemType Directory -Path "$location\GetUserGroups" >$null 2>&1
	Write-Host "Output directory created in $location\GetUserGroups" -foregroundcolor yellow
	}
	
	#Create a log file for each username (Became too chaotic to have it all in 1 file), and trim whitespace
	Get-Content $inputfile| ? {$_.trim() -ne "" } |ForEach-Object{
	$outputfile = $_ + ".log"
	$out=$null
	$out = 
	Get-ADUser $_ -Properties MemberOf | 
	Select -ExpandProperty MemberOf |
	Sort-Object
	
	$out = $out -replace "(CN=)(.*?),.*",'$2'	#Remove AD junk
	$out = $out -match "$filter"	#Regex filter
	Out-File -InputObject $out -Filepath "$location\GetUserGroups\$outputfile"
	
	}
}
else{

	$inputfile=(Get-Culture).TextInfo.ToTitleCase("$inputfile")
	$outputfile = $inputfile + "-ADGroups.log"
	$out = 
	Get-ADUser $inputfile -Properties MemberOf | 
	Select -ExpandProperty MemberOf |
	Sort-Object

	$out = $out -replace "(CN=)(.*?),.*",'$2'
	$out = $out -match "$filter"

	if ($file) {
		Out-File -InputObject $out -Filepath "$outputfile"
		Invoke-Item $outputfile
	}
	else {
		Write-Host -Separator `n $out
	}
}