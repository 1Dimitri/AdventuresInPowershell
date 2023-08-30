Function Test-ADUser {  
    [CmdletBinding()]  
   param(  
     [parameter(Mandatory=$true,position=0)]  
     $Identity  
     )  
      Try {  
        Get-ADuser -Identity $Identity -ErrorAction Stop   | Out-Null
        return $true  
        }   
     Catch [Microsoft.ActiveDirectory.Management.ADIdentityNotFoundException] {  
         return $false  
         }  
 }   
