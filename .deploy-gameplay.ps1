# Dossier racine contenant Gameplay
$root = "$env:USERPROFILE\Documents\Anno 1800\mods"

# Dossier Gameplay
$gameplayPath = Join-Path $root "Gameplay"

# Récupérer tous les dossiers finaux
$finalDirs = Get-ChildItem -Path $gameplayPath -Recurse -Directory | Where-Object {
    # On considère un dossier "final" quand il est 3 niveaux sous Gameplay
    ($_.Parent.Parent.Parent.FullName -eq $gameplayPath) -and ($_.Parent.Parent -ne $null)
}

foreach ($dir in $finalDirs) {
    # Extraction des infos de hiérarchie
    $gameplay    = $dir.Parent.Parent.Parent.Name  # "Gameplay"
    $worldRaw = $dir.Parent.Parent.Name         # "1.Old World"
    $typeRaw  = $dir.Parent.Name                # "1.Animal"

    # Nettoyage du préfixe numérique "1."
    $world = ($worldRaw -replace "^\d+\.", "").Trim()
    $type  = ($typeRaw  -replace "^\d+\.", "").Trim()

    # Nouveau nom du dossier
    $newName = "{0} - {1} - {2} - {3}" -f $gameplay, $world, $type, $dir.Name

    # Chemin de destination (à côté de Gameplay)
    $destPath = Join-Path $root $newName

    # Vérification avec -LiteralPath (meilleure pour noms avec [])
    if (Test-Path -LiteralPath $destPath) {
        Remove-Item -LiteralPath $destPath -Recurse -Force
        Write-Host "⚠️ Supprimé ancien dossier : $destPath"
    }

    # Copie avec remplacement
    Copy-Item -Path $dir.FullName -Destination $destPath -Recurse
    Write-Host "✅ Copié : $($dir.FullName) -> $destPath"
}