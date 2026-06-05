param(
    [Parameter(Mandatory = $true)]
    [string]$Version,

    [Parameter(Mandatory = $true)]
    [string]$SourceDist,

    [string]$OutputDir = ""
)

$ErrorActionPreference = "Stop"
$RepoRoot = Split-Path -Parent $PSScriptRoot

if ([string]::IsNullOrWhiteSpace($OutputDir)) {
    $OutputDir = Join-Path $RepoRoot "packages"
}

if (-not (Test-Path -Path $SourceDist)) {
    throw "Pasta dist nao encontrada: $SourceDist"
}

New-Item -ItemType Directory -Force -Path $OutputDir | Out-Null

$zipName = "MSK_PDF_Pro_Update_v$Version.zip"
$zipPath = Join-Path $OutputDir $zipName

if (Test-Path -Path $zipPath) {
    Remove-Item -Path $zipPath -Force
}

Compress-Archive -Path (Join-Path $SourceDist "*") -DestinationPath $zipPath -Force

$hash = (Get-FileHash -Algorithm SHA256 -Path $zipPath).Hash

$manifest = [ordered]@{
    version = $Version
    minimumVersion = "1.7.7"
    packageUrl = "https://github.com/msilva2003-cloud/mskpdfeditor-deploy/releases/download/v$Version/$zipName"
    sha256 = $hash
    installerUrl = "https://github.com/msilva2003-cloud/mskpdfeditor-deploy/releases/download/v$Version/MSK_PDF_Pro_Setup_v$Version.exe"
    notes = "Inclui verificacao automatica de atualizacoes pelo menu Ajuda, alerta visual quando houver nova versao, download/aplicacao do pacote de atualizacao, EULA freeware e manual do sistema."
    publishedAt = (Get-Date -Format "yyyy-MM-dd")
    files = @(
        "pdfmsk3.exe",
        "app_icon.ico",
        "platforms/",
        "imageformats/",
        "styles/",
        "tls/",
        "generic/",
        "networkinformation/",
        "Tesseract-OCR/",
        "python_embed/",
        "docs/"
    )
}

$manifestPath = Join-Path $RepoRoot "release-manifests\update.json"
$manifest | ConvertTo-Json -Depth 5 | Set-Content -Path $manifestPath -Encoding UTF8

Write-Host "Pacote gerado: $zipPath"
Write-Host "SHA256: $hash"
Write-Host "Manifesto atualizado: $manifestPath"
