{
  flake.nixosModules.ollama = { pkgs, ... }: {
    services = {
      ollama = {
        enable = true;
        package = pkgs.ollama-cuda;
        loadModels = [
          "qwen3:4b-thinking"
        ];
      };
      open-webui = {
        enable = true;
      };
    };
  };
}
