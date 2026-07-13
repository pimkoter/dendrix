{
  self,
  inputs,
  ...
}: {
  flake.nixosConfigurations.knorComputer = inputs.nixpkgs.lib.nixosSystem {
    modules = with self.nixosModules; [
      # Hardware
      knorComputer

      # Core modules
      boot
      drivers
      howdy
      kde
      ly
      misc
      networking
      pkgs
      programs
      services
      stylix

      # Users
      kiki
    ];
  };
}
