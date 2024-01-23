param(
    [switch]$uninstall
)

# Set execution policy
Set-ExecutionPolicy RemoteSigned -Scope Process -Force

# Define variables
$psProfilePath = $PROFILE

$pythonExecutablePath = (Get-Command python).Source
$pythonScriptPath = (Resolve-Path "$PSScriptRoot\..\filemark.py").Path
$DataBasePath = (Resolve-Path "$PSScriptRoot\..\silver-guide.db").Path

$ps1ScriptPath = "$PSScriptRoot\filemark.ps1"
$scriptContent = @"
# filemark.ps1
`$env:DATABASE_PATH = "$DataBasePath";
& "$pythonExecutablePath" "$pythonScriptPath" `$args;
`$env:DATABASE_PATH = "";
"@

if ($uninstall) {
    # Remove PowerShell alias
    (Get-Content $psProfilePath) -notmatch "Set-Alias filemark" | Set-Content $psProfilePath -Force

    # Remove the Alias from current session
    Remove-Alias -Name filemark -Force
    
    # Delete PowerShell script
    Remove-Item -Path $ps1ScriptPath -Force

    Write-Host "Uninstallation complete. 'filemark' alias and script have been removed from PowerShell."
}
else {
    # Create PowerShell script
    $scriptContent | Set-Content -Path $ps1ScriptPath -Force

    # Add alias in current session
    Set-Alias filemark $ps1ScriptPath -Scope Global -Force;

    # Create PowerShell alias
    Add-Content -Path $psProfilePath -Value "Set-Alias filemark $ps1ScriptPath;"

    Write-Host "Installation complete. You can now use 'filemark' in PowerShell."
}
