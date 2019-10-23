# Afficher les licences et les services avec Office 365 PowerShell
# Pour afficher des informations récapitulatives sur vos plans de gestion des licences actuels et sur les licences disponibles 
Get-AzureADSubscribedSku | Select -Property Sku*,ConsumedUnits -ExpandProperty PrepaidUnits

# afficher la liste de vos plans de licence.
Get-AzureADSubscribedSku | Select SkuPartNumber

# Ensuite, stockez les informations des plans de licence dans une variable.
$licenses = Get-AzureADSubscribedSku
# Ensuite, affichez les services dans un plan de licence spécifique.
$licenses[<index>].ServicePlans

<#<index> est un entier qui spécifie le numéro de ligne du plan de licence à partir de Get-AzureADSubscribedSku | Select SkuPartNumber l’affichage de la commande, moins 1.
Par exemple, si l’affichage de la Get-AzureADSubscribedSku | Select SkuPartNumber commande est le suivant:#>

Get-AzureADSubscribedSku | Select SkuPartNumber
# Ainsi La commande permettant d’afficher les services pour le plan de licence ENTERPRISEPREMIUM est la suivante:
$licenses[2].ServicePlans #ENTERPRISEPREMIUM est la troisième ligne. Par conséquent, la valeur d’index est (3-1) ou 2. 

# Pour afficher des informations récapitulatives sur vos plans de gestion des licences actuels et sur les licences disponibles pour chaque plan, exécutez la commande suivante:
Get-MsolAccountSku

# Pour afficher ""les détails des services Office 365 disponibles"" dans tous vos plans de licence, exécutez la commande suivante: 
Get-MsolAccountSku | Select -ExpandProperty ServiceStatus

# Pour afficher des détails sur les services Office 365 disponibles dans un plan de gestion de licences spécifique, utilisez la syntaxe suivante.
(Get-MsolAccountSku | where {$_.AccountSkuId -eq "<AccountSkuId>"}).ServiceStatus

# Cet exemple illustre les services Office 365 disponibles dans le plan de gestion des licences econseils: ENTERPRISEPREMIUM (Office 365 Enterprise E5).
(Get-MsolAccountSku | where {$_.AccountSkuId -eq "econseils:ENTERPRISEPREMIUM"}).ServiceStatus

# Pour afficher la liste de tous les comptes users sans licence
Get-AzureAdUser | ForEach{ $licensed=$False ; For ($i=0; $i -le ($_.AssignedLicenses | Measure).Count ; $i++) { If( [string]::IsNullOrEmpty(  $_.AssignedLicenses[$i].disabledplans ) -ne $True) { $licensed=$true } } ; If( $licensed -eq $false) { Write-Host $_.UserPrincipalName} }

# Pour afficher la liste de tous les comptes users sous licence
Get-AzureAdUser | ForEach { $licensed=$False ; For ($i=0; $i -le ($_.AssignedLicenses | Measure).Count ; $i++) { If( [string]::IsNullOrEmpty(  $_.AssignedLicenses[$i].disabledplans ) -ne $True) { $licensed=$true } } ; If( $licensed -eq $true) { Write-Host $_.UserPrincipalName} }

# Pour afficher la liste de tous les comptes d'utilisateurs et leur statut de licence dans votre organisation,
Get-MsolUser -All

# Pour afficher la liste de tous les comptes d’utilisateurs sans licence dans votre organisation,
Get-MsolUser -All -UnlicensedUsersOnly

# Pour afficher la liste de tous les comptes d’utilisateurs avec licence dans votre organisation,
Get-MsolUser -All | where {$_.isLicensed -eq $true}