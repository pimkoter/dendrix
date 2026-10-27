# AGENTS.md

## Project
- Nix flake ("KoterOS"/dendrix) using flake-parts + import-tree. All modules under `modules/` are auto-imported (see `flake.nix`).
- Multi-target: NixOS, home-manager, and cross-platform (`x86_64-linux`, `aarch64-linux`, `aarch64-darwin`).
- Module pattern: modules expose configs as flake attributes like `flake.homeModules.<name>`, `flake.nixosModules.<name>`, etc. See `modules/home/users/pim.nix` and shell modules for examples.
- Home-manager integrated as a flake module; user config is composed in `modules/home/users/pim.nix`.

## Commands (executable sources of truth)
- **Format**: `nix fmt` (formatter is `pkgs.nixfmt-tree` via `perSystem.formatter` in `modules/checks.nix`).
- **Checks/CI-like validation**: `nix flake check` runs pre-commit hooks (git-hooks). Hooks enabled: `nixfmt`, `deadnix`, `statix`, `check-merge-conflicts`, `check-symlinks`, `end-of-file-fixer`, `trim-trailing-whitespace`, `flake-checker`, `trufflehog` (`modules/checks.nix`).
- **Update inputs**: scheduled via `.github/workflows/update-flake-lock.yml` (ossystems/nix-actions/update-flake). Manual: `nix flake update`.
- **Build/switch**: use standard NixOS/home-manager commands against this flake (no custom task runner scripts at repo root). The "ncg" alias in `modules/home/shell/zsh.nix` shows the local pattern for garbage collection + switch to boot, but it's a shell alias in user config, not a repo script.

## Structure & boundaries
- `flake.nix`: inputs/outputs, imports `./modules` via `import-tree`, adds home-manager flake module.
- `modules/`: auto-discovered. Subdirs include `home/` (apps/desktop/shell/themes/users), `hosts/`, `nixos/`, `secrets/`, `scripts/` (rofi/tmux sessionizer helpers), `checks.nix`.
- Shell/home modules are small Nix files under `modules/home/shell/` and composed by user modules (e.g. `modules/home/users/pim.nix` imports many `flake.homeModules.*`).
- Inputs of note: local path inputs (`omnisearch.url = "path:/home/pim/Repos/OmniSearch"`), git inputs with follows; some use specific refs (e.g. `herdr/v0.9.3`).

## Gotchas
- **Local path dependency**: `omnisearch` points to a local path outside the repo (`/home/pim/Repos/OmniSearch`). Changes/builds may require that repo present.
- **SOPS**: `modules/home/users/pim.nix` configures sops-nix with `defaultSopsFile = ../../secrets/secrets.yaml`, age key at `~/.config/sops/age/keys.txt`, and ssh keys from host/preserve paths. Secrets live under `modules/secrets/`.
- **Stylix theming**: used heavily; e.g. `modules/home/shell/opencode.nix` generates theme/config from `config.lib.stylix.colors`.
- **Shell behavior**: `zsh.nix` auto-execs tmux on interactive shells and runs fastfetch; `bash.nix` auto-execs `herdr` in interactive shells (if not in HERDR_ENV). Don't change these without checking user expectations.
- **Pre-commit is enforced in checks**: formatting/linting/security hooks run on `nix flake check`. Fix issues before considering changes clean.
