$DateNotTooOld = (Get-Date).AddDays(-30)
$ADFilter = '(Enabled -eq $True) -and (PasswordlastSet -ge $DateNotTooOld)'
$Computerlist = Get-ADComputer -Filter $ADFilter
