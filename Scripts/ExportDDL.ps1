# Load the tenant helper function
. "$PSScriptRoot\..\Utils\Get-TenantCredential.ps1"
$adminUPN = Get-TenantUPN
if (-not $adminUPN) {
    Write-Host "⚠️ No UPN provided. Script aborted." -ForegroundColor Yellow
    return
}

Connect-ExchangeOnline -UserPrincipalName $adminUPN

$dynamicDL = Read-Host "Please enter the Dynamic Distribution List email address"

try {
    $ddlGroup = Get-DynamicDistributionGroup -Identity $dynamicDL
    $members = Get-Recipient -RecipientPreviewFilter $ddlGroup.RecipientFilter

    # Export members to CSV
    $exportPath = "C:\temp\allusers.csv"
    $members | Select-Object DisplayName, PrimarySmtpAddress | Export-Csv -Path $exportPath -NoTypeInformation
    Write-Host "✅ Export complete: $exportPath" -ForegroundColor Green
} catch {
    Write-Host "❌ Error retrieving members or exporting: $_" -ForegroundColor Red
}