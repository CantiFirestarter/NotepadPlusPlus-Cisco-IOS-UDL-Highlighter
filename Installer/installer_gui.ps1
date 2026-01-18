Param(
    [switch]$elevated
)

Add-Type -AssemblyName System.Windows.Forms
Add-Type -AssemblyName System.Drawing

$scriptDir = if ($PSScriptRoot) {
    $PSScriptRoot
} elseif ($PSCommandPath) {
    Split-Path -Parent $PSCommandPath
} else {
    try { Split-Path -Parent $MyInvocation.MyCommand.Definition } catch { Split-Path -Parent $MyInvocation.MyCommand.Path }
}
$repoRoot = Join-Path $scriptDir '..'

function Backup-IfExists($path) {
    if (Test-Path $path) {
        $ts = Get-Date -Format yyyyMMdd_HHmmss
        $bak = "$path.$ts.bak"
        try { Move-Item -LiteralPath $path -Destination $bak -Force } catch { }
    }
}

function Install-All {
    param(
        [bool]$DoUDL = $true,
        [bool]$DoEAL = $true,
        [bool]$DoAuto = $false
    )
    $results = New-Object System.Collections.ArrayList

    if ($DoUDL) {
        $udlSrc = Join-Path $repoRoot 'Cisco_IOS_Redux.xml'
        $udlDstDir = Join-Path $env:APPDATA 'Notepad++\userDefineLangs'
        if (-not (Test-Path $udlDstDir)) { New-Item -ItemType Directory -Path $udlDstDir -Force | Out-Null }
        $udlDst = Join-Path $udlDstDir 'Cisco_IOS_Redux.xml'
        Backup-IfExists $udlDst
        Copy-Item -LiteralPath $udlSrc -Destination $udlDst -Force
        $results.Add("UDL installed to $udlDst") | Out-Null
    } else {
        $results.Add('UDL: skipped') | Out-Null
    }

    if ($DoEAL) {
        $ealSrc = Join-Path $repoRoot 'EnhanceAnyLexer'
        if (Test-Path $ealSrc) {
            $ealDst = Join-Path $env:APPDATA 'Notepad++\plugins\config\EnhanceAnyLexer'
            if (Test-Path $ealDst) { Backup-IfExists $ealDst }
            if (-not (Test-Path $ealDst)) { New-Item -ItemType Directory -Path $ealDst -Force | Out-Null }
            Copy-Item -Path (Join-Path $ealSrc '*') -Destination $ealDst -Recurse -Force
            $results.Add("EnhanceAnyLexer installed to $ealDst") | Out-Null
        } else {
            $results.Add('EnhanceAnyLexer source not found (skipped)') | Out-Null
        }
    } else {
        $results.Add('EnhanceAnyLexer: skipped') | Out-Null
    }

    if ($DoAuto) {
        $acSrc = Join-Path $repoRoot 'autoCompletion\Cisco IOS Redux.xml'
        if (Test-Path $acSrc) {
            if ($elevated -or (Test-Path HKLM:\SOFTWARE)) {
                $pf = $env:ProgramFiles
                if (-not $pf) { $pf = 'C:\Program Files' }
                $acDstDir = Join-Path $pf 'Notepad++\autoCompletion'
                if (-not (Test-Path $acDstDir)) { New-Item -ItemType Directory -Path $acDstDir -Force | Out-Null }
                $acDst = Join-Path $acDstDir 'Cisco IOS Redux.xml'
                Backup-IfExists $acDst
                try {
                    Copy-Item -LiteralPath $acSrc -Destination $acDst -Force
                    $results.Add("Auto-completion installed to $acDst") | Out-Null
                } catch {
                    $results.Add("Auto-completion failed: $_") | Out-Null
                }
            } else {
                $results.Add('Auto-completion skipped - not running elevated') | Out-Null
            }
        } else {
            $results.Add('Auto-completion source not found (skipped)') | Out-Null
        }
    } else {
        $results.Add('Auto-completion: skipped') | Out-Null
    }

    return $results
}

# Build UI
$form = New-Object System.Windows.Forms.Form
$form.Text = 'Notepad++ Cisco IOS UDL Installer'
$form.Font = New-Object System.Drawing.Font('Segoe UI',9)
$form.AutoScaleMode = 'Dpi'
$form.ClientSize = New-Object System.Drawing.Size(620,450)
$form.MinimumSize = New-Object System.Drawing.Size(620,450)
$form.StartPosition = 'CenterScreen'

$lbl = New-Object System.Windows.Forms.Label
$lbl.Text = "Select components to install:" 
$lbl.AutoSize = $true
$lbl.Location = New-Object System.Drawing.Point(10,10)
$form.Controls.Add($lbl)

$chkUDL = New-Object System.Windows.Forms.CheckBox
$chkUDL.Text = 'Install UDL (Cisco_IOS_Redux.xml)'
$chkUDL.Checked = $true
$chkUDL.Location = New-Object System.Drawing.Point(10,40)
$chkUDL.AutoSize = $true
$form.Controls.Add($chkUDL)

