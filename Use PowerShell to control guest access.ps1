<# Use PowerShell to control guest access

Install the preview version of the Azure Active Directory PowerShell for Graph
These procedures require the preview version of the Azure Active Directory PowerShell for Graph. The GA version will not work.

 Important: you cannot install both the preview and GA versions on the same computer at the same time.#>

Get-InstalledModule -Name "AzureAD*"
Uninstall-Module AzureADPreview
Uninstall-Module AzureAD
Install-Module AzureADPreview

<# onfigure guest Access
Copy the script below into a text editor, such as Notepad, or the Windows PowerShell ISE.

Update the script as follows:

To let group members outside the organization access group content, set $AllowGuestsToAccessGroups = "True", otherwise set $AllowGuestsToAccessGroups = "False".

To let group owners add people outside the organization to groups, set $AllowToAddGuests = "True", otherwise, set $AllowToAddGuests = "False".

Save the file as ExternalGroupAccess.ps1.

In the PowerShell window, navigate to the location where you saved the file (type "CD ").

Run the script by typing:

.\ExternalGroupAccess.ps1

and sign in with your administrator account when prompted.#>

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


# chercher les utilisateur invité "guess' 
Get-AzureADUser -Filter "UserType eq 'Guest'" -All $true| Format-Table Displayname, Mail

# Vérification des invités indésirables

$Groups = (Get-UnifiedGroup -Filter {GroupExternalMemberCount -gt 0} -ResultSize Unlimited | Select Alias, DisplayName)
 
ForEach ($G in $Groups)
{ $Ext = Get-UnifiedGroupLinks -Identity $G.Alias -LinkType Members
ForEach ($E in $Ext) {
    If ($E.Name -Match "#EXT#")
        { Write-Host "Group " $G.DisplayName "includes guest user" $E.Name }
    }
}

#  Supprimer les invités indésirables
$Users = (Get-AzureADUser -Filter "UserType eq 'Guest'" -All $True| Select DisplayName, ObjectId)
ForEach ($U in $Users)
{ If ($U.UserPrincipalName -Like "*Unwanted.com*") {
   Write-Host "Removing"$U.DisplayName
   Remove-AzureADUser -ObjectId $U.ObjectId }
}

#************* #ajouter un guest 'invité' avec une commande powerShell*******************
Connect-AzureAD # avec le compte admin exemple kamel@econseils.onmicrosoft.com
New-AzureADMSInvitation -InvitedUserDisplayName "kamel" -InvitedUserEmailAddress kamel_hadid2001@yahoo.fr -InviteRedirectURL https://myapps.azure.com -SendInvitationMessage $true


# Vérifier que l’utilisateur invité  se trouve dans l’annuaire
Get-AzureADUser -Filter "UserType eq 'Guest'"

# vous pouvez supprimer le compte d’utilisateur de test de l’annuaire
Remove-AzureADUser -ObjectId "<UPN>"
Remove-AzureADUser -ObjectId "kamel_hadid2001_yahoo.fr#EXT#@econseils.onmicrosoft.com" # Par exemple : 

New-AzureADMSInvitation 

# Ajouter un invité (guest) : ****************************************
New-AzureADMSInvitation -InvitedUserDisplayName "kamel" -InvitedUserEmailAddress kamel_hadid2001@yahoo.fr -InviteRedirectURL https://myapps.azure.com -SendInvitationMessage $true




# ajouter des invité a partir d'un fichier csv (guest)***************************************

get-AzureADUser -Filter "UserType eq 'Guest'" -All $true| Format-Table Displayname, Mail

# IMPORTANT bien nommé les colones et verifier toujour la syntax et les parametres quelle accept 

$invitations = import-csv C:\Users\KamelHadid\Documents\UserInviteTemplate1.csv
$messageInfo = New-Object Microsoft.Open.MSGraph.Model.InvitedUserMessageInfo
$messageInfo.customizedMessageBody = "Hey there! Check this out. I created an invitation through PowerShell"
foreach ($email in $invitations) {New-AzureADMSInvitation -InvitedUserEmailAddress $email.email -InviteRedirectUrl $email.url -SendInvitationMessage $email.true -Verbose} 


