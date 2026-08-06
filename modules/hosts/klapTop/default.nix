{
  self,
  inputs,
  ...
}:
{
  flake.nixosConfigurations.klapTop = inputs.nixpkgs.lib.nixosSystem {
    modules = with self.nixosModules; [
      # Hardware
      klapTop

      # Core modules
      boot
      drivers
      howdy
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
