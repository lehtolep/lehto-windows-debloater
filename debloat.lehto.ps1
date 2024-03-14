Add-Type -AssemblyName System.Windows.Forms

# define form
$form = New-Object System.Windows.Forms.Form
$form.Text = "Windowsi debloatimine"
$form.Size = New-Object System.Drawing.Size(600,480) # Suurendatud akna suurus
$form.StartPosition = "CenterScreen"
$form.FormBorderStyle = "FixedDialog"
$form.MaximizeBox = $false
$form.MinimizeBox = $false

# label
$label = New-Object System.Windows.Forms.Label
$label.Location = New-Object System.Drawing.Point(10,20)
$label.Size = New-Object System.Drawing.Size(580,20) # Laiem label
$label.Text = "Valige soovitud debloatimise valikud:"
$form.Controls.Add($label)

# check boxes
$checkbox1 = New-Object System.Windows.Forms.CheckBox
$checkbox1.Location = New-Object System.Drawing.Point(20,50)
$checkbox1.Size = New-Object System.Drawing.Size(300,20)
$checkbox1.Text = "Eemalda OneDrive"
$form.Controls.Add($checkbox1)

$checkbox2 = New-Object System.Windows.Forms.CheckBox
$checkbox2.Location = New-Object System.Drawing.Point(20,80)
$checkbox2.Size = New-Object System.Drawing.Size(300,20)
$checkbox2.Text = "Eemalda Edge PDF funktsioon"
$form.Controls.Add($checkbox2)

$checkbox3 = New-Object System.Windows.Forms.CheckBox
$checkbox3.Location = New-Object System.Drawing.Point(20,110)
$checkbox3.Size = New-Object System.Drawing.Size(300,20)
$checkbox3.Text = "Eemalda Cortana" (windows 10 only)
$form.Controls.Add($checkbox3)

$checkbox4 = New-Object System.Windows.Forms.CheckBox
$checkbox4.Location = New-Object System.Drawing.Point(20,140)
$checkbox4.Size = New-Object System.Drawing.Size(300,20)
$checkbox4.Text = "Aktiveeri tumedam teema"
$form.Controls.Add($checkbox4)

# debloat whole system
$checkbox5 = New-Object System.Windows.Forms.CheckBox
$checkbox5.Location = New-Object System.Drawing.Point(20,170)
$checkbox5.Size = New-Object System.Drawing.Size(300,20)
$checkbox5.Text = "Debloati süsteem täielikult"
$form.Controls.Add($checkbox5)

# net frame 3.5 instal
$button1 = New-Object System.Windows.Forms.Button
$button1.Location = New-Object System.Drawing.Point(20,220) # Nupu asukoht muudetud
$button1.Size = New-Object System.Drawing.Size(200,40)
$button1.Text = "Installi .NET Framework 3.5"
$button1.Add_Click({
    # activate .NET Framework 3.5 instal
    Enable-WindowsOptionalFeature -Online -FeatureName "NetFx3" -All -NoRestart
    [System.Windows.Forms.MessageBox]::Show(".NET Framework 3.5 installimine on lõpule viidud!", "Teade")
})
$form.Controls.Add($button1)

# restore debloat
$button2 = New-Object System.Windows.Forms.Button
$button2.Location = New-Object System.Drawing.Point(250,220) # Nupu asukoht muudetud
$button2.Size = New-Object System.Drawing.Size(200,40)
$button2.Text = "Taasta deblokeeritud rakendused"
$button2.Add_Click({
    # Käivita käsk deblokeeritud rakenduste taastamiseks
    Get-AppxPackage -AllUsers | Where-Object {$_.Name -notlike "*WindowsStore*" -and $_.Name -notlike "*Calculator*" -and $_.Name -notlike "*Edge*" -and $_.Name -notlike "*Store*" -and $_.Name -notlike "*ShellExperienceHost*" -and $_.Name -notlike "*Windows.Cortana*" -and $_.Name -notlike "*MicrosoftEdge*" -and $_.Name -notlike "*OneDrive*" -and $_.Name -notlike "*FeedbackHub*"} | Foreach {Add-AppxPackage -DisableDevelopmentMode -Register "$($_.InstallLocation)\AppXManifest.xml"}
    [System.Windows.Forms.MessageBox]::Show("Deblokeeritud rakenduste taastamine on lõpule viidud!", "Teade")
})
$form.Controls.Add($button2)

