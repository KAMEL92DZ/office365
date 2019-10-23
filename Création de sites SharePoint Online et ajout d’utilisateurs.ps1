# Étape 1 : Création de collections de sites 
#Créer un fichier CSV
#Ouvrez le Bloc-notes et collez-y le bloc de texte suivant :
#Créer un fichier CSV
#Ouvrez le Bloc-notes et collez-y le bloc de texte suivant sur notpad ++
# dans ce cas j'ai enregistrez le fichier sur votre bureau en tant que SiteCollections. csv
# puis Exécuter la commande Windows PowerShell le chemain vers le fichier dans mes document C:\Users\KamelHadid\Documents
Import-Csv C:\Users\KamelHadid\Documents\SiteCollections.csv | ForEach-Object {New-SPOSite -Owner $_.Owner -StorageQuota $_.StorageQuota -Url $_.Url -NoWait -ResourceQuota $_.ResourceQuota -Template $_.Template -TimeZoneID $_.TimeZoneID -Title $_.Name}
# pour verifier que les site on ete cree saisir la comandelette
Get-SPOSite -Detailed | Format-Table -AutoSize

# Étape 2 : Ajout d’utilisateurs et de groupes, Créer des fichiers 
# des groupes
<#Site,Group,PermissionLevels
https://tenant.sharepoint.com/sites/contosotest,Contoso Project Leads,Full Control
https://tenant.sharepoint.com/sites/contosotest,Contoso Auditors,View Only
https://tenant.sharepoint.com/sites/contosotest,Contoso Designers,Design
https://tenant.sharepoint.com/sites/TeamSite01,XT1000 Team Leads,Full Control
https://tenant.sharepoint.com/sites/TeamSite01,XT1000 Advisors,Edit
https://tenant.sharepoint.com/sites/Blog01,Contoso Blog Designers,Design
https://tenant.sharepoint.com/sites/Blog01,Contoso Blog Editors,Edit
https://tenant.sharepoint.com/sites/Project01,Project Alpha Approvers,Full Control#>

# nouveau utilisateurs et enregister le fichier csv au non de  users.csv  
<#Group,LoginName,Site
Contoso Project Leads,username@tenant.onmicrosoft.com,https://tenant.sharepoint.com/sites/contosotest
Contoso Auditors,username@tenant.onmicrosoft.com,https://tenant.sharepoint.com/sites/contosotest
Contoso Designers,username@tenant.onmicrosoft.com,https://tenant.sharepoint.com/sites/contosotest
XT1000 Team Leads,username@tenant.onmicrosoft.com,https://tenant.sharepoint.com/sites/TeamSite01
XT1000 Advisors,username@tenant.onmicrosoft.com,https://tenant.sharepoint.com/sites/TeamSite01
Contoso Blog Designers,username@tenant.onmicrosoft.com,https://tenant.sharepoint.com/sites/Blog01
Contoso Blog Editors,username@tenant.onmicrosoft.com,https://tenant.sharepoint.com/sites/Blog01
Project Alpha Approvers,username@tenant.onmicrosoft.com,https://tenant.sharepoint.com/sites/Project01 #>

# enregistrer dans le bloc note sous ps1  "UsersAndGroups.ps1"
Import-Csv C:\Users\KamelHadid\Documents\GroupsAndPermissions.csv | ForEach-Object {New-SPOSiteGroup -Group $_.Group -PermissionLevels $_.PermissionLevels -Site $_.Site}
Import-Csv C:\Users\KamelHadid\Documents\Users.csv | where {Add-SPOUser -Group $_.Group –LoginName $_.LoginName -Site $_.Site} #>

#
Set-ExecutionPolicy Bypass

c:\users\kamel\desktop\UsersAndGroups.ps1