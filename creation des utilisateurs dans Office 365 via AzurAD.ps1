# Création de comptes d’utilisateurs avec Office 365 PowerShell /Utilisez le module Azure Active Directory
# Premier se connecter a office 365 en tant que ADMIN

$adminUPN="kamel@econseils.onmicrosoft.com"
$orgName="econseils"
$userCredential = Get-Credential -UserName $adminUPN -Message "Type the password."
Connect-SPOService -Url https://$orgName-admin.sharepoint.com -Credential $userCredential

$PasswordProfile=New-Object -TypeName Microsoft.Open.AzureAD.Model.PasswordProfile
$PasswordProfile.Password="<user account password>"
New-AzureADUser -DisplayName "<display name>" -GivenName "<first name>" -SurName "<last name>" -UserPrincipalName <sign-in name> -UsageLocation <ISO 3166-1 alpha-2 country code> -MailNickName <mailbox name> -PasswordProfile $PasswordProfile -AccountEnabled $true

# cette exemple cree le user Nassim FRER
$PasswordProfile=New-Object -TypeName Microsoft.Open.AzureAD.Model.PasswordProfile
$PasswordProfile.Password="Kahina1981"
New-AzureADUser -DisplayName "Nassim FRER" -GivenName "Nassim" -SurName "FRER" -UserPrincipalName Nassim@econseils.onmicrosoft.com -UsageLocation FR -MailNickName Nassim -PasswordProfile $PasswordProfile -AccountEnabled $true

# pour cree des user a partir d'un fichier csv 
# Pour afficher des informations récapitulatives sur vos plans de gestion des licences actuels et sur les licences disponibles pour chaque plan, exécutez la commande suivante:

Get-AzureADSubscribedSku | Select -Property Sku*,ConsumedUnits -ExpandProperty PrepaidUnits

# pour preparer l'importation du fichier csv exesuté la commande
Import-Csv -Path <Input CSV File Path and Name> | foreach {New-MsolUser -DisplayName $_.DisplayName -FirstName $_.FirstName -LastName $_.LastName -UserPrincipalName $_.UserPrincipalName -UsageLocation $_.UsageLocation -LicenseAssignment $_.AccountSkuId [-Password $_.Password]} | Export-Csv -Path <Output CSV File Path and Name>

# il ce peut quil soit necessaire de vous reconnecter a 
Connect-MsolService
# importé le fichier csv nommé pour l'exemple NewAccountResults.csv
Import-Csv -Path "C:\Users\KamelHadid\Documents\NewAccounts.csv" | foreach {New-MsolUser -DisplayName $_.DisplayName -FirstName $_.FirstName -LastName $_.LastName -UserPrincipalName $_.UserPrincipalName -UsageLocation $_.UsageLocation -LicenseAssignment $_.AccountSkuId} | Export-Csv -Path "C:\Users\KamelHadid\Documents\NewAccountResults.csv"


# jusqu'a cette etape tous est ok les users ont été crée 

######