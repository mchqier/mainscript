### get Raum nummer using VLAN function
Function GetRaumNr
{
#Get IPaddress
$str=(Get-NetIPAddress ).IPAddress
$x=0
$x=$str.Split("{.}")
$l=$x.length
$m=@()
$i=0
for($i=0;$i -le $l;$i++){
    if ($x[$i] -eq 168) {
        $m+=$i+1      
      }
}

foreach($i in $m){

if (($x[$i] -lt 125) -and ($x[$i] -gt 100) ){
$Vlan=$x[$i] 
} 
}

$RaumNr=$Vlan-100
return $RaumNr
}

function Sendemail
{
    param([string] $msg)

   $RaumNr=GetRaumNr
   $RaumName="Raum $RaumNr"
   Send-MailMessage -From "$RaumName <RaumName@gfu.net>" -To "Technick <Technick@gfu.net>"  -Subject "$RaumName installation error" -Body $msg  -Priority High -dno onSuccess, onFailure -SmtpServer "192.168.50.8"
}

#run default script
Function DefaultScript
{

$DefaultScriptPath="\\nas00.gfu.net\disk\temp\Kurse\Default\install.ps1"
Invoke-Expression $DefaultScriptPath



}


#add to Logfile Function
Function LogWrite
{
   Param ([string]$logstring)

   Add-content $Logfile -value $logstring
}

