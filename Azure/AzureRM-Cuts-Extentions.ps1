#Installed BGInfo
Set-AzureRmVMExtension -ExtensionName BGInfo -Publisher Microsoft.Compute -Version 2.1 -ExtensionType BGInfo -Location "West US" -ResourceGroupName Common -VMName jumpBox1

