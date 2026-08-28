{ inputs, ... }:
{
  flake.nixosModules.wsl = {
    imports = [ inputs.nixos-wsl.nixosModules.default ];

    wsl = {
      enable = true;
      defaultUser = "pimko";
    };

    boot.isContainer = true;
  };
}
