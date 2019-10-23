connection a sharpoint Online

$adminUPN="kamel@econseils.onmicrosoft.com"
$orgName="econseils"
$userCredential = Get-Credential -UserName $adminUPN -Message "Type the password."
Connect-SPOService -Url https://$orgName-admin.sharepoint.com -Credential $userCredential

# pour connetre le nom de template site sharpoint disponible execuet la cmdlette 
Get-SPOWebTemplate
# cree un fichier csv 
<#Owner,StorageQuota,Url,ResourceQuota,Template,TimeZoneID,Name
kamel@econseils.onmicrosoft.com,100,https://econseils.sharepoint.com/sites/modernworkplace,25,EHS#1,10,modern work place Team Site
kamel@econseils.onmicrosoft.com,100,https://econseils.sharepoint.com/sites/blogue,25,BLOG#0,10,modern work place
kamel@econseils.onmicrosoft.com,150,https://econseils.sharepoint.com/sites/Project_migration,25,PROJECTSITE#0,10,Project Alpha
kamel@econseils.onmicrosoft.com,150,https://econseils.sharepoint.com/sites/equipe,25,COMMUNITY#0,10,equipe Site
#>

# une fois le fichier csv cree executé ce script

Import-Csv C:\Users\KamelHadid\Documents\sitecollection3.csv | ForEach-Object {New-SPOSite -Owner $_.Owner -StorageQuota $_.StorageQuota -Url $_.Url -NoWait -ResourceQuota $_.ResourceQuota -Template $_.Template -TimeZoneID $_.TimeZoneID -Title $_.Name}

# pour veriffier la collection de site du tenant executer la cmdlette
Get-SPOSite -Detailed | Format-Table -AutoSize

# Étape 2 : Ajout d’utilisateurs et de groupes

Import-Csv C:\Users\KamelHadid\Documents\GroupsAndPermissions.csv | ForEach-Object {New-SPOSiteGroup -Group $_.Group -PermissionLevels $_.PermissionLevels -Site $_.Site}
Import-Csv C:\Users\KamelHadid\Documents\Users.csv | where {Add-SPOUser -Group $_.Group –LoginName $_.LoginName -Site $_.Site}

C:\Users\KamelHadid\Documents\UsersAndGroups.ps1