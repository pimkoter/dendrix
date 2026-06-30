{
  self,
  inputs,
  ...
}: let
  pimHomeModule = {pkgs, ...}: {
    imports = [
      self.homeModules.bat
      self.homeModules.eza
      self.homeModules.fastfetch
      self.homeModules.git
      self.homeModules.kitty
      self.homeModules.lazygit
      self.homeModules.niri
      self.homeModules.noctalia
      self.homeModules.nvf
      self.homeModules.starship
      self.homeModules.tmux
      self.homeModules.wallpapers
      self.homeModules.zoxide
      self.homeModules.zsh
    ];
    home = {
      username = "pim";
      homeDirectory = "/home/pim";
      stateVersion = "25.05";
    };
  };
in {
  flake.homeModules.pim = pimHomeModule;

  flake.homeConfigurations.pim = inputs.home-manager.lib.homeManagerConfiguration {
    pkgs = import inputs.nixpkgs {system = "x86_64-linux";};
    modules = [pimHomeModule];
    extraSpecialArgs = {
      inherit self inputs;
      hostName = "NixBTW"; # Default for standalone
    };
  };

  flake.nixosModules.pim = {
    config,
    pkgs,
    ...
  }: {
    imports = [
      inputs.home-manager.nixosModules.home-manager
    ];

    home-manager = {
      useGlobalPkgs = true;
      useUserPackages = true;
      extraSpecialArgs = {
        inherit self inputs;
        hostName = config.networking.hostName;
      };
      users.pim = pimHomeModule;
    };

    users.users.pim = {
      isNormalUser = true;
      description = "Main user";
      initialPassword = "12345";
      extraGroups = [
        "wheel"
        "networkmanager"
        "wireshark"
        "docker"
        "libvirtd"
        "kvm"
      ];
      ignoreShellProgramCheck = true;
    };
  };
}
