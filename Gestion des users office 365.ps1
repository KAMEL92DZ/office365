# en priemier se connecter en admnin a azure AD

Connect-AzureAD

$PasswordProfile=New-Object -TypeName Microsoft.Open.AzureAD.Model.PasswordProfile
$PasswordProfile.Password="3Rv0y1q39/chsy"

New-AzureADUser -DisplayName "hakim policier" -GivenName "hakim" -SurName "policier" -UserPrincipalName hakimpoliciers@hadidconsulting.onmicrosoft.com -UsageLocation FR -MailNickName hakim -PasswordProfile $PasswordProfile -AccountEnabled $true

# Cet exemple crée des comptes d’utilisateurs à partir du fichier nommé "C:\psoshell\conact.csv"

Import-Csv -Path "C:\psoshell\contact.csv" | foreach {New-MsolUser -DisplayName $_.DisplayName -FirstName $_.FirstName -LastName $_.LastName -UserPrincipalName $_.UserPrincipalName -UsageLocation $_.UsageLocation -LicenseAssignment $_.AccountSkuId} | Export-Csv -Path "C:\psoshell\contact.csv"

# afficher des détails sur les services Office 365 disponibles dans tous vos plans de licence

Get-AzureADSubscribedSku | Select SkuPartNumber

# Ensuite, stockez les informations des plans de licence dans une variable.
$licenses = Get-AzureADSubscribedSku

# Ensuite, affichez les services dans un plan de licence spécifique.
$licenses[<index>].ServicePlans
# <index> est un entier qui spécifie le numéro de ligne du plan de licence à partir de Get-AzureADSubscribedSku | Select SkuPartNumber l’affichage de la commande, moins 1.
# Par exemple, si l’affichage de la:
Get-AzureADSubscribedSku | Select SkuPartNumber

#SkuPartNumber
-------------
#WIN10_VDA_E5
EMSPREMIUM
ENTERPRISEPREMIUM
FLOW_FREE

# La commande permettant d’afficher les services pour le plan de licence ENTERPRISEPREMIUM est la suivante:

$licenses[2].ServicePlans
# ENTERPRISEPREMIUM est la troisième ligne. Par conséquent, la valeur d’index est (3-1) ou 2.

# se connecter au clien office 365 https://docs.microsoft.com/fr-fr/office365/enterprise/powershell/connect-to-office-365-powershell#connect-with-the-microsoft-azure-active-directory-module-for-windows-powershell

Connect-MsolService


# afficher des informations récapitulatives sur vos plans de gestion des licences actuels

Get-MsolAccountSku

# Pour afficher les détails des services Office 365 disponibles dans tous vos plans de licence
Get-MsolAccountSku | Select -ExpandProperty ServiceStatus

#Cet exemple illustre les services Office 365 disponibles dans le plan de gestion des licences hadidconsulting: ENTERPRISPRENIUM (Office 365 Enterprise E5).
(Get-MsolAccountSku | where {$_.AccountSkuId -eq "hadidconsulting: ENTERPRISPREMIUM"}).ServiceStatus
 
 #afficher la liste de tous les comptes d’utilisateur de votre organisation auxquels aucun de vos plans de licence n’a été attribué (utilisateurs sans licence)
Get-AzureAdUser | ForEach{ $licensed=$False ; For ($i=0; $i -le ($_.AssignedLicenses | Measure).Count ; $i++) { If( [string]::IsNullOrEmpty(  $_.AssignedLicenses[$i].disabledplans ) -ne $True) { $licensed=$true } } ; If( $licensed -eq $false) { Write-Host $_.UserPrincipalName} }

#Pour afficher la liste de tous les comptes d’utilisateurs de votre organisation auxquels ont été affectés des plans de gestion des licences (utilisateurs sous licence)
Get-AzureAdUser | ForEach { $licensed=$False ; For ($i=0; $i -le ($_.AssignedLicenses | Measure).Count ; $i++) { If( [string]::IsNullOrEmpty(  $_.AssignedLicenses[$i].disabledplans ) -ne $True) { $licensed=$true } } ; If( $licensed -eq $true) { Write-Host $_.UserPrincipalName} }