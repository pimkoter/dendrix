{
  self,
  inputs,
  ...
}: {
  flake.nixosConfigurations.NixBTW = inputs.nixpkgs.lib.nixosSystem {
    modules = with self.nixosModules; [
      # Hardware
      NixBTW

      # Core modules
      boot
      drivers
      howdy
      laptop
      ly
      misc
      networking
      pkgs
      programs
      services
      stylix
      virtualisation

      # Users
      pim
    ];
  };
}
