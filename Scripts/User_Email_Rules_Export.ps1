# Load the tenant helper function
. "$PSScriptRoot\..\Utils\Get-TenantCredential.ps1"
$adminUPN = Get-TenantUPN
if (-not $adminUPN) {
    Write-Host "⚠️ No UPN provided. Script aborted." -ForegroundColor Yellow
    return
}
Connect-ExchangeOnline 

# Create an empty list to store rule information
$ruleList = @()

# Get User UPN
$mailbox = Read-HostGet-Mailbox -ResultSize Unlimited

$rules = Get-InboxRule -Mailbox $Mailbox

# Build rule info list
$ruleList = foreach ($rule in $rules) {
    [PSCustomObject]@{
        MailboxOwnerID = $Mailbox
        RuleName       = $rule.Name
        Description    = $rule.Description
        Enabled        = $rule.Enabled
        MoveToFolder   = $rule.MoveToFolder
        ForwardTo      = $rule.ForwardTo
        RedirectTo     = $rule.RedirectTo
    }
}

# Export the list to a CSV file
$ruleList | Export-CSV -Path "C:\temp\RulesOutput.csv" -NoTypeInformation
