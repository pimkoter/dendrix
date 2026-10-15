{ inputs, ... }:
{
  flake.nixosModules.omnisearch = {
    imports = [ inputs.omnisearch.nixosModules.default ];
    services.omnisearch = {
      enable = true;
    };
  };
}
