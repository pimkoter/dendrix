{lib, ...}: {
  options.flake.homeModules = lib.mkOption {
    type = lib.types.lazyAttrsOf lib.types.anything;
    default = {};
    description = "Exported Home Manager modules.";
  };
}
