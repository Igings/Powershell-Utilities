param(
[Parameter(Mandatory=$True,
HelpMessage="Usage: MassNSLookup [-console] filename divider")]
[string]$inputFile = "nul",
[string]$divider = ",",
[switch]$console = $false,
[switch]$source = $false
)

if ($inputFile -eq "nul"){
	echo "Usage: MassNSLookup [-console] filename"
}
else{
	$filename=$inputFile.Trim(".\")
	$filename=$filename.split(".")[0]

	$outputFile = "$filename" + "-resolved.log"
	$printline=""

	Get-Content $inputFile | ForEach-Object{
	if ($source){
	$printline += $_
	$printline += $divider
	}
	try{
	$printline += [Net.DNS]::GetHostEntry("$_").HostName
	}
	catch{
	}
	$printline += "`n"
	}
	if ($console){
	Write-Host $printline
	}
	else{
	Set-Content $outputFile $null
	Add-Content $outputFile $printline
	}
}