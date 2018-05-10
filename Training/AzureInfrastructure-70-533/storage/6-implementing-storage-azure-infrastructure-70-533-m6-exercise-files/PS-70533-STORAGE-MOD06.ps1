break
# #############################################################################
# Implment and Configure SQL Databases
# NAME: PS-70533-STORAGE-MOD06.ps1
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

# connect to subscription (ASM)
Add-AzureAccount
$sub = '150dollar'
$storage = '704psstorage'
Set-AzureSubscription -SubscriptionName $sub -CurrentStorageAccountName $storage
Select-AzureSubscription -SubscriptionName $sub -Default
#endregion

#region Create Azure SQL database

$credential = Get-Credential 

$server = New-AzureSqlDatabaseServer -AdministratorLogin $credential.UserName `
    -AdministratorLoginPassword $credential.GetNetworkCredential().Password `
    -Location 'South Central US' `
    -Version 12.0 `

New-AzureSqlDatabase -ServerName $server.ServerName `  #random servername in .database.windows.net DNS domain
    -DatabaseName 'psdatabase1' `
    -Edition Standard `

# ARM analog
Get-Command -Module azurerm.sql -Verb New

Get-Help New-AzureRmSqlServer -Examples

Get-help New-AzureRmSqlDatabase -Examples

#endregion