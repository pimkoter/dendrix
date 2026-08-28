{ inputs, ... }:
{
  flake.nixosModules.wsl = {
    imports = [ inputs.nixos-wsl.nixosModules.default ];

    wsl = {
      enable = true;
      defaultUser = "Pim Zeeman";
    };

    boot.isContainer = true;
  };
}
