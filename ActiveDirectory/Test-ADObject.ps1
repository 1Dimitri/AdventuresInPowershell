Function Test-ADObject {  
    [CmdletBinding()]  
   param(  
     [parameter(Mandatory=$true,position=0)]  
     $DistinguishedName  
     )  
      Try {  
        Get-ADObject -Identity $DistinguishedName -ErrorAction Stop   | Out-Null
        return $true  
        }   
     Catch [Microsoft.ActiveDirectory.Management.ADIdentityNotFoundException] {  
         return $false  
         }  
 }   
 
