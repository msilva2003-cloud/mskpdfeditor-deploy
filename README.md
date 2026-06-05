# MSK PDF Pro Deploy

Repositório público de distribuição do MSK PDF Pro.

Este repositório não contém o código-fonte do sistema. Ele existe apenas para publicar releases, instaladores e pacotes de atualização usados pelo mecanismo de atualização automática.

## Estrutura

- `release-manifests/update.json`: manifesto consultado pelo aplicativo para saber se existe atualização.
- `scripts/make-update-package.ps1`: gera um `.zip` de atualização a partir da pasta `dist` do projeto privado.
- `scripts/publish-release.ps1`: publica uma release no GitHub usando GitHub CLI.

## Fluxo de release

1. Gere o build no projeto privado.
2. Rode `DEPLOY.bat` ou `MAKE_INSTALLER.bat`.
3. Gere o pacote de atualização:

```powershell
.\scripts\make-update-package.ps1 -Version 1.8.2 -SourceDist "<caminho-da-pasta-dist>"
```

4. Publique a release:

```powershell
.\scripts\publish-release.ps1 -Version 1.8.2 -InstallerPath "<caminho-do-instalador>\MSK_PDF_Pro_Setup_v1.8.2.exe"
```

O aplicativo deve baixar apenas pacotes publicados em releases deste repositório.
