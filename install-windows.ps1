# ============================================================
#  Northern Forest — Windows Installer
#  Installs Starship config, PowerShell profile,
#  and Windows Terminal color scheme with automatic backup.
# ============================================================

#Requires -Version 5.1

param(
    [switch]$SkipDependencies
)

$ErrorActionPreference = "Stop"
$BackupDir = "$HOME\.northern-forest-backup\$(Get-Date -Format 'yyyyMMdd-HHmmss')"
$RepoDir = Split-Path -Parent $MyInvocation.MyCommand.Path

function Write-Step { param([string]$Step, [string]$Msg) Write-Host "[$Step] $Msg" -ForegroundColor Cyan }
function Write-Ok   { param([string]$Msg) Write-Host "  $Msg" -ForegroundColor Green }
function Write-Warn { param([string]$Msg) Write-Host "  $Msg" -ForegroundColor Yellow }

function Backup-File {
    param([string]$Path)
    if (Test-Path $Path) {
        New-Item -ItemType Directory -Force -Path $BackupDir | Out-Null
        $name = Split-Path $Path -Leaf
        Copy-Item $Path "$BackupDir\$name"
        Write-Warn "Backed up $Path"
    }
}

# ---- Execution policy ----
$policy = Get-ExecutionPolicy -Scope CurrentUser
if ($policy -eq "Restricted" -or $policy -eq "AllSigned") {
    Write-Step "0/4" "Setting execution policy to RemoteSigned"
    Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser -Force
    Write-Ok "Execution policy set"
}

# ---- Dependencies ----
if (-not $SkipDependencies) {
    Write-Step "1/4" "Checking dependencies"

    # winget availability
    if (Get-Command winget -ErrorAction SilentlyContinue) {
        # Starship
        if (-not (Get-Command starship -ErrorAction SilentlyContinue)) {
            Write-Warn "Installing Starship..."
            winget install --id Starship.Starship --accept-source-agreements --accept-package-agreements
        } else { Write-Ok "Starship already installed" }

        # Fastfetch
        if (-not (Get-Command fastfetch -ErrorAction SilentlyContinue)) {
            Write-Warn "Installing Fastfetch..."
            winget install --id Fastfetch-cli.Fastfetch --accept-source-agreements --accept-package-agreements
        } else { Write-Ok "Fastfetch already installed" }

        # Nerd Font
        $fontInstalled = Get-ItemProperty "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Fonts" -ErrorAction SilentlyContinue |
            Get-Member -MemberType NoteProperty |
            Where-Object { $_.Name -match "JetBrainsMono.*Nerd" }
        if (-not $fontInstalled) {
            Write-Warn "Installing JetBrainsMono Nerd Font..."
            winget install --id DEVCOM.JetBrainsMonoNerdFont --accept-source-agreements --accept-package-agreements
        } else { Write-Ok "JetBrainsMono Nerd Font already installed" }
    } else {
        Write-Warn "winget not found — install dependencies manually:"
        Write-Warn "  winget install Starship.Starship"
        Write-Warn "  winget install Fastfetch-cli.Fastfetch"
        Write-Warn "  winget install DEVCOM.JetBrainsMonoNerdFont"
    }

    # PSReadLine (bundled with PS7, may need install on PS5)
    if (-not (Get-Module -ListAvailable -Name PSReadLine)) {
        Write-Warn "Installing PSReadLine..."
        Install-Module -Name PSReadLine -Force -SkipPublisherCheck
    } else { Write-Ok "PSReadLine available" }

    # Terminal-Icons
    if (-not (Get-Module -ListAvailable -Name Terminal-Icons)) {
        Write-Warn "Installing Terminal-Icons..."
        Install-Module -Name Terminal-Icons -Repository PSGallery -Force
    } else { Write-Ok "Terminal-Icons available" }
} else {
    Write-Step "1/4" "Skipping dependency install (-SkipDependencies)"
}

# ---- Starship config ----
Write-Step "2/4" "Starship config"
$starshipDest = "$HOME\.config\starship.toml"
Backup-File $starshipDest
New-Item -ItemType Directory -Force -Path "$HOME\.config" | Out-Null
Copy-Item "$RepoDir\starship\starship.toml" $starshipDest -Force
Write-Ok "Installed starship.toml"

# ---- PowerShell profile ----
Write-Step "3/4" "PowerShell profile"
Backup-File $PROFILE
$profileDir = Split-Path $PROFILE -Parent
if (-not (Test-Path $profileDir)) {
    New-Item -ItemType Directory -Force -Path $profileDir | Out-Null
}
Copy-Item "$RepoDir\powershell\Microsoft.PowerShell_profile.ps1" $PROFILE -Force
Write-Ok "Installed PowerShell profile -> $PROFILE"

# ---- Windows Terminal color scheme ----
Write-Step "4/4" "Windows Terminal color scheme"
$wtSettingsPath = "$ENV:LOCALAPPDATA\Packages\Microsoft.WindowsTerminal_8wekyb3d8bbwe\LocalState\settings.json"

if (Test-Path $wtSettingsPath) {
    Backup-File $wtSettingsPath

    $settings = Get-Content $wtSettingsPath -Raw | ConvertFrom-Json
    $scheme = Get-Content "$RepoDir\windows-terminal\northern-forest.json" -Raw | ConvertFrom-Json

    # Add or replace the scheme
    if (-not $settings.schemes) {
        $settings | Add-Member -NotePropertyName "schemes" -NotePropertyValue @()
    }
    $settings.schemes = @($settings.schemes | Where-Object { $_.name -ne "Northern Forest" }) + $scheme

    # Set as default color scheme
    if (-not $settings.profiles.defaults) {
        $settings.profiles | Add-Member -NotePropertyName "defaults" -NotePropertyValue @{}
    }
    $settings.profiles.defaults | Add-Member -NotePropertyName "colorScheme" -NotePropertyValue "Northern Forest" -Force
    $settings.profiles.defaults | Add-Member -NotePropertyName "font" -NotePropertyValue @{ face = "JetBrainsMono Nerd Font"; size = 13 } -Force
    $settings.profiles.defaults | Add-Member -NotePropertyName "opacity" -NotePropertyValue 90 -Force
    $settings.profiles.defaults | Add-Member -NotePropertyName "useAcrylic" -NotePropertyValue $true -Force

    $settings | ConvertTo-Json -Depth 10 | Set-Content $wtSettingsPath -Encoding UTF8
    Write-Ok "Injected Northern Forest scheme into Windows Terminal"
    Write-Ok "Set as default color scheme with JetBrainsMono Nerd Font"
} else {
    Write-Warn "Windows Terminal settings.json not found"
    Write-Warn "Manually add the scheme from windows-terminal/northern-forest.json"
}

# ---- Done ----
Write-Host ""
if (Test-Path $BackupDir) {
    Write-Host "Backups saved to: $BackupDir" -ForegroundColor Yellow
}
Write-Host "Done! Restart your terminal to see Northern Forest." -ForegroundColor Green
Write-Host ""
Write-Host "If the font doesn't render icons, ensure JetBrainsMono Nerd Font is installed:" -ForegroundColor DarkGray
Write-Host "  winget install DEVCOM.JetBrainsMonoNerdFont" -ForegroundColor DarkGray
