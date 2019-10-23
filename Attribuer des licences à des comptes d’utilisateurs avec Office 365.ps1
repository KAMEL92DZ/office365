# En 1 er répertoriez les plans de licence pour votre client à l’aide de cette commande.
Get-AzureADSubscribedSku | Select SkuPartNumber
# Ensuite, obtenez le nom de connexion du compte auquel vous souhaitez ajouter une licence, également appelé nom d’utilisateur principal (UPN).
# exemple  (UPN)=  2ee5730b-0296-47c6-9483-9c919f89c6e9
Get-AzureADUser

# Ensuite, vérifiez que l’emplacement d’utilisation est affecté au compte d’utilisateur.
Get-AzureADUser -ObjectID <user sign-in name (UPN)> | Select DisplayName, UsageLocation

# Pour rechercher les comptes sans licence dans votre organisation, exécutez cette commande.
Get-MsolUser -All -UnlicensedUsersOnly

# Pour rechercher les comptes qui n’ont pas de valeur UsageLocation , exécutez cette commande.
Get-MsolUser -All | where {$_.UsageLocation -eq $null}

# Pour définir la valeur UsageLocation sur un compte, exécutez cette commande.remplacer account par le Mail et le countrycode FR par exemple
Set-MsolUser -UserPrincipalName "<Account>" -UsageLocation <CountryCode>

# Attribution de licences à des comptes d’utilisateur *******************************************************
Set-MsolUserLicense -UserPrincipalName "<Account>" -AddLicenses "<AccountSkuId>"

# Cet exemple attribue une licence du plan de gestion des licences econseils : ENTERPRISEPREMIUM (Office 365 Enterprise E5) à l’utilisateur sans licence calebs@econseils.onmicrosoft.com
Set-MsolUserLicense -UserPrincipalName "calebs@econseils.onmicrosoft.com" -AddLicenses "econseils:ENTERPRISEPREMIUM"

# Pour attribuer une licence à un grand nombre d’utilisateurs sans licence, exécutez cette commande.
Get-MsolUser -All -UnlicensedUsersOnly [<FilterableAttributes>] | Set-MsolUserLicense -AddLicenses "<AccountSkuId>"

# Cet exemple attribue des licences à tous les utilisateurs sans licence à partir du plan de gestion des licences litwareinc : ENTERPRISEPACK (Office 365 Enterprise E3) :
Get-MsolUser -All -UnlicensedUsersOnly | Set-MsolUserLicense -AddLicenses "econseils:ENTERPRISEPREMIUM"

# Cet exemple attribue ces mêmes licences aux utilisateurs sans licence du département des ventes aux États-Unis :
Get-MsolUser -All -Department "Sales" -UsageLocation "US" -UnlicensedUsersOnly | Set-MsolUserLicense -AddLicenses "litwareinc:ENTERPRISEPACK"

