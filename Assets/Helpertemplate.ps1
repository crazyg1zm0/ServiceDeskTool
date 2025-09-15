function Get-TenantCredential {
    param (
        [string]$TenantName
    )

    $configPath = Join-Path -Path $PSScriptRoot -Parent | Join-Path -ChildPath "Config\clients.json"
    $clientData = Get-Content $configPath | ConvertFrom-Json

    if (-not $clientData.$TenantName) {
        Write-Error "Tenant '$TenantName' not found in config"
        return $null
    }

    $adminUPN = $clientData.$TenantName.AdminUPN
    $securePassword = Read-Host "Enter password for $adminUPN" -AsSecureString
    return New-Object System.Management.Automation.PSCredential ($adminUPN, $securePassword)
}