param(
    [Parameter(Mandatory = $true)]
    [string]$Version,

    [string]$PackagesDir = "",

    [Parameter(Mandatory = $true)]
    [string]$InstallerPath = ""
)

$ErrorActionPreference = "Stop"

$repo = "msilva2003-cloud/mskpdfeditor-deploy"
$tag = "v$Version"
$RepoRoot = Split-Path -Parent $PSScriptRoot

if ([string]::IsNullOrWhiteSpace($PackagesDir)) {
    $PackagesDir = Join-Path $RepoRoot "packages"
}

$zipPath = Join-Path $PackagesDir "MSK_PDF_Pro_Update_v$Version.zip"
$manifestPath = Join-Path $RepoRoot "release-manifests\update.json"

if (-not (Get-Command gh -ErrorAction SilentlyContinue)) {
    throw "GitHub CLI nao encontrado. Instale o gh ou publique manualmente."
}

if (-not (Test-Path -Path $zipPath)) {
    throw "Pacote de update nao encontrado: $zipPath"
}

if (-not (Test-Path -Path $InstallerPath)) {
    throw "Instalador nao encontrado: $InstallerPath"
}

if (-not (Test-Path -Path $manifestPath)) {
    throw "Manifesto nao encontrado: $manifestPath"
}

gh release create $tag `
    --repo $repo `
    --title "MSK PDF Pro $Version" `
    --notes "Release publica de deploy do MSK PDF Pro $Version." `
    $zipPath `
    $InstallerPath `
    $manifestPath

Write-Host "Release publicada: $repo $tag"
