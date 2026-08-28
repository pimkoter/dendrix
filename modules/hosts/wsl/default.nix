{
  self,
  inputs,
  ...
}:
{
  flake.nixosConfigurations.wsl = inputs.nixpkgs.lib.nixosSystem {
    modules = with self.nixosModules; [
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
