# Load the tenant helper function
. "$PSScriptRoot\..\Utils\Get-TenantCredential.ps1"
$adminUPN = Get-TenantUPN
if (-not $adminUPN) {
    Write-Host "⚠️ No UPN provided. Script aborted." -ForegroundColor Yellow
    return
}

Connect-ExchangeOnline -UserPrincipalName $adminUPN

$Mailbox = Read-Host "Put in the mailbox the user needs permissions for"
$User = Read-Host "Provide the email address of the user who needs the permission"

Add-MailboxFolderPermission -Identity "${Mailbox}:\Calendar" -User $User -AccessRights "Editor"