param(
[Parameter(Mandatory=$True,
HelpMessage="Usage: GetMembersFromGroup [-c|t] group_name")]
[string]$groupname = "nul",
[switch]$console=$false,
[switch]$table=$false,
[switch]$name=$false,
[switch]$type=$false
)
Import-Module -Name ActiveDirectory

if ($groupname -eq "nul"){
	echo "Usage: GetMembersFromGroup [-c|t] group_name"
}
else{
	if ($name){
	$nameformat="DistinguishedName"
	}
	else{
	$nameformat="SamAccountName"
	}
	
	if($groupname -eq "Domain Users"){
	Echo "Finding Domain Users. This may take a while"
	$out =
	Get-ADUser -LDAPFilter "(primaryGroupID=513)" -Properties Member |  
	Select-Object $nameformat | 
	Sort-Object $nameformat 

	$out = $out -replace " ",""
	$out = $out -replace "$nameformat",""
	$out = $out -replace "--------------",""
	$out = $out -replace "@{=",""
	$out = $out -replace "}",""
	}
	else{
	try{
	$out = 
	##Old selection that only worked for user
	#Get-ADGroup $groupname -Properties Member | 
	#Select-Object -ExpandProperty Member |
	#Get-ADUser |
	#Select-Object -Property $nameformat |
	#Sort-Object $nameformat

	Get-ADGroup $groupname -Properties Member | 
	Select-Object -ExpandProperty Member | 
	Get-ADObject -Properties $nameformat | 
	Select-Object ObjectClass,$nameformat | 
	Sort-Object ObjectClass

	$out = $out -replace ";",""
	$out = $out -replace "@{$nameformat=",""
	$out = $out -replace "@{ObjectClass=",""
	$out = $out -replace "SamAccountName=",""
	$out = $out -replace "}",""

	}
	catch{
	break
	}
	}
	if ($console){
		Write-Host -Separator `n $out
	}
	elseif ($table){
		$out | Out-GridView
	}
	else{
		Out-file  -InputObject $out -Filepath "$groupname.log"
		Invoke-Item "$groupname.log"
	}
}