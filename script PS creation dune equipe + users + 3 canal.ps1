<# Add-TeamChannelUser	
Add-TeamUser	
Connect-MicrosoftTeams	
Disconnect-MicrosoftTeams	
Get-Team	
Get-TeamChannel	
Get-TeamChannelUser	
Get-TeamFunSettings	
Get-TeamGuestSettings	
Get-TeamHelp	
Get-TeamMemberSettings	
Get-TeamMessagingSettings	
Get-TeamPolicyPackage	
Get-TeamUser	
Get-TeamUserPolicyPackage	
Get-TeamUserPolicyPackageRecommendation	
Grant-TeamUserPolicyPackage	
New-Team	
New-TeamChannel	
Remove-Team	
Remove-TeamChannel	
Remove-TeamChannelUser	
Remove-TeamUser	
Set-Team	
Set-TeamChannel	
Set-TeamFunSettings	
Set-TeamGuestSettings	
Set-TeamMemberSettings	
Set-TeamMessagingSettings	
Set-TeamPicture#>

# 1er Installer le module MicrosoftTeams

Install-Module -Name MicrosoftTeams

# 2eme se connecter a microsoft Teams avec un compte Admin
Connect-MicrosoftTeams
# 3eme Cree une Equipe Teams

New-Team -DisplayName "Modern Workplace"

New-Team -DisplayName "Modern APPS" -Description "Team to developper " -Visibility Public

# exemple de script PS creation dune equipe + users + 3 canal 

Connect-MicrosoftTeams -AccountId kamel@econseils.onmicrosoft.com
$group = New-Team -displayname "PoweApps Teams" -Visibility "private"
Add-TeamUser -GroupId $group.GroupId -User "calebs@econseils.onmicrosoft.com"
Add-TeamUser -GroupId $group.GroupId -User "HugoM@econseils.onmicrosoft.com"
Add-TeamUser -GroupId $group.GroupId -User "MarcD@econseils.onmicrosoft.com"
New-TeamChannel -GroupId $group.GroupId -DisplayName "migration"
New-TeamChannel -GroupId $group.GroupId -DisplayName "gestion note de frais"
New-TeamChannel -GroupId $group.GroupId -DisplayName "dashboard"

<# Pour transformer un membre existant en propriétaire, ajoutez d'abord Add-TeamChannelUser 
-User foo pour les ajouter à la liste des membres, puis ajoutez Add-TeamChannelUser -User foo -Role Owner pour les ajouter à la liste des propriétaires.#>
Add-TeamChannelUser (available in private preview)
   -GroupId <String>
   -DisplayName <String>
   -User <String>
   [-Role <String>]
   [<CommonParameters>]

# exemple Pratique ajoueter un utilisateur, ajouter un canal a une equipe 
Add-TeamUser -GroupId 5deb87cf-a5d9-47bb-a85d-ed453847aed9  -User RomainL@econseils.onmicrosoft.com #-DisplayName "dashboard"
Add-TeamUser -GroupId 5deb87cf-a5d9-47bb-a85d-ed453847aed9 -User omar@econseils.onmicrosoft.com 
New-TeamChannel -GroupId 5deb87cf-a5d9-47bb-a85d-ed453847aed9 -DisplayName "compte rendus" 

# ajouter un utilisateur a une equipe
Add-TeamUser -GroupId 5deb87cf-a5d9-47bb-a85d-ed453847aed9 -User RomainL@econseils.onmicrosoft.com 

# Cette applet de commande vous permet de mettre à jour les propriétés d'une équipe, y compris son nom d'affichage, sa description et ses paramètres spécifiques.

<# Set-Team
   -GroupId <String>
   [-DisplayName <String>]
   [-Description <String>]
   [-MailNickName <String>]
   [-Classification <String>]
   [-Visibility <String>]
   [-AllowGiphy <Boolean>]
   [-GiphyContentRating <String>]
   [-AllowStickersAndMemes <Boolean>]
   [-AllowCustomMemes <Boolean>]
   [-AllowGuestCreateUpdateChannels <Boolean>]
   [-AllowGuestDeleteChannels <Boolean>]
   [-AllowCreateUpdateChannels <Boolean>]
   [-AllowDeleteChannels <Boolean>]
   [-AllowAddRemoveApps <Boolean>]
   [-AllowCreateUpdateRemoveTabs <Boolean>]
   [-AllowCreateUpdateRemoveConnectors <Boolean>]
   [-AllowUserEditMessages <Boolean>]
   [-AllowUserDeleteMessages <Boolean>]
   [-AllowOwnerDeleteMessages <Boolean>]
   [-AllowTeamMentions <Boolean>]
   [-AllowChannelMentions <Boolean>]
   [-ShowInTeamsSearchAndSuggestions <Boolean>]
   [<CommonParameters>]#>

   # exemple change le non d'equipe PowerApps a PowerApps 2 et rendre le Groupe Public alors qu'il etait Privé (Private)
