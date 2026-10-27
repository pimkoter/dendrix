{
  flake.nixosModules.ollama = { pkgs, ... }: {
    services = {
      ollama = {
        enable = true;
        package = pkgs.ollama-cuda;
        loadModels = [
          "qwen2.5-coder:14b"
        ];
      };
    };
  };
}
