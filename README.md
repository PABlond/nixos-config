# Configuration NixOS — hôte `nixos`

Config système versionnée. `/etc/nixos` pointera vers ce dépôt.

## Machine

| | |
|---|---|
| Hôte | `nixos` |
| NixOS | 26.05 (Yarara) |
| CPU | AMD |
| GPU | NVIDIA RTX 2080 (pilote propriétaire, modules `open`) |
| Disques | `nvme0n1` NixOS (ESP partagé) · `sda` Windows 11 (dual-boot) |
| Bureau | GNOME / GDM, clavier `fr`, `caps:escape` |

## Appliquer

```sh
sudo nixos-rebuild switch
```

## État actuel

Premier commit = la config telle qu'elle tournait dans `/etc/nixos`, sans
retouche, pour servir de point de référence. La restructuration vient ensuite.

## Correctifs temporaires en place

Deux contournements liés à des régressions nixpkgs de novembre 2026. Les deux
doivent être retirés quand l'amont est réparé :

- **Brave** — retiré de nixpkgs 26.05 le 2026-11-04 (PR #582874), faute de
  committer parmi les mainteneurs pour les mises à jour de sécurité. Récupéré
  depuis le dépôt du mainteneur d'origine
  (`codeberg.org/buckley310/brave-browser-nix`). Retour sur 26.05 en attente :
  [PR #584546](https://github.com/NixOS/nixpkgs/pull/584546).
- **VS Code 1.144.0** — upstream a déplacé le ripgrep embarqué, le chemin codé
  en dur dans nixpkgs ne colle plus et le build casse.
  [Issue #584492](https://github.com/NixOS/nixpkgs/issues/584492).

## Secrets

Aucun secret dans ce dépôt. Si le besoin apparaît (clés, tokens), passer par
`sops-nix` ou `agenix` — jamais de valeur en clair, même dans un dépôt privé.
