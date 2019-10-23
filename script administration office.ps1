AUTEUR: 
    . Augusto Simoes - Architecte solutions d'entreprise & formateur Microsoft - MVP SharePoint

#>

<# DEBUT DES VARIABLES A MODIFIER 

$AdminO365Login = "AugustoSimoes@administrationo365.onmicrosoft.com"

#>

$AdminO365Login = "Votre_Nom_Administrateur@Nom_de_votre_tenant_Office365.onmicrosoft.com" # Correspond à votre login administrateur Office 365
$UserFileFolder = "C:\PsoShell" # Chemin d'accès au dossier de travail des fichiers d'exercice à importer
$PasswordForUsers = "P@ssw0rd" # Le mot de passe qui sera affecté à vos nouveaux utilisateurs
$ImportUsersOffice365CSV = "ImportUserssOffice365.csv" # Représente le nom du fichier CSV contenant les informations des utilisateurs à importer dans Office 365
$PicturesFileFolder = "Pictures" # représente le nom du dossier contenant les photos des utilisateurs Office 365 
$FileToUploadToOffice365 = "FilesToUpload" # représente le nom du dossier contenant les fichiers à importer dans SharePoint 
$SharePointLibrary1 = "Documents Finance Interne"
$SharePointLibrary2 = "Documents Equipe Projet"
$SharePointLibrary3 = "Custom Library 2"
<# FIN DES VARIABLES A MODIFIER #>


<#  DEBUT DU SCRIPT POWERSHELL #>
#########################################################

<# RECUPERATION DES DIFFERENTES URI D'OFFICE 365 BASEES SUR LE NOM DU TENANT OFFICE 365 #>
$Replace = $AdminO365Login.Replace(".onmicrosoft.com","")
$replace = $replace.Split("@")
$replace = $Replace[1]

$SpPowerShellOnline = "https://$replace-admin.sharepoint.com"
$SpSiteCollection = "https://$replace.sharepoint.com"
$mySiteUri = "https://$replace-my.sharepoint.com"

<# DEFINITION DES CHEMINS D'ACCES DES DOSSIERS DE TRAVAIL #>
$UserFilePath = "$UserFileFolder\$ImportUsersOffice365CSV"
$PictureUsersFolder = "$UserFileFolder\$PicturesFileFolder"
$FileToUpload = "$UserFileFolder\$FileToUploadToOffice365"

<# TEST LA PRESENCE DES MODULES POWERSHELL ET IMPORTE LES MODULES DANS LA SESSION POWERSHELL #>
Write-host "Test et importation du module SharePoint Online PowerShell ..." -ForegroundColor Cyan
if (Get-Module -ListAvailable -Name Microsoft.Online.SharePoint.PowerShell) 
{
    Write-Host "Le Module existe. Importation du module."
    Import-Module Microsoft.Online.SharePoint.PowerShell |Out-Null

} 
else 
{
    Write-Host "Le Module Microsoft.Online.SharePoint.PowerShell n'existe pas. Veuillez installer le composant associé." -ForegroundColor Yellow
    pause
    exit
}

Write-host "Test et importation du module MsOnline PowerShell" -ForegroundColor Cyan
if (Get-Module -ListAvailable -Name MsOnline) 
{
    Write-Host "Le Module existe. Importation du module."
    Import-Module MsOnline |Out-Null

} 
else 
{
    Write-Host "Le Module MsOnline n'existe pas. Veuillez installer le composant associé." -ForegroundColor Yellow
    pause
    exit
}
<# FIN DU CHARGEMENT DES MODULES POUR OFFICE 365 #>


<# Connection vers Office 365 #>
Write-host "Entrez vos informations d'identification Administrateur Office 365" -ForegroundColor Yellow
$cred = Get-Credential $AdminO365Login
Write-host "Connexion à votre tenant Office 365." -ForegroundColor Yellow
Connect-MsolService -Credential $cred
<# Fin de connexion vers Office 365 Azure ADDS #>


