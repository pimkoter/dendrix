{
  self,
  inputs,
  ...
}: {
  flake.nixosModules.laptop = {
    services.logind.settings.Login = {
      HandleLidSwitch = "lock";
      HandleLidSwitchExternalPower = "lock";
      HandleLidSwitchDocked = "ignore";
    };

    services.auto-cpufreq = {
      enable = true;
      settings = {
        battery = {
          governor = "powersave";
          turbo = "never";
        };
        charger = {
          governor = "performance";
          turbo = "auto";
        };
      };
    };

    powerManagement.powertop.enable = true;

    services.tlp = {
      enable = true;
      settings = {
        USB_AUTOSUSPEND_ON_AC = "0";
        USB_AUTOSUSPEND_ON_BAT = "0";
        START_CHARGE_THRESH_BAT0 = 40;
        STOP_CHARGE_THRESH_BAT0 = 80;
      };
    };
  };
}
