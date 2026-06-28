{
  self,
  inputs,
  ...
}: {
  flake.nixosConfigurations.NixBTW = inputs.nixpkgs.lib.nixosSystem {
    modules = [
      # Hardware
      self.nixosModules.NixBTW.nix

      # Core modules
      self.nixosModules.boot
      self.nixosModules.drivers
      self.nixosModules.misc
      self.nixosModules.networking
      self.nixosModules.pkgs
      self.nixosModules.plymouth
      self.nixosModules.programs
      self.nixosModules.sddm
      self.nixosModules.services
      self.nixosModules.stylix
      self.nixosModules.virtualisation

      # Users
      self.nixosModules.pim
    ];
  };
}