<# Importation du fichier CSV contenant la liste des utilisateurs à créer #>
Write-host "Import du fichier CSV contenant les utilisateurs: $UserFilePath" -ForegroundColor Yellow
$usersFile = Import-Csv -Path $UserFilePath
<# Fin d'importation du fichier CSV contenant la liste des utilisateurs à créer #>

<# Création des utilisateurs dans Office 365 #>
Write-host "Création des utilisateurs dans Office 365" -ForegroundColor Cyan
Foreach ($User in $usersFile)
{
$Upn = $User.Upn; $DisplayName = $User.NomComplet; $Nom = $user.Nom; $Prenom = $user.Prenom; $Pays=$user.Pays;$service=$user.Service;$fonction=$user.Fonction;$manager=$user.Manager
Write-host "Création du compte Office 365 : $DisplayName" -ForegroundColor Yellow
# $TestUser = Get-MsolUser -UserPrincipalName $Upn -ErrorAction SilentlyContinue # Pas utilisé
$TestUser = Get-MsolUser|?{$_.DisplayName -like "$DisplayName"}
    if($TestUser -eq $null)
    {
    New-MsolUser -UserPrincipalName $Upn -DisplayName $DisplayName -FirstName $Prenom -LastName $Nom -Department $service -Country $pays -Title $fonction -UsageLocation FR
    Write-Host "Le compte Office 365 $DisplayName est maintenant disponible." -ForegroundColor Gray
    Write-Host ""
    }
    else
    {
    Write-Host "Le compte $DisplayName existe déjà dans Office 365." -ForegroundColor Yellow
    }
}
<# Fin de création des utilisateurs dans Office 365 #>

<# Vérification que tous les comptes soient bien créés dans Azure ADDS. Il faut quelques fois un certains temps pour que les comptes soient répliqués. #>

Write-host "Test de l'existence des comptes dans Azure. Patientez, merci." -ForegroundColor Yellow
$Table = @{}
$Count = $Table.Count
Write-host "Création d'une table temporaire pour tester les comptes. Patientez, merci." -ForegroundColor Yellow
Foreach($msoluser in $usersFile)
{
$MsolCurrentUser = $msoluser.NomComplet
$Table.Add($MsolCurrentUser,"False")
}
$Count = $Table.Count
Write-host "Lancement de la boucle de test pour tous les comptes utilisateurs. Patientez, merci." -ForegroundColor Magenta
Write-host "# d'utilisateurs: $Count" -ForegroundColor Magenta

do
{
Foreach ($msoluser in $usersFile)

     {
     $MsolCurrentUser = $msoluser.NomComplet
     $ExistUser = Get-MsolUser|?{$_.DisplayName -like "$MsolCurrentUser"}
     
     IF($Table.ContainsKey($MsolCurrentUser)) #User existe dans la table.
     {
            If($ExistUser -eq $null) #User n'existe pas dans Office 365.
            {
             Write-host "L'utilisateur $MsolCurrentUser n'est pas encore dans Office 365. Patientez !" -ForegroundColor Magenta 
            }
            else #user exist dans O365
            {
             $table.Remove($MsolCurrentUser)
             Write-host "Le compte $MsolCurrentUser est actuellement dans Office 365. Bonne nouvelle !" -ForegroundColor Green

            }
     }
     

 } 
 $Count = $Table.Count
}
until ($Count -eq 0)
Write-host "Tous les utilisateurs sont bien présents dans votre annuaire Office 365. Bonne nouvelle !" -ForegroundColor Green
<# Fin de la vérification que tous les comptes soient bien créés dans Azure ADDS. #>

