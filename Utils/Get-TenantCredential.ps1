Add-Type -AssemblyName System.Windows.Forms

function Get-TenantUPN {
    # Determine path to clients.json relative to script location
    $configPath = Join-Path -Path $PSScriptRoot -ChildPath "..\Config\clients.json"

    # Validate config file presence
    if (-not (Test-Path $configPath)) {
        [System.Windows.Forms.MessageBox]::Show("Tenant config file not found at '$configPath'", "Error", 'OK', 'Error')
        return $null
    }

    # Load and parse tenant list
    try {
        $clientData = Get-Content $configPath -Raw | ConvertFrom-Json
        $tenantNames = $clientData.PSObject.Properties.Name
        $tenantOptions = $tenantNames + @("Not listed")
    } catch {
        [System.Windows.Forms.MessageBox]::Show("❌ Failed to parse config file: $($_.Exception.Message)", "Error", 'OK', 'Error')
        return $null
    }

    # GUI Form Setup
    $form = New-Object System.Windows.Forms.Form
    $form.Text = "Select Tenant"
    $form.Width = 300
    $form.Height = 150
    $form.StartPosition = "CenterScreen"

    $comboBox = New-Object System.Windows.Forms.ComboBox
    $comboBox.Width = 250
    $comboBox.Location = New-Object System.Drawing.Point(20, 20)
    $comboBox.DropDownStyle = 'DropDownList'
    $comboBox.Items.AddRange($tenantOptions)
    $form.Controls.Add($comboBox)

    $okButton = New-Object System.Windows.Forms.Button
    $okButton.Text = "OK"
    $okButton.Location = New-Object System.Drawing.Point(100, 60)
    $okButton.Add_Click({ $form.Tag = $comboBox.SelectedItem; $form.Close() })
    $form.Controls.Add($okButton)

    $form.ShowDialog() | Out-Null
    $TenantName = $form.Tag
    if (-not $TenantName) { return }

    # UPN Resolution
    if ($TenantName -eq "Not listed") {
        $adminUPN = Read-Host "Enter the login account (UPN or alias)"
    } else {
        $adminUPN = $clientData.$TenantName.AdminUPN
        Write-Host "Selected tenant: $TenantName"
        Write-Host "Using admin account: $adminUPN"
    }

    return $adminUPN
}