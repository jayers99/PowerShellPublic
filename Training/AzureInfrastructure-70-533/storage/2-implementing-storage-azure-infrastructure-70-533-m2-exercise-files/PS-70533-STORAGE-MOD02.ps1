break
# #############################################################################
# Implement Azure Files
# NAME: PS-70533-STORAGE-MOD02.ps1
# 
# AUTHOR:  Tim Warner
# DATE:  2016/04/09
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

#region Azure File Service

# Create a storage context
$key = (Get-AzureStorageKey -StorageAccountName $storage).Primary
$context = New-AzureStorageContext -StorageAccountName $storage -StorageAccountKey $key

# Create a new file share
$share = New-AzureStorageShare logs -Context $context

# Create a new directory in the share
New-AzureStorageDirectory -Share $share -Path AppLogs

# Upload a local file to the new directory
Set-AzureStorageFileContent -Share $share -Source 'D:\spooler.csv' -Path AppLogs

# Download files from azure storage file service
Get-AzureStorageFileContent -Share $share -Path AppLogs/testfile.txt -Destination D:\

# Obtain a file listing in the new directory
Get-AzureStorageFile -Share $share -Path AppLogs

# persist your storage account credentials
(Get-AzureStorageKey -StorageAccountName $storage).Primary
cmdkey /add:704psstorage.file.core.windows.net /U:704psstorage /pass:'QdKO+51xP8naPA4omhO8LK1ye653Ai8DYdxWUklmjmpXCctFLZHo4RCsTCZsi2eo/CGUu/Jvl2oD2JoLovtkVQ=='

net use t: \\704psstorage.file.core.windows.net\logs

net use l: \\704psstorage.file.core.windows.net\logs /u:704psstorage ''

net use t: \\704psstorage.file.core.windows.net\admintools /u:704psstorage QdKO+51xP8naPA4omhO8LK1ye653Ai8DYdxWUklmjmpXCctFLZHo4RCsTCZsi2eo/CGUu/Jvl2oD2JoLovtkVQ==










# Azure CLI

# Connect to our subscription
azure login
azure account list
azure account set '150dollar'

# Set the mode
azure config mode asm

# Add storage account
azure storage account create 'myaccount'

# Create a share
azure storage share create myshare

# Add a directory
azure storage directory create myshare myDir

# Upload a local file to the AFS directory
azure storage file upload 'D:\spooler.csv' myshare myDir

# Get a file list
azure storage file list myshare myDir

#endregion
