$MiImagesKey = (Get-AzureRmStorageAccountKey -StorageAccountName misa1encrypted -ResourceGroupName bla-mi).value[0]
net use m: \\misa1encrypted.file.core.windows.net\mi-images /u:misa1encrypted $MiImagesKey


Get-AzureRmStorageAccount | select ResourceGroupName, StorageAccountName, Location | format-table -auto