Set-Team -GroupId 2f162b0e-36d2-4e15-8ba3-ba229cecdccf -DisplayName "Updated TeamName" -Visibility Public
Set-Team -GroupId 5deb87cf-a5d9-47bb-a85d-ed453847aed9 -DisplayName "PowerApps 2" -Visibility Public

# Supprimer un utilisateur de canal
<# Remove-TeamChannelUser (available in private preview)
      -GroupId <String>
      -DisplayName <String>
      -User <String>
      [-Role <String>]
      [<CommonParameters>] #>
      
  # exemple suprimer le user OMAR@econseils.onmicrosoft.com du canal ( la commande ne fonctionne pas encor)

Remove-TeamChannelUser -GroupId 5deb87cf-a5d9-47bb-a85d-ed453847aed9 -DisplayName "PowerApps 2" -User OMAR@econseils.onmicrosoft.com

# Supprimer un propriétaire ou un membre d'une équipe et du groupe unifié qui soutient l'équipe.
Remove-TeamUser
      -GroupId <String>
      -User <String>
      [-Role <String>]
      [<CommonParameters>]

# exemple suprimer le user omar
Remove-TeamUser -GroupId 5deb87cf-a5d9-47bb-a85d-ed453847aed9 -User RomainL@econseils.onmicrosoft.com # -Role owner ( role n'est pas encor roconnue comme applet de commande)

#Mettre à jour les paramètres des canaux de l'équipe. changer le nom d'aun canal par exemple
Set-TeamChannel -GroupId 5deb87cf-a5d9-47bb-a85d-ed453847aed9 -CurrentDisplayName dashboard -NewDisplayName "Tableau de bord"

# Paramètres d' invité Set-Team Gues in teams *** necessite une connection a exchange online
    
    #Windows PowerShell ouverte en sélectionnant Exécuter en tant qu’administrateur

# Vous devez configurer ce paramètre une fois seulement sur votre ordinateur, pas à chaque connexion.

Set-ExecutionPolicy RemoteSigned

# Connexion à Exchange Online PowerShell
$UserCredential = Get-Credential

# Nouvelle session exchange : Exécutez la commande suivante.
$Session = New-PSSession -ConfigurationName Microsoft.Exchange -ConnectionUri https://outlook.office365.com/powershell-liveid/ -Credential $UserCredential -Authentication Basic -AllowRedirection
Import-PSSession $Session -DisableNameChecking

# en fin il ne faut pas oublier de fermer la sesion a la fin du travail
Remove-PSSession $Session



 Set-TeamGuestSettings
   -GroupId <String>
   [-AllowCreateUpdateChannels <String>]
   [-AllowDeleteChannels <String>]

# exemple 
Set-TeamGuestSettings -GroupId 5deb87cf-a5d9-47bb-a85d-ed453847aed9 -AllowCreateUpdateChannels true

#Set all Groups/Teams to 'AllowToAddGuests' == $False

$groupID = Get-UnifiedGroup -ResultSize Unlimited | Select-Object -ExpandProperty ExternalDirectoryObjectId
Foreach ($Groups in $GroupID) {
$template = Get-AzureADDirectorySettingTemplate | ? {$_.displayname -eq "group.unified.guest"}
$settingsCopy = $template.CreateDirectorySetting()
$settingsCopy["AllowToAddGuests"]=$False
New-AzureADObjectSetting -TargetType Groups -TargetObjectId $groups -DirectorySetting $settingsCopy
} 

# gerer l'acces guess invité avec powershell 
# https://docs.microsoft.com/fr-fr/office365/admin/create-groups/manage-guest-access-in-groups?view=o365-worldwide

$AllowGuestsToAccessGroups = "True"

$AllowToAddGuests = "True"

Connect-AzureAD

try
    {
        $template = Get-AzureADDirectorySettingTemplate | ? {$_.displayname -eq "group.unified"}
        $settingsCopy = $template.CreateDirectorySetting()
        New-AzureADDirectorySetting -DirectorySetting $settingsCopy
        $settingsObjectID = (Get-AzureADDirectorySetting | Where-object -Property Displayname -Value "Group.Unified" -EQ).id
    }
catch
    {
        $settingsObjectID = (Get-AzureADDirectorySetting | Where-object -Property Displayname -Value "Group.Unified" -EQ).id       
    }

$settingsCopy = Get-AzureADDirectorySetting -Id $settingsObjectID

$settingsCopy["AllowGuestsToAccessGroups"] = $AllowGuestsToAccessGroups

$settingsCopy["AllowToAddGuests"] = $AllowToAddGuests

Set-AzureADDirectorySetting -Id $settingsObjectID -DirectorySetting $settingsCopy

(Get-AzureADDirectorySetting -Id $settingsObjectID).Values