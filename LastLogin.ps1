param(
[string]$userinput = "nul",
[switch]$console = $true,
[switch]$file = $false
)
$filename=$userinput.Trim(".\")
$filename=$filename.split(".")[0]

$outputFile = "$filename" + "-lastlogin.log"
$WQLFilter="NOT SID = 'S-1-5-18' AND NOT SID = 'S-1-5-19' AND NOT SID = 'S-1-5-20'" 
$FilterSID
if ($userinput -eq "nul"){
	echo "Usage: LastUserLogin [-file] <userinput> [-console]"
}
else{
Import-Module -Name ActiveDirectory
if ($file){
	Get-Content $userinput | ForEach-Object {
	$useraccountSID=$null
	$LastUser=$null
	$useraccount=$null
	try{
	$Win32User = Get-WmiObject -Class Win32_UserProfile -Filter $WQLFilter -ComputerName $_ -erroraction 'silentlycontinue'
	$LastUser = $Win32User | Sort-Object -Property LastUseTime -Descending | Select-Object -First 1 
	$LastUseTime = $LastUser.LastUseTime
	$DisplayTime = [System.Management.ManagementDateTimeConverter]::ToDateTime($LastUseTime)
	$useraccountSID=New-Object System.Security.Principal.SecurityIdentifier($LastUser.SID)
	$useraccount=$useraccountSID.Translate([System.Security.Principal.NTAccount]) 
	}
	catch{
	$useraccount="Computer is offline"
	}
	$printLine += $_ + " " + $useraccount + " " + $DisplayTime + "`n"
	}
}
else{
	$useraccountSID=$null
	$LastUser=$null
	$useraccount=$null
	try{
	$Win32User = Get-WmiObject -Class Win32_UserProfile -Filter $WQLFilter -ComputerName $userinput -erroraction 'silentlycontinue'
	$LastUser = $Win32User | Sort-Object -Property LastUseTime -Descending | Select-Object -First 1 
	$LastUseTime = $LastUser.LastUseTime
	$DisplayTime = [System.Management.ManagementDateTimeConverter]::ToDateTime($LastUseTime)
	$useraccountSID=New-Object System.Security.Principal.SecurityIdentifier($LastUser.SID)
	$useraccount=$useraccountSID.Translate([System.Security.Principal.NTAccount]) 
	}
	catch{
	$useraccount="Computer is offline"
	$DisplayTime=$Null
	}
	$printLine += $_ + " " + $useraccount + " " + $DisplayTime + "`n"
	
}
if ($console){
Write-Host $printLine
}
else{
Set-Content $outputFile $null
Add-Content $outputFile $printLine
Invoke-Item $outputfile
}
}