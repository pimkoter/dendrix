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
      ly
      misc
      networking
      niri
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
