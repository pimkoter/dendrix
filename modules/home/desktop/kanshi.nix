{
  flake.homeModules.kanshi = {
    services.kanshi = {
      enable = true;

      settings = [
        {
          profile = {
            name = "laptop";

            outputs = [
              {
                criteria = "eDP-1";
                mode = "2560x1600@60Hz";
                scale = 1.5;
                status = "enable";
                position = "0,0";
              }
            ];
          };
        }

        {
          profile = {
            name = "workstation";

            outputs = [
              {
                # Main monitor
                criteria = "DP-5";
                mode = "1920x1080@143.994Hz";
                scale = 1.0;
                status = "enable";
                position = "0,0";
              }

              {
                # Side monitor
                criteria = "DP-3";
                mode = "1920x1080@60Hz";
                scale = 1.0;
                status = "enable";
                position = "1920,0";
              }

              {
                # Laptop centered underneath main monitor
                criteria = "eDP-1";
                mode = "2560x1600@60Hz";
                scale = 1.5;
                status = "enable";
                position = "107,1080";
              }
            ];
          };
        }
      ];
    };
  };
}
