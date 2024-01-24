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
`$env:DATABASE_PATH = "$DataBasePath";
`$pythonExecutable = "$pythonExecutablePath";
`$scriptAbsolutePath = "$pythonScriptPath";
`$OUTPUT = (& `$pythonExecutable `$scriptAbsolutePath `$args | Out-String).Trim();
if (`$OUTPUT -match 'FILEMARK OPEN .*'){
    & myenv deactivate;
    Set-Location `$OUTPUT.SubString(14);
    & myenv activate;
} else {
    Write-Host `$OUTPUT;
}
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
