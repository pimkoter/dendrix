{
  self,
  inputs,
  ...
}: {
  flake.nixosConfigurations.NixBTW = inputs.nixpkgs.lib.nixosSystem {
    modules = with self.nixosModules; [
      # Hardware
      knorComputer

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
      xfce

      # Users
      kiki
    ];
  };
}
