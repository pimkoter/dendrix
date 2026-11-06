check:
  nix flake check

test:
  sudo nixos-rebuild test --flake

switch:
  sudo nixos-rebuild switch --flake

iso:
  nix build .#nixosConfigurations.iso.config.system.build.isoImage

clean:
 sudo nix-collect-garbage --delete-older-than 5d
