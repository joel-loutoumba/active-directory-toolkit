```powershell
# Importer des users depuis CSV (en validant chaque ligne)
$CSV = Import-Csv -Path .\users.csv -Delimiter ';'
foreach ($u in $CSV) {
  try {
    New-ADUser `
      -Name "$($u.Prenom) $($u.Nom)" `
      -GivenName $u.Prenom `
      -Surname $u.Nom `
      -SamAccountName $u.SAM `
      -UserPrincipalName "$($u.SAM)@contoso.local" `
      -Path "OU=Users,OU=Tier2,DC=contoso,DC=local" `
      -AccountPassword (ConvertTo-SecureString $u.PassInit -AsPlainText -Force) `
      -ChangePasswordAtLogon $true `
      -Enabled $true `
      -ErrorAction Stop
    Write-Host "OK : $($u.SAM)" -ForegroundColor Green
  } catch {
    Write-Host "ERREUR : $($u.SAM) — $_" -ForegroundColor Red
  }
}
```
