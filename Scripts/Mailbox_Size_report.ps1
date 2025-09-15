# Load the tenant helper function
. "$PSScriptRoot\..\Utils\Get-TenantCredential.ps1"
$adminUPN = Get-TenantUPN
if (-not $adminUPN) {
    Write-Host "⚠️ No UPN provided. Script aborted." -ForegroundColor Yellow
    return
}

Connect-ExchangeOnline -UserPrincipalName $adminUPN

$csvPath = "C:\Temp\MailboxFolderSizes.csv"
$Mailbox = Read-Host "Put in the mailbox you want the report for"
 
Get-MailboxFolderStatistics $Mailbox -FolderScope Inbox | Select-Object Name,FolderandSubFolderSize,ItemsinFolderandSubfolders | Export-Csv $csvPath -NoTypeInformation
 
Write-Host "Export complete. CSV saved to $csvPath"

 