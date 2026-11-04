{
  flake.nixosModules.ollama = { pkgs, ... }: {
    services = {
      open-webui.enable = true;
      ollama = {
        enable = true;
        user = "ollama";
        group = "ollama";
        modelsDir = "/var/lib/ollama-models";
        package = pkgs.ollama-cuda;
        loadModels = [
          "qwen2.5-coder:14b"
        ];
      };
    };
    systemd.tmpfiles.rules = [
      "d /var/lib/ollama-models 0750 ollama ollama - -"
    ];
  };
}
