{
  self,
  inputs,
  ...
}: {
  flake.nixosModules.stylix = {
    options,
    lib,
    ...
  }: {
    imports = [
      inputs.stylix.nixosModules.stylix
      self.commonModules.stylix
    ];

    stylix.targets = {
      nvf.enable = false;
      # Disable problematic or unused targets
    } // lib.optionalAttrs (options.stylix.targets ? plymouth) {
      plymouth.enable = false;
    } // lib.optionalAttrs (options.stylix.targets ? kmscon) {
      kmscon.enable = false;
    } // lib.optionalAttrs (options.stylix.targets ? niri) {
      niri.enable = false;
    } // lib.optionalAttrs (options.stylix.targets ? vesktop) {
      vesktop.enable = false;
    };
  };
}
