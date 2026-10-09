{
  flake.nixosModules.ollama = { pkgs, ... }: {
    services = {
      ollama = {
        enable = true;
        package = pkgs.ollama-cuda;
        loadModels = [
          "qwen3:4b-thinking"
          "qwen3:1.7b"
          "devstral:24b"
        ];
      };
      open-webui = {
        enable = true;
      };
    };
  };
}
