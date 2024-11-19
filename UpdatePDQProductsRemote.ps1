#Author: OldePSN00b
#Date: 2024-11-08
#Requires -Modules @{ ModuleName="PdqStuff"; RequiredVersion="6.2.3" } 

#What am I doing? Can I write a module? Heck, I don't know, I'm a N00b so I'll start with a script. So this requires Colby Burma's PDQStuff Module 
#(https://gitlab.com/ColbyBouma/pdqstuff), so it would need to be installed first. Ok so what do I want this to do? Well, basically update PDQ Inventory
#and Deploy without having to log in to the host server and open the programs, get the new version popup notification, click the button and have it pretty
#much silently do all that without touching Windows and the GUI. This should, in theory, be able to run in a scheduled task and check to see if either 
#need updating and do the update.

#This would be the server name of the server running PDQ Deploy and Inventory
$RemoteServer = "<your servername>"

#Let's run this scriptblock on the server to do the tasks required to update Deploy
Invoke-Command -ComputerName $RemoteServer -ScriptBlock { 
    #Here's the path to temporarily store the install file
    $DownloadPath = "C:\windows\Temp"
    #Use PDQStuff to get the current Deploy version
    $DeployCurrentVersion = Get-PdqInstalledVersion -Product 'Deploy'
    #Use PDQStuff to get the available Deploy version from PDQ
    $DeployAvailableVersion = Get-PdqLatestVersion -Product 'Deploy'
    #Set the local PDQ install path for the software
    $ProgramFolder = "C:\Program Files (x86)\Admin Arsenal"
    #Here's the name of the console, we'll use that later.
    $DeployProcessName = "PDQDeployConsole"
    If ($DeployCurrentVersion -lt $DeployCurrentVersion.version) {
        #Is there a new version available? If so, let's tell people.
        Write-Host "New Deploy Version Available!:" $DeployAvailableVersion.version
        #Then we can tell them that we're going to grab it and install.
        Write-Host "Downloading Version $DeployAvailableVersion.version and Installing"
        #This pulls the download from the PDQ site and drops it in the specified download path
        Invoke-RestMethod -Uri $DeployAvailableVersion.downloadUrl -OutFile "$DownloadPath\Deploy_$($DeployAvailableVersion.version).exe"
        #Do the install
        Start-Process -FilePath $DownloadPath\Deploy_$($DeployAvailableVersion.version).exe -ArgumentList "/S" -NoNewWindow -Wait
        #Clean up after ourselves, we're not slobs.
        Remove-Item -Path $DownloadPath\Deploy_$($DeployAvailableVersion.version).exe
        # Start the executable
        Write-Host "Restarting Deploy"
        Start-Process -FilePath "$ProgramFolder\PDQ Deploy\$DeployProcessName.exe"
        # Wait for 30 seconds for the process to start 
        Start-Sleep -Seconds 30
        # Get the process and kill it
        Stop-Process -Name $DeployProcessName -Force	
    }else{
        #We don't have to do anything! That was easy.
        Write-Host "Current Deploy Version Installed!: $DeployCurrentVersion"
    }
}
Invoke-Command -ComputerName $RemoteServer -ScriptBlock { 
    #Here's the path to temporarily store the install file
    $DownloadPath = "C:\windows\Temp"
    #Use PDQStuff to get the current Inventory version
    $InventoryCurrentVersion = Get-PdqInstalledVersion -Product 'Inventory'
    #Use PDQStuff to get the available Inventory version from PDQ
    $InventoryAvailableVersion = Get-PdqLatestVersion -Product 'Inventory'
    #Set the local PDQ install path for the software
    $ProgramFolder = "C:\Program Files (x86)\Admin Arsenal"
    #Here's the name of the console, we'll use that later.
    $InventoryProcessName = "PDQInventoryConsole" 
 If ($InventoryCurrentVersion -lt $InventoryAvailableVersion.version) {
    #Is there a new version available? If so, lets tell people.
    Write-Host "New Inventory Version Available: $InventoryAvailableVersion.version"
    #Then we can tell them that we're going to grab it and install.
    Write-Host "Downloading Version $InventoryAvailableVersion.version and Installing"
    #This pulls the download from the PDQ site and drops it in the specified download path
    Invoke-RestMethod -Uri $InventoryAvailableVersion.downloadUrl -Outfile $DownloadPath\Inventory_$($InventoryAvailableVersion.version).exe
    #Do the install
    Start-Process -FilePath $DownloadPath\Inventory_$($InventoryAvailableVersion.version).exe -ArgumentList "/S" -NoNewWindow -Wait
    #Clean up after ourselves, we're not slobs.
    Remove-Item -Path $DownloadPath\Inventory_$($InventoryAvailableVersion.version).exe
    # Start the executable
    Write-Host "Restarting Inventory"
    Start-Process -FilePath "$ProgramFolder\PDQ Inventory\$InventoryProcessName.exe"
    # Wait for 30 seconds for the process to start
    Start-Sleep -Seconds 30
    # Get the process and kill it
    Stop-Process -Name $InventoryProcessName -Force
}else{
    #We don't have to do anything! That was easy.
    Write-Host "Current Inventory Version Installed!: $InventoryCurrentVersion"  
}
}
