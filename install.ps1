﻿#mainscript
# RunAsAdministrator

if (!([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator")) { Start-Process powershell.exe "-NoProfile -ExecutionPolicy Bypass -File `"$PSCommandPath`"" -Verb RunAs; exit }

# region Include required files
#
$Global:restart=1
$ScriptDirectory = Split-Path -Path $MyInvocation.MyCommand.Definition -Parent
try {
    . ("$ScriptDirectory\functions.ps1")

}
catch {
    Write-Host "Error while loading supporting PowerShell Scripts" 
} #end the include
    
    

#Logfile variable




$Logfile = "c:\Choco.log"

if (Test-Path -Path $Logfile){Remove-Item –path $Logpath}
 
#Get RAum Nummer

$raumNr=GetraumNr
if (($RaumNr -lt 1) -or ($RaumNr -gt 18 )){
    echo "Raum Nummer ist nicht erkennbar" 
    $RaumNr = Read-Host "Bitte geben Sie der Raum Nummer type"
} 
#getscript name
$files=Get-ChildItem "\\nas00.gfu.net\disk\temp\raum\$raumNr"
foreach ( $file in $files) {
  $extn = [IO.Path]::GetExtension($file)
  if ($extn -eq ""){
       $scriptname=$file.name
  }
}
if( -not $Scriptname){ $Scriptname="NUR DEFAULT script"}

#--------------------------



Write-host "  Setup startet im Raum  $raumNr, $scriptname wird ausgeführt" -ForegroundColor Green





#run defaultscript
DefaultScript

#RAUM Script testen und ausführen#
$RaumNr

if (($RaumNr -lt 1) -or ($RaumNr -gt 18 )) {
    
    }else{ 
    $PSScriptPath ="\\nas00.gfu.net\disk\temp\Raum\"+$RaumNr + "\install.ps1"
    if (Test-Path -Path $PSScriptPath){
        
        Invoke-Expression $PSScriptPath
    } 
   
    
}  # end if RaumNr



#check log file if empty restart else show log file

$l=Test-Path -path "C:\choco.log"
if ($l){$log=Get-Content "c:\choco.log"}else{$log="NOLOG"}


If ($log -eq "NOLOG") 
{
    if ($restart -eq 1)
    {
    Write-Host "system will restart Press CTRL+c to cancel"
    for($i=10;$i -gt 0; $i--){
    write-host "-> $i  " -ForegroundColor DarkRed -BackgroundColor yellow -NoNewline
    Start-Sleep -s 1
    }
     Restart-computer -force
 }
    
   
 }else{
    echo $log
    Sendemail $log
    pause
    
 }
 








