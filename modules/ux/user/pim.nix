{
  self,
  inputs,
  ...
}: {
  flake.homeConfigurations.pim = inputs.home-manager.lib.homeManagerConfiguration {
    pkgs = import inputs.nixpkgs {system = "x86_64-linux";};
    home-manager = {
      users.pim = {
        imports = with inputs.self.homeModules; [
          {
            home = {
              username = "pim";
              homeDirectory = "/home/pim";
              stateVersion = "25.05";
            };
          }
          bat
          eza
          fastfetch
          git
          kitty
          lazygit
          niri
          noctalia
          nvf
          starship
          tmux
          wallpapers
          zoxide
          zsh
        ];
      };
    };
  };
}
