param(
[string]$username = "nul",
[switch]$file = $false
)

if ($username -eq "nul"){
	Write-Host "Usage: GetUserInfo [-file] username"
}
else{
	Import-Module -Name ActiveDirectory
	 
	$username=(Get-Culture).TextInfo.ToTitleCase("$username")
	 
	$filepath = $username + "-UserInfo.log"
	 
	$out = Get-ADUser $username -Properties Created,Enabled,LockedOut,PasswordExpired,PasswordLastSet

	if ($file) {
		Out-File -InputObject $out -Filepath "$filepath"
	}
	else {
		Write-Output $out
	}

}