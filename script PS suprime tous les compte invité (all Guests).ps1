
# ce scripte selectionne tous les compte invité et renvoi la liste dans un fichier csv nomé AzureADGuestUsers_$(Get-Date -f yyyyMMdd_HHmm).csv" -NoTypeInformation a la date du jours

$SelectFilter = @(
    'DisplayName',
    'UserPrincipalName',
    'Mail',
    @{
        name='ToDelete'
        expression={''}            
    }
    'Department',
    'UserType',
    'CreationType',
    'RefreshTokensValidFromDateTime',
    'AccountEnabled',
    @{
        name='Licensed'
        expression={
            if($_.AssignedLicenses){$TRUE}
            else{$False}
        }
    }
    @{
        name='Plan'
        expression={
            if($_.AssignedPlans){$TRUE}
            else{$False}
        }
    }
    'ObjectId' 
)
Get-AzureADUser -Filter "userType eq 'Guest'" -All $true |
    Select-Object $SelectFilter | 
    Export-csv -Path "C:\Users\KamelHadid\Documents\AzureADGuestUsers_$(Get-Date -f yyyyMMdd_HHmm).csv" -NoTypeInformation


    # ********************apres mise a jour du fichier csv en applique le script suivant******************************
    # il affiche la liste dans une fenetre selectionnee les compte a supprimer puis ok

Connect-AzureAD
AzureADGuestUsers_20191023_1436
$ToDeleteGuestUsers = Import-Csv -Path C:\Users\KamelHadid\Documents\AzureADGuestUsers_20191023_1436.csv | Out-GridView -passThru

$ToDeleteGuestUsers | foreach {
    Get-AzureADObjectByObjectId -ObjectIds $_.ObjectID
    Remove-AzureADUser -ObjectId $_.ObjectID -Verbose    
}

# pour verifier executé le comandlette suivante:

get-AzureADUser -Filter "UserType eq 'Guest'" -All $true| Format-Table Displayname, Mail