$chkEAL = New-Object System.Windows.Forms.CheckBox
$chkEAL.Text = 'Install EnhanceAnyLexer config'
$chkEAL.Checked = $true
$chkEAL.Location = New-Object System.Drawing.Point(10,70)
$chkEAL.AutoSize = $true
$form.Controls.Add($chkEAL)

$chkAuto = New-Object System.Windows.Forms.CheckBox
$chkAuto.Text = 'Install auto-completion (requires admin)'
$chkAuto.Checked = $true
$chkAuto.Location = New-Object System.Drawing.Point(10,100)
$chkAuto.AutoSize = $true
$form.Controls.Add($chkAuto)

$note = New-Object System.Windows.Forms.Label
$note.Text = 'If you choose to install auto-completion, use Run as Admin to grant administrator rights.'
$note.AutoSize = $true
$note.Location = New-Object System.Drawing.Point(10,130)
$form.Controls.Add($note)

$chkClose = New-Object System.Windows.Forms.CheckBox
$chkClose.Text = 'Close installer when finished'
$chkClose.Checked = $true
$chkClose.Location = New-Object System.Drawing.Point(10,155)
$chkClose.AutoSize = $true
$form.Controls.Add($chkClose)

$txtResult = New-Object System.Windows.Forms.TextBox
$txtResult.Multiline = $true
$txtResult.ScrollBars = 'Vertical'
$txtResult.ReadOnly = $true
$txtResult.Size = New-Object System.Drawing.Size(600,220)
$txtResult.Location = New-Object System.Drawing.Point(10,185)
$txtResult.Anchor = [System.Windows.Forms.AnchorStyles]::Top -bor [System.Windows.Forms.AnchorStyles]::Left -bor [System.Windows.Forms.AnchorStyles]::Right -bor [System.Windows.Forms.AnchorStyles]::Bottom
$form.Controls.Add($txtResult)

$btnInstall = New-Object System.Windows.Forms.Button
$btnInstall.Text = 'Install'
$btnInstall.Location = New-Object System.Drawing.Point(360,410)
$btnInstall.Size = New-Object System.Drawing.Size(110,36)
$btnInstall.Anchor = [System.Windows.Forms.AnchorStyles]::Bottom -bor [System.Windows.Forms.AnchorStyles]::Right
$btnInstall.Add_Click({
    # Disable controls while running
    $btnInstall.Enabled = $false
    $btnElev.Enabled = $false
    $chkUDL.Enabled = $false
    $chkEAL.Enabled = $false
    $chkAuto.Enabled = $false
    $chkClose.Enabled = $false
    $txtResult.Text = 'Running...'

    $doUDL = $chkUDL.Checked
    $doEAL = $chkEAL.Checked
    $doAuto = $chkAuto.Checked

    $out = Install-All -DoUDL:$doUDL -DoEAL:$doEAL -DoAuto:$doAuto
    $txtResult.Text = ($out -join "`r`n")

    # Finish state
    $btnInstall.Text = 'Finished'
    $btnInstall.Enabled = $false
    $btnClose.Enabled = $true
    $btnElev.Enabled = $true

    if ($chkClose.Checked) { Start-Sleep -Seconds 1; $form.Close() }
})
$form.Controls.Add($btnInstall)

$btnElev = New-Object System.Windows.Forms.Button
$btnElev.Text = 'Run as Admin'
$btnElev.Location = New-Object System.Drawing.Point(240,410)
$btnElev.Size = New-Object System.Drawing.Size(110,36)
$btnElev.Anchor = [System.Windows.Forms.AnchorStyles]::Bottom -bor [System.Windows.Forms.AnchorStyles]::Right
$btnElev.Add_Click({
    $psi = New-Object System.Diagnostics.ProcessStartInfo
    # If running as a .ps1 script, relaunch PowerShell with the script file. If running as a packaged EXE, relaunch the EXE elevated.
    if ($PSCommandPath -and (Test-Path $PSCommandPath) -and ($PSCommandPath.ToLower().EndsWith('.ps1'))) {
        $psi.FileName = 'powershell'
        $psi.Arguments = "-NoProfile -ExecutionPolicy Bypass -File `"$PSCommandPath`" -elevated"
    } else {
        $exePath = [System.Diagnostics.Process]::GetCurrentProcess().MainModule.FileName
        $psi.FileName = $exePath
        $psi.Arguments = '-elevated'
    }
    $psi.Verb = 'runas'
    try { [System.Diagnostics.Process]::Start($psi) | Out-Null; $form.Close() } catch { [System.Windows.Forms.MessageBox]::Show('Elevation cancelled or failed.') }
})
$form.Controls.Add($btnElev)

$btnClose = New-Object System.Windows.Forms.Button
$btnClose.Text = 'Close'
$btnClose.Location = New-Object System.Drawing.Point(480,410)
$btnClose.Size = New-Object System.Drawing.Size(110,36)
$btnClose.Enabled = $true
$btnClose.Anchor = [System.Windows.Forms.AnchorStyles]::Bottom -bor [System.Windows.Forms.AnchorStyles]::Right
$btnClose.Add_Click({ $form.Close() })
$form.Controls.Add($btnClose)

[void]$form.ShowDialog()