# apply button
$button3 = New-Object System.Windows.Forms.Button
$button3.Location = New-Object System.Drawing.Point(190,280) # Nupu asukoht muudetud
$button3.Size = New-Object System.Drawing.Size(120,40)
$button3.Text = "Rakenda"
$button3.Add_Click({
    if ($checkbox1.Checked) {
        # Käivita käsk OneDrive eemaldamiseks
        Remove-Item -Path "$env:USERPROFILE\OneDrive" -Force -Recurse -ErrorAction SilentlyContinue
    }
    if ($checkbox2.Checked) {
        # Käivita käsk Edge PDF funktsiooni eemaldamiseks
        Get-AppxPackage Microsoft.MicrosoftEdgePDF | Remove-AppxPackage
    }
    if ($checkbox3.Checked) {
        # Käivita käsk Cortana eemaldamiseks
        Get-AppxPackage Microsoft.549981C3F5F10 | Remove-AppxPackage
    }
    if ($checkbox4.Checked) {
        # Käivita käsk tumedama teema aktiveerimiseks
        New-ItemProperty -Path HKCU:\Software\Microsoft\Windows\CurrentVersion\Themes\Personalize -Name AppsUseLightTheme -Value 0 -PropertyType DWORD -Force | Out-Null
    }
    if ($checkbox5.Checked) {
        # Käivita käsk süsteemi täielikuks deblokeerimiseks
        # Palun olge ettevaatlik, see võib põhjustada tõsiseid tagajärgi!
        # See käsk eemaldab kõik rakendused ja seaded
        Get-AppxPackage | Remove-AppxPackage
        Get-AppxProvisionedPackage -Online | Remove-AppxProvisionedPackage -Online
        Remove-Item "$env:USERPROFILE\OneDrive" -Force -Recurse -ErrorAction SilentlyContinue
        Get-AppxPackage Microsoft.MicrosoftEdgePDF | Remove-AppxPackage
        Get-AppxPackage Microsoft.549981C3F5F10 | Remove-AppxPackage
        Remove-ItemProperty -Path HKCU:\Software\Microsoft\Windows\CurrentVersion\Themes\Personalize -Name AppsUseLightTheme -ErrorAction SilentlyContinue
    }
    [System.Windows.Forms.MessageBox]::Show("Debloatimine on lõpule viidud!", "Teade")
})
$form.Controls.Add($button3)

# restore cortana
$button4 = New-Object System.Windows.Forms.Button
$button4.Location = New-Object System.Drawing.Point(380,50) # Nupu asukoht muudetud
$button4.Size = New-Object System.Drawing.Size(200,30)
$button4.Text = "Taasta Cortana"
$button4.Add_Click({
    # Käivita käsk Cortana taastamiseks
    Add-AppxPackage -Register "C:\Program Files\WindowsApps\Microsoft.549981C3F5F10_2.2101.36221.0_x64__8wekyb3d8bbwe\AppxManifest.xml" -DisableDevelopmentMode
    [System.Windows.Forms.MessageBox]::Show("Cortana taastamine on lõpule viidud!", "Teade")
})
$form.Controls.Add($button4)

# restore edge pdf
$button5 = New-Object System.Windows.Forms.Button
$button5.Location = New-Object System.Drawing.Point(380,90) # Nupu asukoht muudetud
$button5.Size = New-Object System.Drawing.Size(200,30)
$button5.Text = "Taasta Edge PDF"
$button5.Add_Click({
    # Käivita käsk Edge PDF taastamiseks
    Add-AppxPackage -Register "C:\Program Files\WindowsApps\Microsoft.MicrosoftEdgePDF_18.17763.0.0_neutral__8wekyb3d8bbwe\AppxManifest.xml" -DisableDevelopmentMode
    [System.Windows.Forms.MessageBox]::Show("Edge PDF taastamine on lõpule viidud!", "Teade")
})
$form.Controls.Add($button5)

# restore onedrive
$button6 = New-Object System.Windows.Forms.Button
$button6.Location = New-Object System.Drawing.Point(380,130) # Nupu asukoht muudetud
$button6.Size = New-Object System.Drawing.Size(200,30)
$button6.Text = "Taasta OneDrive"
$button6.Add_Click({
    # Käivita käsk OneDrive taastamiseks
    Start-Process "explorer.exe" "C:\Users\$env:UserName\OneDrive"
    [System.Windows.Forms.MessageBox]::Show("OneDrive taastamine on lõpule viidud!", "Teade")
})
$form.Controls.Add($button6)

# open form
$form.ShowDialog() | Out-Null
