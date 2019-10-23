# vérifier si vous avez déjà installé SharePoint Online Management
Get-Module -Name Microsoft.Online.SharePoint.PowerShell -ListAvailable | Select Name,Version

# installer Sharepoint Online Management Shell en exécutant la commande
Install-Module -Name Microsoft.Online.SharePoint.PowerShell

# Se connecter avec un nom d'utilisateur et un mot de passe Renseignez les valeurs des variables $ adminUPN et $ orgName (en remplaçant tout le texte entre les guillemets, y compris les caractères <et>)
$adminUPN="kamel@hadidconsulting.onmicrosoft.com"
$orgName="hadidconsulting"
$userCredential = Get-Credential -UserName $adminUPN -Message "Type the password."
Connect-SPOService -Url https://$orgName-admin.sharepoint.com -Credential $userCredential

# Pour vous connecter avec une authentification multifacteur (MFA)
$orgName="<name of your Office 365 organization, example: contosotoycompany>"
Connect-SPOService -Url https://$orgName-admin.sharepoint.com

