param(
[string]$hostname = "nul",
[string]$port = "443",
[switch]$debug=$false
)

if ($hostname -eq "nul"){
	echo "Usage: PortCheck hostname port"
}
else{
	try{
		$t = New-Object System.Net.Sockets.TcpClient "$hostname" , $port; 
		
		if($t.Connected) { 
			Write-Host "Connection to $hostname on port $port succeeded" -ForegroundColor Green
			} 
		}
	catch{
		
			Write-Host "Connection to $hostname on port $port failed" -ForegroundColor Red
		
			if($debug){
			$ErrorMessage = $_.Exception.Message
			$FailedItem = $_.Exception.ItemName
			Write-Host "Item: $FailedItem. `n   ErrorMessage: $ErrorMessage"
			}
		}
	}
