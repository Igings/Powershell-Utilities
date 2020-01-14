param(
[string]$inputFile = 'nul',
[string]$attribute = "nul",
[switch]$without = $false
)

$filename=$inputFile.Trim(".\")
$filename=$filename.split(".")[0]

$outputFile = "$filename" + "-ADattribute.log"

Set-Content $outputFile $null
Import-Module -Name ActiveDirectory

$tableNames="UserID" + "," + "$attribute" 
Add-Content $outputFile $tableNames

Get-Content $inputFile | ForEach-Object {
	if ($without){
		$user=Get-ADUser -Filter 'sAMAccountName -eq $_ and -not $attribute -like "*"' -Properties $attribute
	}
	else{
		$user=Get-ADUser -Filter 'sAMAccountName -eq $_' -Properties $attribute
	}
	
#$printLine += $_ + ";" + $user.surname + ";" + $user.givenName + ";" + $user.$attribute + ";" +  $user.$attribute2 + ";" + $user.distinguishedName + "`n"
$printLine += $_ + "," + $user.$attribute + "`n"
}


Add-Content $outputFile $printLine