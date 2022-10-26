<#
.SYNOPSIS
Test if an Event Log exists

.DESCRIPTION
Test if a given eventlog created with New-EventLog exists

.PARAMETER LogName
Name of the log to test for

.EXAMPLE
Test-EventLog -LogName 'OEMLog'

.EXAMPLE
Test-EventLog -LogName 'Application'

.NOTES
N/A
#>
function Test-EventLog {
    param (
       # Name of the log
       [Parameter(Mandatory)]
       [String]
       [Alias("Name","Log")]
       $LogName
    )
    
    $LogList = Get-EventLog -List | Where-Object { $_.Log -eq $LogName }

    $LogList.Count -ne 0
}
