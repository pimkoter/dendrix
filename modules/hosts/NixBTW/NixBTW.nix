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
      misc
      networking
      pkgs
      programs
      sddm
      services
      stylix
      virtualisation

      # Users
      pim
    ];
  };
}
