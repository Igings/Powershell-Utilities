param(
[string]$attribute = "nul",
[switch]$without =$false
)
if ($attribute -eq "nul"){
	echo "Usage: ListUsersWithADAttribute [-without] <attribute>"
}
else{
	Set-Content "$attribute.log" ""
	Import-Module -Name ActiveDirectory
	if ($without){
	Get-ADUser -Filter '-not $attribute -like "*"' -Properties $attribute | Export-CSV -Path "$attribute.log" -Delimiter ";"
	}
	else{
	Get-ADUser -Filter '*' -Properties $attribute | Where-Object{$_.$attribute -ne $null} | Export-CSV -Path "$attribute.log" -Delimiter ";"
	}
}