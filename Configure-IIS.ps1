<#

.SYNOPSIS
Configure-IIS configures IIS7 to host HelloIndigo Server. It can also be used to 
reverse a previous IIS7 configuration.

Only one of the following switches may be used at a time: -install, -uninstall.

.DESCRIPTION
Configure-IIS tests for the necessary Windows Process Activation Service
components needed to host WCF services in IIS7. It also provides a 
description of how to install these components, if needed.

Configure-IIS creates the Application Pool, Site, and Application objects
needed by the HelloIndigo Service.

Configure-IIS can be used to remove the IIS configuration created by a 
previous install.

.PARAMETER install
Creates the Application Pool, Site, and Application objects needed to host 
HelloIndigo Server.

.PARAMETER uninstall
Attempts to uninstall the Application Pool, Site, and Application objects
previously created to host HelloIndigo Server.

.PARAMETER checkWAS
Checks the installation status of the Windows Process Activation Service 
components needed to host WCF services in IIS7. Always true if -install
is specified. Defaults to false for -uninstall.

.PARAMETER location
Specifies the absolute path of the HelloIndigo Server IIS site. Path cannot 
contain wildcards or relative pathing (i.e. 'C:\somedir\..\site'.) This
parameter is optional. If it is not supplied it defaults to the expanded, 
absolute path: '\WASHosting\WASHost'

.EXAMPLE
.\Configure-IIS [-install|-uninstall] [-checkWAS] [-location:"c:\WASHost"]

.EXAMPLE
.\Configure-IIS [-i|-u] [-c] [-l "c:\WASHost"]

#>
param ([switch]$install,[switch]$uninstall,[switch]$checkWAS,[string]$location)

if (-not ($install -or $uninstall -or $checkWAS)){
    Get-Help $MyInvocation.MyCommand.Definition    
}

if ($install -and $uninstall){
    Write-Host "Incompatible switches specified, check help and try again."
} 

$checkWAS = $install -or $checkWAS

$dir = Get-Location

if ($location.Equals([string]::Empty)){
    $helloIndigoDir = $dir.ToString() + "\WASHost"        
}
else {
    $helloIndigoDir = $location
}

$appcmd = $env:windir + "\system32\inetsrv\appcmd.exe"
$dism = $env:windir + "\system32\dism.exe"

function Check-WAS{
    Write-Host 
	Write-Host "************************************************************************"
    
    if (-not [System.IO.File]::Exists($dism)){
        Write-Host "DISM.exe was not found on your system, possibly because of an"
        Write-Host "unsupported OS (i.e. Vista.) Please ensure that the following Windows"
        Write-Host "features are enabled:"
        Write-Host "WCF HTTP Activation"
        Write-Host "WCF Non-HTTP Activation"     
        Write-Host "************************************************************************"  
    } else {
        Write-Host "If either of these features are Disabled, then they must be enabled in"
    	Write-Host "Windows Features. (Windows Features -> MS .NET Framework 3.5.1) "
    	Write-Host "************************************************************************"
    	Write-Host
    	Write-Host "Status of WCF Activation features is as follows:"

    	$dismCmd = @"
$dism /online /get-features /Format:Table | FINDSTR /C:WCF
"@
	   cmd /c $dismCmd	
    
        Write-Host
    }
}

function Do-Install{
    Write-Host "Creating app pool WASHost"
    Write-Host
    
    $addAppPoolCmd = @"
$appcmd add apppool /name:WASHost /managedRuntimeVersion:v4.0
"@

    cmd /c $addAppPoolCmd
    
    Write-Host

    Write-Host "Creating site WASHost with http, net.pipe, and net.tcp bindings"
    Write-Host
    
    $addSiteCmd = @"
$appcmd add site /name:WASHost /bindings:"http/*:8999:,net.pipe/*,net.tcp/9000:*" /physicalPath:"$helloIndigoDir"
"@ 

    cmd /c $addSiteCmd
    
    Write-Host

    Write-Host "Setting up this application, WASHost/, for TCP, MSMQ, Named Pipes protocols"
    Write-Host
    
    $enableProtocolsCmd = @"
$appcmd set app "WASHost/" /enabledProtocols:http,net.tcp,net.pipe /applicationPool:WASHost
"@

    cmd /c $enableProtocolsCmd 
    
    Write-Host
}

function Do-Uninstall{
    Write-Host "Deleting site WASHost"
    Write-Host
    
    $addSiteCmd = @"
$appcmd list site /name:"WASHost" /xml | $appcmd delete site /in
"@ 

    cmd /c $addSiteCmd
    
    Write-Host
    
    Write-Host "Deleting app pool WASHost"
    Write-Host
    
    $addAppPoolCmd = @"
$appcmd list apppool /name:"WASHost" /xml | $appcmd delete apppool /in
"@

    cmd /c $addAppPoolCmd
    
    Write-Host
}

if ($checkWAS) {
    Check-WAS
}

if ($install){
    Do-Install
}

if ($uninstall){
    Do-Uninstall
}