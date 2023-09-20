Get-WinEvent -FilterHashtable @{LogName='Security';Keywords=[System.Diagnostics.Tracing.EventKeywords]::AuditFailure.value__}

# or
Get-WinEvent -FilterXPath '*[System[band(Keywords,4503599627370496)]]' -LogName Security
