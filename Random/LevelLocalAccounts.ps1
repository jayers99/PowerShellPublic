$ErrorActionPreference = "stop"
$ADS_UF_DONT_EXPIRE_PASSWD_MASK = 0x10000
$ADS_UF_DONT_EXPIRE_PASSWD_OFF = 0xEFFFF

foreach ($Computer in get-content d:\batch\lists\ComputerList.txt) 
{
	$Computer = $Computer.Trim()
	if ($Computer -eq "") {continue}
	if ($Computer -like "\\*")
	{
		$Computer = $Computer.TrimStart("\\")
	}
	
	#$Computer = $Computer + ".<domain>.com"

	$ServerName = $Computer.ToUpper()
    
    $ping = new-object System.Net.NetworkInformation.Ping
    $Reply = $ping.send($Computer)
    
    if($Reply.status -eq "success") 
	{
        Write-Host "============================================================================"
		Write-Host "$ServerName is online"
        
		# get a collection of all the local users
		$objComputer = [ADSI]("WinNT://" + $Computer + ",computer")
		
		$colUsers = ($objComputer.psbase.children |
			Where-Object {$_.psBase.schemaClassName -eq "User"} |
    			Select-Object -expand Name);
		trap
		{
			if ($Error[0].tostring() -match "Access is denied")
			{
				# try again with diff id
				Write-Host "Access is denied; try a different ID"
				Write-Host "Attempting to use old edgemaster creds"
				cmd.exe /c d:\batch\NetUseLoop.bat $computer IPC$ $Computer\edgemaster 3edc4rfv
				#net use \\$Computer\IPC$ /u:$Computer\edgemaster
				
				$colUsers = ($objComputer.psbase.children |
					Where-Object {$_.psBase.schemaClassName -eq "User"} |
						Select-Object -expand Name);
			}
			
			if ($Error[0].tostring() -match "The network path was not found")
			{
				# try again with diff id
				Write-Host "Firewall might be blocking you. ADSI needs 3268."
				continue
			}
		}
		
		# get a list of all the local admin
 		Write-Host "`tListing Local Admin Members"
		$adminGroup =[ADSI]("WinNT://" + $Computer + "/Administrators")
		$adminMembers = @($adminGroup.psbase.Invoke("Members"))
		$adminMembersList = $null
		$adminMembers | foreach {Write-Host `t`t $_.GetType().InvokeMember("Name", 'GetProperty', $null, $_, $null)} 
		$adminMembers | foreach {$adminMembersList = $adminMembersList + $_.GetType().InvokeMember("Name", 'GetProperty', $null, $_, $null) + ", "} 
		
		# change the jayers password or create if not exist
		Write-Host "`tChanging Passwords"
		if ($colUsers -notcontains "jayers")
		{
			$jayersUser = $objComputer.Create("User", "jayers")   
   			$jayersUser.SetPassword("metro3Cms")   
   			$jayersUser.SetInfo()
			Write-Host "`t`tjayers - account created"
   		}
		else
		{
			$jayersUser = [adsi]("WinNT://" + $Computer + "/jayers, user")
			$jayersUser.psbase.invoke("SetPassword", "metro3Cms")
			Write-Host "`t`tjayers - account password changed"
		}
		if ($adminMembersList -notmatch "jayers")
		{
			Write-Host "`t`tjayers - adding to admin group"
			$adminGroup.add("WinNT://" + $Computer + "/jayers")
		}
			
		# set the admin account password
		if ($colUsers -contains "Administrator")
		{
			$adminUser = [adsi]("WinNT://" + $Computer + "/Administrator, user")
			$adminUser.psbase.invoke("SetPassword", "1qaZ2wsx")
			Write-Host "`t`tAdministrator - account password changed"
		}
		
		# set the edgemaser password
		if ($colUsers -contains "edgemaster")
		{
			$edgeUser = [adsi]("WinNT://" + $Computer + "/edgemaster, user")
			$edgeUser.psbase.invoke("SetPassword", "3edC4rfv")
			Write-Host "`t`tedgemaster - account password changed"
		}
		
		# disable this list of local accounts
		Write-Host "`tDisabling Accounts"
		$disableLocalAccountList = "administrator", "model", "ModelUser", "SUPPORT_388945a0", "HelpAssistant", "Guest"
		foreach ($user in $disableLocalAccountList)
		{
			if ($colUsers -contains $user)
			{
				$disableUser = [adsi]("WinNT://" + $Computer + "/" + $user + ", user")
				$disableUser.psbase.invokeset("AccountDisabled", "True")
				$disableUser.setinfo()
				Write-Host "`t`t$user - account disabled"
			}
		}
		
		# set all the local accounts to expire passwords
		Write-Host "`tSetting all account passwords to expire"
		$passwordExpireExemptList = "ASPNET", ("IUSR_" + $Computer), ("IWAM_" + $Computer)
		foreach ($user in $colUsers)
		{
			if ($passwordExpireExemptList -notcontains $user)
			{
				$userAccount = [adsi]("WinNT://" + $Computer + "/" + $user + ", user")
				if(($userAccount.userFlags[0] -band $ADS_UF_DONT_EXPIRE_PASSWD_MASK) -ne 0)
				{ 
					$userAccount.invokeSet("userFlags", ($userAccount.userFlags[0] -band $ADS_UF_DONT_EXPIRE_PASSWD_OFF))
					$userAccount.commitChanges()
					Write-Host "`t`t$user - password changed to expire"
				}
				else
				{
					Write-Host "`t`t$user - password already set to expire"
				}
			}
		}
		
		# verify IIS accounts are setup correctly
		Write-Host "`tChecking IIS account setup"
		foreach ($user in $colUsers)
		{
			if ($user -eq ("IUSR_" + $Computer)){Write-Host "`t`t$user - is setup correctly"}
			if ($user -eq ("IWAM_" + $Computer)){Write-Host "`t`t$user - is setup correctly"}
			if ($user -match "IUSR_" -and ($user -ne ("IUSR_" + $Computer))){Write-Host "`t`t$user - is setup INCORRECTLY"}
			if ($user -match "IWAM_" -and ($user -ne ("IWAM_" + $Computer))){Write-Host "`t`t$user - is setup INCORRECTLY"}
		}

		# list extra accounts
		Write-Host "`tListing unapproved local accounts"
		$approvedLocalAccountList = "ASPNET", ("IUSR_" + $Computer), ("IWAM_" + $Computer), "administrator", "edgemaster", "jayers", "sql.service", "model", "ModelUser", "SUPPORT_388945a0", "HelpAssistant", "Guest", "postgres", "bla_SERVICE"
		foreach ($user in $colUsers)
		{
			if ($approvedLocalAccountList -notcontains $user){Write-Host "`t`t$user - not an approved local user"}
		}
    }
	else
	{
        Write-Host "$ServerName is not online - skipping"    
    }
}