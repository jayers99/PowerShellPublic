break
# #############################################################################
# Implement Blobs
# NAME: PS-70533-STORAGE-MOD01.ps1
# 
# AUTHOR:  Tim Warner
# DATE:  2016/04/08
# EMAIL: timothy-warner@pluralsight.com
# 
# COMMENT: 
#
# VERSION HISTORY
# 1.0 2016.04.01 Initial Version
# #############################################################################
 
# Press CTRL+M to expand/collapse regions

# connect to subscription (ARM)
Login-AzureRmAccount
Select-AzureRmSubscription -SubscriptionName $sub
Get-AzureRmSubscription
Get-Command -Module AzureRM.Storage

# connect to subscription (ASM)
Add-AzureAccount
$sub = '150dollar'
$storage = '704psstorage'
Set-AzureSubscription -SubscriptionName $sub -CurrentStorageAccountName $storage
Select-AzureSubscription -SubscriptionName $sub -Default
Get-AzureSubscription -Default
Get-Command -Module Azure -Noun *storage*

# New storage account (ASM)
New-AzureStorageAccount -StorageAccountName '704mynewstorageacct' -Type 'Standard_LRS' -Label 'ASMstoraccount' -Location 'South Central US'

Set-AzureStorageAccount -StorageAccountName '704summitvm' -Type 'Standard_LRS'

$st = Get-AzureStorageAccount -StorageAccountName '704mynewstorageacct'

$st | Get-Member

# Containers

New-AzureStorageContainer -Name 'vhds' -Permission Off

# Async blob copy - container to container within 1 storage account

$SrcContainer = 'cont1'
$DestContainer = 'vhds'
$srcBlob = 'smallvhd.vhd'

Set-AzureSubscription -SubscriptionName '150dollar' -CurrentStorageAccountName '704stor1'


Start-AzureStorageBlobCopy -SrcBlob $srcBlob -DestContainer $DestContainer -SrcContainer $SrcContainer 

# Copy blob between two storage accounts
$vhdName = 'osdisk1.vhd'
$srcContainer = 'vhds'
$destContainer = 'vhds'
$srcStorageAccount = '704stor1'
$destStorageAccount = '704stor2'

$srcStorageKey = (Get-AzureStorageKey -StorageAccountName $srcStorageAccount).Primary
# Need Select-AzureSubscription to switch to second Azure subscription
$destStorageKey = (Get-AzureStorageKey -StorageAccountName $destStorageAccount).Primary

$srcContext = New-AzureStorageContext –StorageAccountName $srcStorageAccount -StorageAccountKey $srcStorageKey
$destContext = New-AzureStorageContext –StorageAccountName $destStorageAccount -StorageAccountKey $destStorageKey
New-AzureStorageContainer -Name $destContainer -Context $destContext
$copiedBlob = Start-AzureStorageBlobCopy -SrcBlob $vhdName `
-SrcContainer $srcContainer `
-Context $srcContext `
-DestContainer $destContainer `
-DestBlob $vhdName `
-DestContext $destContext

# AzCopy reference: https://azure.microsoft.com/en-us/documentation/articles/storage-use-azcopy/#blob-copy

# AzCopy (copy blob within storage account)
AzCopy /Source:https://704stor1.blob.core.windows.net/cont1 /Dest:https://704stor2.blob.core.windows.net/cont2 /SourceKey:cUYFmD4vnMmmp88ysG2YEGo5AXxe7ivqP1+M9XcodzPzPmsYS99BYOoamk1NKcOakcBM3hqqb0tHPu0c8K6MFQ== /DestKey:azulvQvPXB/K2o+0wZBTvEuRAcMprAQb07YmBvboDZ2fQl44KrDjTVzDF1Ks6Xk6qlAvMW+4JHIgSdirugSfYg== /Pattern:report1.xlsx
