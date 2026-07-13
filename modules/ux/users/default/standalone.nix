{
  self,
  inputs,
  ...
}: {
  flake.homeConfigurations.default = inputs.home-manager.lib.homeManagerConfiguration {
    pkgs = import inputs.nixpkgs {system = "x86_64-linux";};
    modules = [
      inputs.stylix.homeManagerModules.stylix
      self.commonModules.stylix
      self.homeModules.default
    ];
  };
}
