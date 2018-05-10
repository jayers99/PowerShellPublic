break
# #############################################################################
# Configure the Import/Export Service
# NAME: PS-70533-STORAGE-MOD03.ps1
# 
# AUTHOR:  Tim Warner
# DATE:  2016/04/24
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

#region Import Job
Set-Location -Path 'C:\Users\Tim\Desktop\WAImportExport'

(Get-AzureStorageKey -StorageAccountName '704psstorage').Primary
#  QdKO+51xP8naPA4omhO8LK1ye653Ai8DYdxWUklmjmpXCctFLZHo4RCsTCZsi2eo/CGUu/Jvl2oD2JoLovtkVQ==

.\WAImportExport.exe

.\WAImportExport.exe PrepImport /j:toolsjob.jrn /id:toolsjob /logdir:c:\Logs /sk:QdKO+51xP8naPA4omhO8LK1ye653Ai8DYdxWUklmjmpXCctFLZHo4RCsTCZsi2eo/CGUu/Jvl2oD2JoLovtkVQ== /t:G /format /encrypt /srcdir:C:\tools /dstdir:tools/ 

# (global metadata) /MetadataFile:c:\WAImportExport\SampleMetadata.txt
# (file-level metadata) /PropertyFile:c:\WAImportExport\SampleProperties.txt









#endregion


