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
      ly
      misc
      networking
      pkgs
      programs
      services
      stylix
      swaylock
      virtualisation

      # Users
      pim
    ];
  };
}
