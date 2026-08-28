{
  self,
  inputs,
  ...
}:
{
  flake.nixosConfigurations.wsl = inputs.nixpkgs.lib.nixosSystem {
    modules = with self.nixosModules; [
      # Hardware
      { nixpkgs.hostPlatform = "x86_64-linux"; }

      # Core modules
      misc
      pkgs
      programs
      services
      stylix
      wsl

      # Users
      pim
    ];
  };
}
