#Pour exiger que tous les scripts PowerShell téléchargés sur Internet soient signés par un éditeur approuvé, exécutez la commande suivante
 Set-ExecutionPolicy RemoteSigned

 # Connectez-vous à Exchange Online
$UserCredential = Get-Credential

 # Ouvrir une nouvelle session 
$Session = New-PSSession -ConfigurationName Microsoft.Exchange -ConnectionUri https://outlook.office365.com/powershell-liveid/ -Credential $UserCredential -Authentication Basic -AllowRedirection

# importer la session 
Import-PSSession $Session -DisableNameChecking

# en fin pour fermer la session a la fin du travail toujour
# Remove-PSSession $Session

# Pour verifier que vous etes bien connecté ( voir les boites mail)
Get-Mailbox

#
#####