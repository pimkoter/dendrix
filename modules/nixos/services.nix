{
  flake.nixosModules.services = { pkgs, ... }: {
    services = {
      avahi = {
        enable = true;
        openFirewall = true;
      };
      printing = {
        enable = true;
      };
      openssh.enable = true;
      upower.enable = true;
      xserver.xkb = {
        layout = "us";
      };
      blueman.enable = true;
      tailscale = {
        enable = true;
        extraUpFlags = [
          "--netfilter-mode=nodivert"
          "--no-logs-no-support"
        ];
      };
      fail2ban = {
        enable = true;
        bantime = "10m";
        bantime-increment.factor = "6";
      };
    };
    hardware.bluetooth = {
      enable = true;
      powerOnBoot = true;
    };

    # Auto enable tailscale on boot
    systemd.services.tailscale-autoconnect = {
      description = "Automatic connection to Tailscale";

      # make sure tailscale is running before trying to connect to tailscale
      after = [
        "network-pre.target"
        "tailscale.service"
      ];
      wants = [
        "network-pre.target"
        "tailscale.service"
      ];
      wantedBy = [ "multi-user.target" ];

      # set this service as a oneshot job
      serviceConfig.Type = "oneshot";

      # have the job run this shell script
      script = with pkgs; ''
        sleep 2
        status="$(${tailscale}/bin/tailscale status -json | ${jq}/bin/jq -r .BackendState)"
        if [ $status = "Running" ]; then # if so, then do nothing
          exit 0
        fi
        ${tailscale}/bin/tailscale up
      '';
    };
  };
}
