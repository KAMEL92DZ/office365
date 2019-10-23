Get-AzureADSubscribedSku | Select SkuPartNumber

Get-AzureADUser -ObjectID <user sign-in name (UPN)> | Select DisplayName, UsageLocation

# exemple attribution d'une licence entreprise prenium a nassim@econseil.onmicrosoft.com

Set-MsolUserLicense -UserPrincipalName "nassim@econseils.onmicrosoft.com" -AddLicenses "econseils:ENTERPRISEPREMIUM"

# cette exemple cree le user OMAR HADID
$PasswordProfile=New-Object -TypeName Microsoft.Open.AzureAD.Model.PasswordProfile
$PasswordProfile.Password="Kahina1981"

New-AzureADUser -DisplayName "OMAR HADID" -GivenName "OMAR" -SurName "HADID" -UserPrincipalName OMAR@econseils.onmicrosoft.com -UsageLocation FR -MailNickName OMAR -PasswordProfile $PasswordProfile -AccountEnabled $true


Set-MsolUserLicense -UserPrincipalName "omar@econseils.onmicrosoft.com" -AddLicenses "econseils:ENTERPRISEPREMIUM"

# Pour attribuer une licence � un grand nombre d�utilisateurs sans licence, ex�cutez cette commande.
Get-MsolUser -All -UnlicensedUsersOnly | Set-MsolUserLicense -AddLicenses "econseils:ENTERPRISEPREMIUM"

#Cet exemple attribue ces m�mes licences aux utilisateurs sans licence du d�partement des ventes aux �tats-Unis :

Get-MsolUser -All -Department "Sales" -UsageLocation "US" -UnlicensedUsersOnly | Set-MsolUserLicense -AddLicenses "litwareinc:ENTERPRISEPACK"