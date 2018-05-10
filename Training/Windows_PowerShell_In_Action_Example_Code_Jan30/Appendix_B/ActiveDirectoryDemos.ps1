#
# Windows PowerShell in Action
#
# Appendix B - the active directory examples.
#

$commandcount=0; cls
$domain = [ADSI] `
  "LDAP://localhost:389/dc=NA,dc=fabrikam,dc=com"

$newOU = $domain.Create("OrganizationalUnit", "ou=HR")
$newOU.SetInfo()

$ou = [ADSI] `
  "LDAP://localhost:389/ou=HR,dc=NA,dc=fabrikam,dc=com"

$newUser = $ou.Create("user", "cn=Dogbert")
$newUser.Put("title", "HR Consultant")
$newUser.Put("employeeID", 1)
$newUser.Put("description", "Dog")
$newUser.SetInfo() 

$user = [ADSI] ("LDAP://localhost:389/" +
 "cn=Dogbert,ou=HR,dc=NA,dc=fabrikam,dc=com")

$user.title
$user.Description
$data = 
@{
 Name="Catbert"
 Title="HR Boss"
 EmployeeID=2
 Description = "Cat"
},
@{
 Name="Birdbert"
 Title="HR Flunky 1"
 EmployeeID=3
 Description = "Bird"
},
@{
 Name="Mousebert"
 Title="HR Flunky 2"
 EmployeeID=4
 Description = "Mouse"
},
@{
 Name="Fishbert"
 Title="HR Flunky 3"
 EmployeeID=5
 Description = "Fish"
}

function new-employee (
    $employees =
      $(throw "You must specify at least one employee to add"),
    [ADSI] $ou =
      "LDAP://localhost:389/ou=HR,dc=NA,dc=fabrikam,dc=com"
)
{
    foreach ($record in $employees)
    {
        $newUser = $ou.Create("user", "cn=$($record.Name)")
        $newUser.Put("title", $record.Title)
        $newUser.Put("employeeID", $record.employeeID)
        $newUser.Put("description", $record.Description)
        $newUser.SetInfo()
    }
}

function get-employee (
    [string] $name='*',
    [adsi] $ou =
      "LDAP://localhost:389/ou=HR,dc=NA,dc=fabrikam,dc=com"
)
{
    [void] $ou.psbase
    $ou.psbase.Children | where { $_.name -like $name}

}

new-employee $data
get-employee | ft name,title,homePhone
function set-employeeProperty (
    $employees =
    $(throw "You must specify at least one employee"),
    [hashtable] $properties =
      $(throw "You muset specify some properties"),
    [ADSI] $ou =
      "LDAP://localhost:389/ou=HR,dc=NA,dc=fabrikam,dc=com"
)
{
    foreach ($employee in $employees)
    {
	if ($employee -isnot [ADSI])
	{
            $employee = get-employee $employee $ou
        }

	foreach ($property in $properties.Keys)
        {
            $employee.Put($property, $properties[$property])
        }
        $employee.SetInfo()
    }
}

set-employeeProperty dogbert,fishbert @{
    title="Supreme Commander"
    homePhone = "5551212"
}

get-employee | ft name,title,homePhone
function Remove-Employee (
    $employees =
      $(throw "You must specify at least one employee"),
    [ADSI] $ou =
      "LDAP://localhost:389/ou=HR,dc=NA,dc=fabrikam,dc=com"
)
{
    foreach ($employee in $employees)
    {
	if ($employee -isnot [ADSI])
	{
            $employee = get-employee $employee $ou
        }

	[void] $employee.psbase
        $employee.psbase.DeleteTree()
    }
}

remove-employee fishbert,mousebert
get-employee


