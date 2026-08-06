{
  self,
  inputs,
  ...
}: {
  flake.nixosModules.programs = {pkgs, ...}: {
    programs = {
      nix-ld.enable = true;
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
