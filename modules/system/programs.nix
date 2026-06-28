{
  self,
  inputs,
  ...
}: {
  flake.nixosModules.programs = {
    programs = {
      nix-ld.enable = true;
      niri.enable = true;
      xwayland.enable = true;
      gamemode.enable = true;
      steam = {
        enable = true;
        remotePlay.openFirewall = true;
        dedicatedServer.openFirewall = true;
      };
    };
  };
}
