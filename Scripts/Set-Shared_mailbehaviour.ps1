# Load the tenant helper function
. "$PSScriptRoot\..\Utils\Get-TenantCredential.ps1"
$adminUPN = Get-TenantUPN
if (-not $adminUPN) {
    Write-Host "⚠️ No UPN provided. Script aborted." -ForegroundColor Yellow
    return
}

Connect-ExchangeOnline -UserPrincipalName $adminUPN

$Mailbox = Read-Host "Please enter the mailbox email address"

Set-Mailbox $Mailbox -MessageCopyForSendOnBehalfEnabled $true