param(
[string]$inputFile = "nul",
[switch]$console = $false
)

if ($inputFile -eq "nul"){
	echo "Usage: IPLookup [-console] filename"
}
else{
	$filename=$inputFile.Trim(".\")
	$filename=$filename.split(".")[0]

	$outputFile = "$filename" + "-resolved.log"
	Get-Content $inputFile | ForEach-Object{
	$printline += $_
	$printline += "`t`t"
	$printline += [System.Net.Dns]::GetHostAddresses($_).IPAddressToString 
	$printline += "`n"
	}
	if ($console){
	echo $printline
	}
	else{
	Set-Content $outputFile $null
	Add-Content $outputFile $printline
	}
}
