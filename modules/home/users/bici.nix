{
  self,
  inputs,
  ...
}:
{
  flake = {

    # ------------------------------------------------------------
    # HOME configuration
    # ------------------------------------------------------------

    homeModules.bici =
      {
        pkgs,
        inputs,
        ...
      }:
      let
        stable = inputs.nixpkgs-stable.legacyPackages.${pkgs.stdenv.hostPlatform.system};
      in
      {
        imports = with self.homeModules; [
          inputs.sops-nix.homeManagerModules.sops
          atuin
          bash
          bat
          eza
          fastfetch
          git
          kitty
          lazygit
          nvf
          rofi
          scripts
          starship
          herdr
          zoxide
        ];

        home = {
          username = "bici";
          homeDirectory = "/home/bici";
          stateVersion = "25.05";
          pointerCursor.enable = true;
          packages = with pkgs; [
            # CLI utilities
            bat
            bottom
            fd
            ffmpeg
            fzf
            jq
            lazygit
            ripgrep
            sops
            unzip
            wl-clipboard-rs

            # Misc
            (lib.lowPrio pkgs.gh)
            (lib.lowPrio pkgs.spotify)
          ];
        };
      };

    homeConfigurations.bici = inputs.home-manager.lib.homeManagerConfiguration {
      pkgs = inputs.nixpkgs.legacyPackages.x86_64-linux;

      extraSpecialArgs = {
        inherit self inputs;
      };

      modules = [
        self.homeModules.bici
        inputs.stylix.homeModules.stylix
      ];
    };
  };
}
