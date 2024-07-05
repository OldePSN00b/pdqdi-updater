#Author: OldePSN00b
#Date: 2024-07-05

#What am I doing? Can I write a module? Heck, I don't know, I'm a N00b so I'll start with a script. So this requires Colby Burma's PDQStuff Module 
#(https://gitlab.com/ColbyBouma/pdqstuff), so it would need to be installed first. Ok so what do I want this to do? Well, basically update PDQ Inventory
#and Deploy without having to log in to the host server and open the programs, get the new version popup notification, click the button and have it pretty
#much silently do all that without touching Windows and the GUI. This should, in theory, be able to run in a scheduled task and check to see if either 
#need updating and do the update.

#So here we query the needed version information, this uses PDQStuff Get-PdqInstalledVersion and Get-PDQLatestVersion and set the download location.
$downloadpath = "C:\windows\Temp"
$DeployCurrentVersion = Get-PdqInstalledVersion -Product 'Deploy'
$InventoryCurrentVersion = Get-PdqInstalledVersion -Product 'Inventory'
$DeployAvailableVersion = Get-PdqLatestVersion -Product 'Deploy'
$InventoryAvailableVersion = Get-PdqLatestVersion -Product 'Inventory'

#So here we try to compare things, is the currently installed version of D&I less than the available version? If it's less, than download the newer version. 
If ($DeployCurrentVersion -lt $DeployAvailableVersion.version) {
    #Is there a new version available? If so, let's tell people.
    Write-Host "New Deploy Version Available!:" $DeployAvailableVersion.version
    #Then we can tell them that we're going to grab it and install.
    Write-Host "Downloading Version $DeployAvailableVersion.version and Installing"
    #This pulls the download from the PDQ site and drops it in the specified download path
    Invoke-WebRequest $DeployAvailableVersion.downloadUrl -OutFile $downloadpath
    #Do the install
    Start-Process -FilePath $downloadpath\Deploy_$($DeployAvailableVersion.version).exe -ArgumentList "/S" -NoNewWindow -Wait
    #Clean up after ourselves, we're not slobs.
    Remove-Item -Path $downloadpath\Deploy_$($DeployAvailableVersion.version).exe
    }else{
    #We don't have to do anything! That was easy.
    Write-Host "Current Deploy Version Installed!: $DeployCurrentVersion"
}
If ($InventoryCurrentVersion -lt $InventoryAvailableVersion.version) {
    #Is there a new version available? If so, lets tell people.
    Write-Host "New Inventory Version Available: $InventoryAvailableVersion.version"
    #Then we can tell them that we're going to grab it and install.
    Write-Host "Downloading Version $InventoryAvailableVersion.version and Installing"
    #This pulls the download from the PDQ site and drops it in the specified download path
    Invoke-WebRequest $InventoryAvailableVersion.downloadUrl -Outfile $downloadpath
    #Do the install
    Start-Process -FilePath $downloadpath\Inventory_$($InventoryAvailableVersion.version).exe -ArgumentList "/S" -NoNewWindow -Wait
    #Clean up after ourselves, we're not slobs.
    Remove-Item -Path $downloadpath\Inventory_$($InventoryAvailableVersion.version).exe
    }else{
    #We don't have to do anything! That was easy.
    Write-Host "Current Inventory Version Installed!: $InventoryCurrentVersion"  
}