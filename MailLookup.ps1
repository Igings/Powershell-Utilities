param(
[Parameter(Mandatory=$True,
HelpMessage="Usage: MailLookup username|file")]
[string]$inputFile = "nul"
)

$filename=$inputFile.Trim(".\")
$filename=$filename.split(".")[0]
$outputFile = "$filename" + "-maillookup.log"

Import-Module -Name ActiveDirectory

if (Test-Path $inputFile -PathType Leaf){
	Set-Content $outputFile $null
	Get-Content $inputFile | ForEach-Object{
	if ($_ -match '@'){
	$userid=Get-ADUser -LDAPFilter "(mail=$_)"
	$printline += $userid.SamAccountName
	$printline += "`t"	
	$printline += $_
	}
	else{
	$userid=Get-ADUser -LDAPFilter "(SamAccountName=$_)" -Property mail
	$printline += $_
	$printline += "`t"
	$printline += $userid.mail	
	}

	$printline += "`n"
	}
Add-Content $outputFile $printline
Invoke-Item $outputfile
}
else{
	if ($inputFile -match "@"){
	$userid=Get-ADUser -LDAPFilter "(mail=$inputFile)"
	$printline += $userid.SamAccountName
	}
	else{
	$userid=Get-ADUser -LDAPFilter "(SamAccountName=$inputFile)" -Property mail
	$printline += $userid.mail
	}
	Write-Host $printline
}
