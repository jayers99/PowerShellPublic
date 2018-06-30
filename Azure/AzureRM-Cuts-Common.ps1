#login
Login-AzureRmAccount

#list subscriptions
Get-AzureRmSubscription

#change to different subscription
Get-AzureRmSubscription -SubscriptionName "Windows Azure  MSDN - Visual Studio Premium" | Select-AzureRmSubscription
Get-AzureRmSubscription -SubscriptionName "Pay-As-You-Go" | Select-AzureRmSubscription

#get my current subscription and check you default storage account
Get-AzureRmContext

# To select the default storage context for your current session
Set-AzureRmCurrentStorageAccount -ResourceGroupName "your resource group" -StorageAccountName "your storage account name"

# To list all of the blobs in all of your containers in all of your accounts
Get-AzureRmStorageAccount | Get-AzureStorageContainer | Get-AzureStorageBlob

# to get the skus for windows servers
$pubName = "MicrosoftWindowsServer"
$offerName = "WindowsServer"
Get-AzureRMVMImageSku -Location $location -Publisher $pubName -Offer $offerName | Select Skus
<#Skus                           
----                           
2008-R2-SP1                    
2008-R2-SP1-BYOL               
2012-Datacenter                
2012-Datacenter-BYOL           
2012-R2-Datacenter             
2012-R2-Datacenter-BYOL        
2016-Datacenter                
2016-Datacenter-Server-Core    
2016-Datacenter-with-Containers
2016-Nano-Server
#>


# This is used for storing custom images
#START PERSISTENT

$resourceGroup = "LabPersistent"
$location = "West US"
$storageAccountName = "labpersistentstorage"
New-AzureRmResourceGroup -Name $resourceGroup -Location $location
New-AzureRmStorageAccount -Name $storageAccountName -ResourceGroupName $resourceGroup -type Standard_LRS -Location $location

#END PERSISTENT



#START COMMON

$resourceGroup = "LabCommon"
$location = "West US"
$storageAccountName = "labcommonstorage"
$vnetName = "LabCommonVnet"
$vnetPrefix = "10.28.0.0/16"
$subnetPrefix = "10.28.1.0/24"
$jboxNicName = "LabJboxNic"
$jboxVmName = "LabJbox"
$jboxVmSize = "Basic_A1"
$jboxVmDiskName = "LabJboxSystemDisk"

$Times = @{}
$StopWatchTotal = New-Object -TypeName System.Diagnostics.Stopwatch
$StopWatchStage = New-Object -TypeName System.Diagnostics.Stopwatch
$StopWatchTotal.Start()

$StopWatchStage.Start()
Get-AzureRmResourceGroup -Name $resourceGroup -ev notPresent -ea 0

if ($notPresent)
{
    # ResourceGroup doesn't exist
}
else
{
    # ResourceGroup exist
    Remove-AzureRmResourceGroup -Name $resourceGroup
}
$StopWatchStage.Stop()
$Times.Add("Remove Old Resource Group", ($StopWatchStage.ElapsedMilliseconds / 1000))
$StopWatchStage.Reset()


#create resource group and network
$StopWatchStage.Start()
New-AzureRmResourceGroup -Name $resourceGroup -Location $location
New-AzureRmStorageAccount -Name $storageAccountName -ResourceGroupName $resourceGroup -type Standard_LRS -Location $location
$subnet = New-AzureRmVirtualNetworkSubnetConfig -Name frontendSubnet -AddressPrefix $subnetPrefix
$vnet = New-AzureRmVirtualNetwork -Name $vnetName -ResourceGroupName $resourceGroup -Location $location -AddressPrefix $vnetPrefix -Subnet $subnet
$StopWatchStage.Stop()
$Times.Add("Create Network", ($StopWatchStage.ElapsedMilliseconds / 1000))
$StopWatchStage.Reset()


#Create jbox
$StopWatchStage.Start()
$pip = New-AzureRmPublicIpAddress -Name $jboxNicName -ResourceGroupName $resourceGroup -Location $location -AllocationMethod Dynamic
$jboxNic = New-AzureRmNetworkInterface -Name $jboxNicName -ResourceGroupName $resourceGroup -Location $location -SubnetId $vnet.Subnets[0].Id -PublicIpAddressId $pip.Id
$jboxVm = New-AzureRmVMConfig -VMName $jboxVmName -VMSize $jboxVmSize
$jboxAdminCred = Get-Credential -Message "Local JBox Admin Credentials"
$jboxVm = Set-AzureRmVMOperatingSystem -VM $jboxVm -Windows -ComputerName $jboxVmName -Credential $jboxAdminCred -ProvisionVMAgent -EnableAutoUpdate
$jboxVm = Set-AzureRmVMSourceImage -VM $jboxVm -PublisherName "MicrosoftWindowsServer" -Offer "WindowsServer" -Skus "2016-Datacenter" -Version "latest"
$jboxVm = Add-AzureRmVMNetworkInterface -VM $jboxVm -Id $jboxNic.Id
$storeageAcct = Get-AzureRmStorageAccount -ResourceGroupName $resourceGroup -Name $storageAccountName
$jboxSystemDiskUri = $storeageAcct.PrimaryEndpoints.Blob.ToString() + "vhds/" + $jboxVmDiskName + ".vhd"
$jboxVm = Set-AzureRmVMOSDisk -VM $jboxVm -Name $jboxVmDiskName -VhdUri $jboxSystemDiskUri -CreateOption FromImage
New-AzureRmVM -ResourceGroupName $resourceGroup -Location $location -VM $jboxVm
$StopWatchStage.Stop()
$Times.Add("Create jbox vm", ($StopWatchStage.ElapsedMilliseconds / 1000))
$StopWatchStage.Reset()

$StopWatchTotal.Stop()
$Times.Add("Total", ($StopWatchTotal.ElapsedMilliseconds / 1000))
$Times.GetEnumerator() | Sort-Object -Property Value -desc | Format-Table @{label="Value";Expression={[math]::Round($_.Value)}}, Name -AutoSize

#END




Get-AzureRmVM -ResourceGroupName $resourceGroup -Name $jboxVmName -Status 
Get-AzureRmPublicIpAddress -ResourceGroupName $resourceGroup -Name $jboxNicName | select IpAddress

#start and stop the jumpbox
Stop-AzureRmVM -ResourceGroupName $resourceGroup -Name $jboxVmName
Start-AzureRmVM -ResourceGroupName $resourceGroup -Name $jboxVmName
Get-AzureRmPublicIpAddress -ResourceGroupName $resourceGroup -Name $jboxNicName | select IpAddress

