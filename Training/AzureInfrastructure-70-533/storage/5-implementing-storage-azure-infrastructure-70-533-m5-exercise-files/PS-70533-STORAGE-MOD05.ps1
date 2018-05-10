break
# #############################################################################
# Configure Diagnostics, Monitoring, and Analytics
# NAME: PS-70533-STORAGE-MOD05.ps1
# 
# AUTHOR:  Tim Warner
# EMAIL: timothy-warner@pluralsight.com
# 
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

#region Enable metrics and logging

Help Set-AzureStorageServiceLoggingProperty -Examples

# remember to include a storage context (defaults to current storage account - Get-AzureSubscription)
# retention from 0 (infinite) to 365 days

Get-AzureSubscription | Select-Object -Property CurrentStorageAccountName

Help Set-AzureStorageServiceMetricsProperty -Examples

#endregion

#region Download log files

Get-AzureStorageBlob -Container '$logs' |
    Where-Object { $_.Name -match 'blob/2016/04/27/1500' } |
        Out-GridView -Title 'Storage Account Logs'

Get-AzureStorageBlobContent -Container '$logs' -Blob 'blob/2016/04/27/1500/000002.log'

#endregion
