{
  flake.nixosModules.ollama = { pkgs, lib, ... }: {
    services = {
      open-webui.enable = true;
      ollama = {
        enable = true;
        user = "ollama";
        group = "ollama";
        home = "/var/lib/ollama-home";
        modelsDir = "/var/lib/ollama-models";
        package = pkgs.ollama-cuda;
        loadModels = [
          "ornith-1.5:35b"
          "mimo-v2.6"
        ];
        environmentVariables = {
          OLLAMA_CONTEXT_LENGTH = "65536";
          OLLAMA_FLASH_ATTENTION = "1";
        };
      };
    };

    systemd = {
      services.ollama = {
        serviceConfig = {
          DynamicUser = lib.mkForce false;
          StateDirectory = lib.mkForce [ ];
        };
        wants = [ "ollama-models-ownership.service" ];
        after = [ "ollama-models-ownership.service" ];
        unitConfig.RequiresMountsFor = [ "/var/lib/ollama-models" ];
      };

      services.ollama-models-ownership = {
        description = "Repair ownership of the Ollama models directory";
        unitConfig.RequiresMountsFor = [ "/var/lib/ollama-models" ];
        before = [ "ollama.service" ];
        serviceConfig = {
          Type = "oneshot";
          ExecStart = "${pkgs.coreutils}/bin/chown -R ollama:ollama /var/lib/ollama-models";
        };
      };

      tmpfiles.rules = [
        "d /var/lib/ollama-home 0750 ollama ollama - -"
      ];
    };
  };
}
