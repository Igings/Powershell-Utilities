param(
[string]$file1 = "nul",
[string]$file2 = "nul"
)
if ($file2 -eq "nul"){
	echo "Usage: FileNotContains <file1> <file2>"
}
else{
	$filename=$file2.Trim(".\")
	$filename=$filename.split(".")[0]
	
	$file1name=$file1.Trim(".\")
	$file1name=$file1name.split(".")[0]
	$outputFile = "$filename" + " - notcontains $file1name.log"
	Set-Content $outputFile ""
	if ($file1 -eq "nul" -or $file2 -eq "nul" )
	{
		Write-Host "Filepath is invalid"
	}
	else{

	$mainFile = Get-Content $file1
	$compareFile = Get-Content $file2 

	$mainFile | ?{$compareFile -notcontains $_} | Out-file $outputFile
	Invoke-Item $outputfile
	}
}

