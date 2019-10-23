# Tout d’abord, connectez-vous à votre client Office 365 avec un compte d’administrateur général.
$adminUPN="kamel@econseils.onmicrosoft.com"
$orgName="econseils"
$userCredential = Get-Credential -UserName $adminUPN -Message "Type the password."
Connect-SPOService -Url https://$orgName-admin.sharepoint.com -Credential $userCredential

<# Ensuite, déterminez le nom de connexion du compte d’utilisateur que vous souhaitez ajouter à un rôle (exemple : fredsm@contoso.com). On l’appelle aussi nom d’utilisateur principal (UPN).
Ensuite, déterminez le nom du rôle. Utilisez cetteliste d’autorisations des rôles d’administrateur dans Azure Active Directory.#>

# Ensuite, renseignez les noms de connexion et de rôle, et exécutez ces commandes.
# Voici un exemple d’un jeu de commandes terminées :

$userName="HugoM@econseils.onmicrosoft.com"
$roleName="SharePoint Service Administrator"
$role = Get-AzureADDirectoryRole | Where {$_.displayName -eq $roleName}
if ($role -eq $null) {
$roleTemplate = Get-AzureADDirectoryRoleTemplate | Where {$_.displayName -eq $roleName}
Enable-AzureADDirectoryRole -RoleTemplateId $roleTemplate.ObjectId
$role = Get-AzureADDirectoryRole | Where {$_.displayName -eq $roleName}
}
Add-AzureADDirectoryRoleMember -ObjectId $role.ObjectId -RefObjectId (Get-AzureADUser | Where {$_.UserPrincipalName -eq $userName}).ObjectID

<# $userName="<sign-in name of the account>"
$roleName="<role name>"
$role = Get-AzureADDirectoryRole | Where {$_.displayName -eq $roleName}
if ($role -eq $null) {
$roleTemplate = Get-AzureADDirectoryRoleTemplate | Where {$_.displayName -eq $roleName}
Enable-AzureADDirectoryRole -RoleTemplateId $roleTemplate.ObjectId
$role = Get-AzureADDirectoryRole | Where {$_.displayName -eq $roleName}
}
Add-AzureADDirectoryRoleMember -ObjectId $role.ObjectId -RefObjectId (Get-AzureADUser | Where {$_.UserPrincipalName -eq $userName}).ObjectID #>

# Pour afficher la liste des noms d’utilisateur pour un rôle spécifique, utilisez ces commandes. exemple recherche ****SharePoint Service Administrator******

$roleName="SharePoint Service Administrator"
Get-AzureADDirectoryRole | Where { $_.DisplayName -eq $roleName } | Get-AzureADDirectoryRoleMember | Ft DisplayName

# Pour afficher la liste des rôles disponibles que vous pouvez attribuer aux comptes d’utilisateur, utilisez cette commande :
Get-MsolRole | Sort Name | Select Name,Description

# Cette commande répertorie le nom d'affichage de vos comptes d'utilisateur, triés par nom d'affichage
Get-MsolUser -All | Where DisplayName -like "Marc*" | Sort DisplayName | Select DisplayName | More

# Une fois que vous avez déterminé le nom d’affichage du compte et le nom du rôle, utilisez ces commandes pour attribuer le rôle au compte :
#************ dans cette exemple on attribu a "Frank Baxter" le Role de "Teams Communications Administrator"*****************************
$dispName="Frank Baxter"
$roleName="Teams Communications Administrator"
Add-MsolRoleMember -RoleMemberEmailAddress (Get-MsolUser -All | Where DisplayName -eq $dispName).UserPrincipalName -RoleName $roleName

<# Noms de connexion des comptes d’utilisateur
Si vous utilisez le nom de connexion ou l’UPN des comptes d’utilisateur, déterminez les éléments suivants:
Nom d’utilisateur principal du compte d’utilisateur.
Si vous ne connaissez pas déjà le nom d’utilisateur principal, utilisez la commande suivante:#>

Get-MsolUser -All | Sort UserPrincipalName | Select UserPrincipalName | More

# attribuer les role par UPN
$upnName="MarieL@econseils.onmicrosoft.com"
$roleName="SharePoint Service Administrator"
Add-MsolRoleMember -RoleMemberEmailAddress $upnName -RoleName $roleName

<#****************Pour plusieurs modifications de rôle*******************
Déterminez les éléments suivants :
Les comptes d’utilisateur que vous souhaitez configurer. Vous pouvez utiliser les méthodes de la section précédente pour collecter le jeu de noms complets ou UPN.
Les rôles que vous souhaitez attribuer à chaque compte d’utilisateur.
Pour afficher la liste des rôles disponibles que vous pouvez attribuer aux comptes d’utilisateur, utilisez cette commande :#>

Get-MsolRole | Sort Name | Select Name,Description
<# Ensuite, créez un fichier texte au format CSV (valeurs séparées par des virgules) contenant le nom complet ou les champs UPN et nom de rôle. Vous pouvez le faire facilement avec Microsoft Excel.
Voici un exemple de nom d’affichage:#>
<# DisplayName,RoleName
"Belinda Newman","Billing Administrator"
"Scott Wallace","SharePoint Service Administrator"#>

# Ensuite, remplissez l’emplacement du fichier CSV et exécutez les commandes qui en résultent à l’invite de commande PowerShell.

$fileName="C:\Users\KamelHadid\Documents\usersroles.csv"
$roleChanges=Import-Csv $fileName | ForEach {Add-MsolRoleMember -RoleMemberEmailAddress (Get-MsolUser | Where DisplayName -eq $_.DisplayName).UserPrincipalName -RoleName $_.RoleName }
 

$fileName= "C:\Users\KamelHadid\Documents\attributUserRole.csv"
$roleChanges=Import-Csv $fileName | ForEach { Add-MsolRoleMember -RoleMemberEmailAddress $_.UserPrincipalName -RoleName $_.RoleName }