{
  self,
  inputs,
  ...
}:
{
  flake.nixosConfigurations.NixBTW = inputs.nixpkgs.lib.nixosSystem {
    modules = with self.nixosModules; [
      # Hardware
      { nixpkgs.hostPlatform = "x86_64-linux"; }
      { networking.hostName = "NixBTW"; }
      disko-NixBTW
      preservation

      # Core modules
      boot
      drivers
      howdy
      kanata
      ly
      misc
      networking
      niri
      pkgs
      programs
      services
      sops
      stylix
      virtualisation

      # Users
      pim
    ];
  };
}
