# Dossier racine contenant AddOn
$root = "$env:USERPROFILE\Documents\Anno 1800\mods"

# Dossier AddOn
$addonPath = Join-Path $root "AddOn"

# Récupérer tous les dossiers directs sous AddOn
$finalDirs = Get-ChildItem -Path $addonPath -Directory

foreach ($dir in $finalDirs) {
    # Extraction des infos de hiérarchie
    $addon = $addonPath.Split('\')[-1]  # "AddOn"
    
    # Nettoyage du préfixe numérique "1."
    $category = ($dir.Name -replace "^\d+\.", "").Trim()

    # Nouveau nom du dossier
    $newName = "{0} - {1}" -f $addon, $category

    # Chemin de destination (à côté de AddOn)
    $destPath = Join-Path $root $newName

    # Supprimer si existe déjà
    if (Test-Path -LiteralPath $destPath) {
        Remove-Item -LiteralPath $destPath -Recurse -Force
        Write-Host "⚠️ Supprimé ancien dossier : $destPath"
    }

    # Copier le dossier
    Copy-Item -LiteralPath $dir.FullName -Destination $destPath -Recurse
    Write-Host "✅ Copié : $($dir.FullName) -> $destPath"
}