<# Affectation des licences aux utilisateurs #>
$Unlicencied = Get-MsolUser -UnlicensedUsersOnly|?{($_.LastDirSyncTime -eq $null) -and ($_.DisplayName -ne "On-Premises Directory Synchronization Service Account") -and ($_.CloudExchangeRecipientDisplayType -ne 7) -and ($_.CloudExchangeRecipientDisplayType -ne 0)}
[String]$AccountSku = (Get-MsolAccountSku).AccountSkuId
$ActiveUnits = (Get-MsolAccountSku).ActiveUnits
$ConsumeUnits = (Get-MsolAccountSku).ConsumedUnits
Write-host "Office 365 Account SKU: $AccountSku" -ForegroundColor DarkCyan
Write-Host "Office 365 - Licence active: $ActiveUnits" -ForegroundColor DarkCyan
Write-host "Office 365 - Licence utilisés: $ConsumeUnits" -ForegroundColor DarkCyan
$RemainUnits = $ActiveUnits - $ConsumeUnits
Write-Host "Nombre de licences utilisateurs restantes: $RemainUnits" -ForegroundColor Yellow
$NeedUnits = $Unlicencied.Count
Write-Host "# de licences nécessaires pour tous les utilisateurs: $NeedUnits" -ForegroundColor Yellow
If($NeedUnits -gt $RemainUnits)
{Write-host "Certains utilisateurs ne peuvent pas obtenir de licence, car le nombre de licences disponibles est insuffisant." -ForegroundColor Yellow}
else{Write-host "Tous les utilisateurs peuvent recevoir une licence." -ForegroundColor Cyan}

if ($RemainUnits -ne 0){
Foreach ($Nolicence in $Unlicencied)
{
$UpnUser = $Nolicence.UserPrincipalName
Write-Host "Assignation de licence pour l'utilisateur: $UpnUser" -ForegroundColor Cyan
Set-MsolUserLicense -UserPrincipalName $UpnUser -AddLicenses "$AccountSku" -ErrorAction SilentlyContinue
}
}
Write-Host ""
<# Fin de l'affectation des licences à tous les utilisateurs #>



<# Connexion à SharePoint Online #>
Write-Host "Connexion vers SharePoint Online (O365) pour ajouter les utilisateurs dans le groupe MEMBRES de la collection de site" -ForegroundColor Yellow
Connect-SPOService -Url $SpPowerShellOnline -credential $cred
<# Fin de connexion à SharePoint Online #>

<# Récupération de l'objet Collection de sites de SharePoint Online et du groupe MEMBRES #>
$RootSitecol = Get-SPOSite $SpSiteCollection
Write-host "La collection de site racine est: " $RootSitecol.Url -ForegroundColor Yellow
$SpoGroup = Get-SPOSiteGroup -Site $RootSitecol|?{$_.Title -like "*Membres"}
$SpoGroupName = $SpoGroup.Title
Write-host "Le groupe MEMBRES de la collection de sites est: " $SpoGroupName -ForegroundColor Yellow
<# Fin de récupération de l'objet Collection de sites de SharePoint Online et du groupe MEMBRES #>

<# Ajout des utilisateurs dans le groupe MEMBRES de la collection de sites SharePoint Online #>
Foreach ($Spuser in $Unlicencied)
{
$Login = $Spuser.UserPrincipalName
Write-Host "Ajout de l'utilisateur $Login dans le groupe SharePoint MEMBRES" -ForegroundColor Cyan 
Add-SPOUser -Site $RootSitecol -LoginName $Login -Group $SpoGroupName -ErrorAction SilentlyContinue
}
<# Fin d'ajout des utilisateurs dans le groupe MEMBRES de la collection de site SharePoint Online #>


<# Ajout des photos pour les utilisateurs #>
write-host "Connexion à Exchange Online pour modifier les utilisateurs" -ForegroundColor Yellow
$ExchangeOnline = New-PSSession -ConfigurationName Microsoft.Exchange -ConnectionUri https://outlook.office365.com/powershell -Credential $Cred -Authentication basic -AllowRedirection
write-host "Importation de la session PowerShell pour Exchange Online" -ForegroundColor Yellow
Import-PSSession $ExchangeOnline -AllowClobber -ErrorAction SilentlyContinue

