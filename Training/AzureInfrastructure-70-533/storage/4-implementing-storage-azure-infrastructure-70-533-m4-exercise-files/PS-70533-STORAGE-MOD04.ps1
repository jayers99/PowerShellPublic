break
# #############################################################################
# Manage Access
# NAME: PS-70533-STORAGE-MOD04.ps1
# 
# AUTHOR:  Tim Warner
# EMAIL: timothy-warner@pluralsight.com
# 
# COMMENT: 
# #############################################################################
 
# Press CTRL+M to expand/collapse regions

#region Log into Azure
# connect to subscription (ARM)
Login-AzureRmAccount
Select-AzureRmSubscription -SubscriptionName '150dollar'
Get-AzureRmSubscription
Get-Command -Module AzureRM.Storage

# connect to subscription (ASM)
Add-AzureAccount
$sub = '150dollar'
$storage = '704psstorage'
Set-AzureSubscription -SubscriptionName $sub -CurrentStorageAccountName $storage
Select-AzureSubscription -SubscriptionName $sub -Default

Get-AzureSubscription -Default | Select-Object -Property SubscriptionName
Get-Command -Module Azure -Noun *storage*
#endregion

#region Storage account security

# List containers in a storage account
https://704psstorage.blob.core.windows.net/?comp=list

# List blobs in a container
	
https://704psstorage.blob.core.windows.net/media?restype=container&comp=list

# Download blob(s)
https://704psstorage.blob.core.windows.net/media/80MBmovie.zip

# Get storage account keys
$key = Get-AzureStorageKey -StorageAccountName $storage
$primkey = $key.Primary
$seckey = $key.Secondary

(Get-AzureStorageKey -StorageAccountName $storage).Primary

# Create a context
$context = New-AzureStorageContext -StorageAccountName $storage -StorageAccountKey $key.Primary

# List blobs
Get-AzureStorageBlob -Container 'media'

# Shut down associated VMs before regenerating a storage key
Stop-AzureVM -Name 'myVM' -ServiceName 'myService' -StayProvisioned

# Regenerate a key
New-AzureStorageKey -StorageAccountName $storage -KeyType Primary # retry blob access (refresh creds)

#endregion

#region Shared Access Signatures

# Authenticate to ARM and select subscription
Login-AzureRmAccount
Select-AzureRmSubscription -SubscriptionName '150dollar'

# Get-Command
Get-Command -noun *SASToken

# Create a context
$storcontext = New-AzureStorageContext -StorageAccountName '704armstorage' -StorageAccountKey 'JUvHT3qU3A4QlcUHpB25TpIngyqfrpKufro7hkd+bbEYe7SOd0djCkkxOCtP8fNoB6qrBmsi+VwoF4SmN2mHtg=='

# Create an SAS token (container is currently private)
New-AzureStorageBlobSASToken -Container 'scripts' `
   -Blob 'PS-70533-STORAGE-MOD01.ps1' `
   -Permission rwd `
   -StartTime (Get-Date) `
   -ExpiryTime (Get-Date).AddHours(1) `
   -Context $storcontext `
   -FullUri

   https://704armstorage.blob.core.windows.net/scripts/PS-70533-STORAGE-MOD01.ps1?sv=2015-04-05&sr=b&sig
=9JzWJvNYMSBMWwvJWdYxL0vIfANkvIxHtmycN%2FKwGng%3D&st=2016-04-26T16%3A30%3A44Z&se=2016-04-26T17%3A30%3
A44Z&sp=rwd

# Create a stored access policy

Get-Command -Verb New -Noun *StoredAccessPolicy

New-AzureStorageContainerStoredAccessPolicy `
   -Container 'privcontainer' `
   -Policy 'rwdpolicy2' `
   -Permission rwd `
   -StartTime (Get-Date) `
   -ExpiryTime (Get-Date).AddHours(1) `
   -Context $storcontext

# Apply the policy to a new container
New-AzureStorageContainerSASToken `
   -Name 'newcontainer' `
   -Policy 'rwdpolicy' `
   -FullUri

# Remove stored access policy
Remove-AzureStorageContainerStoredAccessPolicy -Container 'myContainer' -Policy 'rwdpolicy'

#endregion








