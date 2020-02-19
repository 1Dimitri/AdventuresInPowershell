## Get SID

# Domain User
$objUser = New-Object System.Security.Principal.NTAccount("DOMAIN_NAME", "USER_NAME")
# Local user
$objUser = New-Object System.Security.Principal.NTAccount("LOCAL_USER_NAME") 

$strSID = $objUser.Translate([System.Security.Principal.SecurityIdentifier])
$strSID.Value

# Note that SID ending with -0 are the Domain itself and cannot be parsed.
# replace ending 0 by a builtin RID to get the DomainAccountSID property value

## Get Name
$objSID = New-Object System.Security.Principal.SecurityIdentifier("ENTER-SID-HERE")
$objUser = $objSID.Translate( [System.Security.Principal.NTAccount])
$objUser.Value 