# Récupération de tous les utilisateurs dans toutes les boîtes aux lettres dans Exchange Online
$AllUsers = Get-User|?{($_.RecipientType -eq "UserMailbox") -and ($_.Name -notlike "DiscoverySearchMailbox*") -and ($_.RecipientTypeDetails -ne "RoomMailbox") -and ($_.RecipientTypeDetails -ne "SharedMailbox") -and ($_.RecipientTypeDetails -ne "EquipmentMailbox")}
Write-Host "Ajout des photos utilisateurs pour Exchange et SharePoint" -ForegroundColor Yellow

foreach ($item in $AllUsers)
{
$CurrentUser = $item.Name
$CurrentUserPhotoName = $CurrentUser.replace(".","")
$CurrentPicture = Get-ChildItem -Path $PictureUsersFolder|?{$_.Name -eq "$CurrentUserPhotoName.jpg"}
$FullPicturePath = $CurrentPicture.FullName

    if($FullPicturePath -ne $null)
    { 
       
    $photo = ([Byte[]] $(Get-Content -Path $FullPicturePath -Encoding Byte -ReadCount 0))
    Set-UserPhoto -Identity $CurrentUser -PictureData $photo -Confirm:$false
    Write-host "L'utilisateur: $CurrentUser a une photo correspondante à son profil $FullPicturePath. Fait !" -ForegroundColor Cyan
    }
    else{Write-host "L'utilisateur: $CurrentUser n'a pas de photo de correspondance à charger dans le dossier source." -ForegroundColor Red}   
}
<# Fin de l'ajout des photos pour les utilisateurs #>

<# Ajout de l'attribut MANAGER(RESPONSABLE) pour les utilisateurs #>
Write-Host "Ajout de l'attribut MANAGER pour les utilisateurs" -ForegroundColor Yellow

foreach($usermanage in $usersFile)
{
$Manager = $usermanage.Manager
    if($Manager -ne "")
    {
    $CurrentManager = Get-User "$Manager"
    $CurrentManagerName = $CurrentManager.UserPrincipalName
    $CurrentUpn = $usermanage.Upn
    write-host "Définir le responsable: $CurrentManagerName pour l'utilisateur: $CurrentUpn" -ForegroundColor Cyan 
    Set-User $CurrentUpn -Manager $CurrentManagerName
    }
    else
    {
    write-host "L'utilisateur: $CurrentUpn ne contient pas d'attribut MANAGER dans le fichier CSV." -ForegroundColor Yellow
    }
}
<# Fin d'ajout de l'attribut MANAGER(RESPONSABLE) pour les utilisateurs #>

<# Changement du mot de passe pour les nouveaux utilisateurs #>
write-host "Forcer le nouveau mot de passe $PasswordForUsers" -ForegroundColor Yellow
Foreach ($User in $usersFile)
{
$UserPrincipalName = $User.Upn
$NameUser = $User.NomComplet
Set-MsolUserPassword -UserPrincipalName $UserPrincipalName -NewPassword $PasswordForUsers
write-host "Changement temporaire du mot de passe pour l'utilisateur $NameUser" -ForegroundColor Cyan
} 
write-host "Les utilisateurs devront changer leur mot de passe à la première connexion au service Office 365." -ForegroundColor Green
Remove-PSSession $ExchangeOnline
<# Fin de changement du mot de passe pour les nouveaux utilisateurs #>

<# Provisionning du site MySite SharePoint pour tous les utilisateurs #>
$loadInfo1 = [System.Reflection.Assembly]::LoadWithPartialName("Microsoft.SharePoint.Client") | Out-Null
$loadInfo2 = [System.Reflection.Assembly]::LoadWithPartialName("Microsoft.SharePoint.Client.Runtime")| Out-Null
[System.Reflection.Assembly]::LoadWithPartialName("Microsoft.SharePoint.Client.UserProfiles")| Out-Null

