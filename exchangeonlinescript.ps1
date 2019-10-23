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