param(
[Parameter(Mandatory=$True,
HelpMessage="Usage: BootTime ComputerName|file")]
[string]$inputFile = "nul"
)


if (Test-Path $inputfile -PathType Leaf){ #see if input is a file

	$filename=$inputFile.Trim(".\")
	$filename=$filename.split(".")[0]
	$outputFile = "$filename" + "-BootTime.log"
	Set-Content $outputFile $null

	Get-Content $inputFile | ForEach-Object{

	$boot = SystemInfo /s $_ | Select-String 'Boot Time'
	
	$printline += $_ + "`t" + $boot + "`n"
	
	}
	Add-Content $outputFile $printline
	Invoke-Item $outputFile
}
else{
	if ($inputFile -eq "nul"){
	Write-Host "Enter a Computer Name"
	}
	else{
	
	$boot = SystemInfo /s $inputFile | Select-String 'Boot Time'
	$boot = $boot -replace "System Boot Time:",""
	$boot = $boot -replace "	",""
	$boot = $boot -replace " ",""
	$time = $boot -replace "$inputFile",""
	
	$boottime=[datetime]::parseexact($time, 'dd/MM/yyyy,HH:mm:ss', $null)
	$currenttime=Get-Date
	$t=New-timespan -Start $boottime -End $currenttime
	$tdays=$t.Days
	$thours=$t.Hours
	$tminutes=$t.Minutes
	
	
	Write-Host -ForegroundColor cyan $inputFile `t $boot
	Write-Host -ForegroundColor yellow "$tdays Days, $thours Hours, $tminutes Minutes since last boot"
	}
}