$ctx = New-Object Microsoft.SharePoint.Client.ClientContext($SpPowerShellOnline)
$web = $ctx.Web
$username = $AdminO365Login
write-host "Veuillez entrer votre login administrateur Office 365"
$password = read-host -AsSecureString
$ctx.Credentials = New-Object Microsoft.SharePoint.Client.SharePointOnlineCredentials($username,$password)

$ctx.Load($web)
$ctx.ExecuteQuery()

$loader =[Microsoft.SharePoint.Client.UserProfiles.ProfileLoader]::GetProfileLoader($ctx)

#To Get Profile
$profile = $loader.GetUserProfile()
$ctx.Load($profile)
$ctx.ExecuteQuery()
$profile 

#To enqueue Profile
Foreach ($SpsUser in $usersFile)
{
$SpsUpn = $Spsuser.Upn
$loader.CreatePersonalSiteEnqueueBulk(@($SpsUpn)) 
$loader.Context.ExecuteQuery()
}

Write-Host "Les MySites de SharePoint Online vont être construits pour tous les utilisateurs." -ForegroundColor Cyan
<# Fin du provisionning du site MySite SharePoint pour tous les utilisateurs #>

<# Provisionning bibliothèques SharePoint #>
Write-Host "Provisionning des bibliothèques dans SharePoint." -ForegroundColor Cyan

# Connexion à SharePoint Online
$context = New-Object Microsoft.SharePoint.Client.ClientContext($SpSiteCollection)
$credentials = New-Object Microsoft.SharePoint.Client.SharePointOnlineCredentials($username , $password)
$context.Credentials = $credentials

# Création de la bibliothèque 1
$listCreationInformation = New-Object Microsoft.SharePoint.Client.ListCreationInformation
$listCreationInformation.Title = $SharePointLibrary1
$listCreationInformation.Description = "Financial Documents - Library created through PowerShell"
$listCreationInformation.TemplateType = 101
$list = $context.Web.Lists.Add($listCreationInformation)
$context.Load($list)
$context.ExecuteQuery()

# Création de la bibliothèque 2
$listCreationInformation = New-Object Microsoft.SharePoint.Client.ListCreationInformation
$listCreationInformation.Title = $SharePointLibrary2
$listCreationInformation.Description = "Corporate Documents - Library created through PowerShell"
$listCreationInformation.TemplateType = 101
$list = $context.Web.Lists.Add($listCreationInformation)
$context.Load($list)
$context.ExecuteQuery()

# Création de la bibliothèque 3
$listCreationInformation = New-Object Microsoft.SharePoint.Client.ListCreationInformation
$listCreationInformation.Title = $SharePointLibrary3
$listCreationInformation.Description = "Custom Library - Library created through PowerShell"
$listCreationInformation.TemplateType = 101
$list = $context.Web.Lists.Add($listCreationInformation)
$context.Load($list)
$context.ExecuteQuery()
<# Fin du provisionning bibliothèques SharePoint #>

<# Chargement des fichiers dans la bibliothèque 2 dans SharePoint #>
$context = New-Object Microsoft.SharePoint.Client.ClientContext($SpSiteCollection)
$credentials = New-Object Microsoft.SharePoint.Client.SharePointOnlineCredentials($username , $password)
$context.Credentials = $credentials

$DocLibName =  $SharePointLibrary2

$List = $Context.Web.Lists.GetByTitle($DocLibName)
$Context.Load($List)
$Context.ExecuteQuery()

$files = Get-childitem "$FileToUpload" -Recurse

Foreach ($File in $files)
{
$FileStream = New-Object IO.FileStream($File.FullName,[System.IO.FileMode]::Open)
$FileCreationInfo = New-Object Microsoft.SharePoint.Client.FileCreationInformation
$FileCreationInfo.Overwrite = $true
$FileCreationInfo.ContentStream = $FileStream
$FileCreationInfo.URL = $File
$Upload = $List.RootFolder.Files.Add($FileCreationInfo)
$Context.Load($Upload)
$Context.ExecuteQuery()
}
<# Fin du chargement des fichiers dans la bibliothèque 2 dans SharePoint #>

