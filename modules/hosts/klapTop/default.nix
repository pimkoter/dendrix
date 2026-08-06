{
  self,
  inputs,
  ...
}:
{
  flake.nixosConfigurations.klapTop = inputs.nixpkgs.lib.nixosSystem {
    modules = with self.nixosModules; [
      # Hardware
      { nixpkgs.hostPlatform = "x86_64-linux"; }
      klapTop

      # Core modules
      boot
      drivers
      sddm
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
