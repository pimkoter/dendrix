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
      misc
      networking
      pkgs
      plymouth
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
