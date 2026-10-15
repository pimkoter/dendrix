{ inputs, ... }:
{
  flake.homeModules.librewolf = { pkgs, ... }: {
    programs.librewolf = {
      enable = true;

      policies = {
        BlockAboutConfig = false;
        "3rdparty" = {
          Extensions = {
            "newtaboverride@agenedia.com" = {
              type = "custom_url";
              url = "http://localhost:8087";
            };
          };
        };

        ExtensionSettings = {
          "uBlock0@raymondhill.net" = {
            default_area = "menupanel";
            install_url = "addons.mozilla.org/firefox/downloads/latest/ublock-origin/new_tab_override1.75.0.xpi";
            installation_mode = "force_installed";
            private_browsing = true;
          };
          "newtaboverride@agenedia.com" = {
            install_url = "https://addons.mozilla.org/firefox/downloads/file/4907726/new_tab_override-19.0.0.xpi";
            installation_mode = "force_installed";
          };
        };
      };

      profiles.main = {
        search = {
          force = true;
          default = "omnisearch";
          privateDefault = "omnisearch";
          engines = {
            omnisearch = {
              name = "omnisearch";
              urls = [ { template = "http://localhost:8087/search?q={searchTerms}"; } ];
              definedAliases = [ "@os" ];
            };
          };
        };

        id = 0;
        name = "Personal";
        path = "personal";
        isDefault = true;

        userChrome = ''
          #sidebar-panel-header {
            display: none !important;
          }

          * {
            border-radius: 0px !important;
          }
        '';

        userContent = ''
          * {
            border-radius: 0px !important;
          }
        '';

        settings = {
          "browser.startup.homepage" = "http://localhost:8087";
          "browser.startup.page" = 3;
          "browser.newtabpage.enabled" = false;

          "browser.contentblocking.category" = "strict";
          "privacy.fingerprintingProtection" = true;
          "privacy.query_stripping.enabled" = true;
          "privacy.query_stripping.enabled.pbmode" = true;
          "privacy.trackingprotection.enabled" = true;

          "browser.toolbars.bookmarks.visibility" = "never";

          "browser.urlbar.suggest.bookmark" = false;
          "browser.urlbar.suggest.engines" = false;
          "browser.urlbar.suggest.history" = false;
          "browser.urlbar.suggest.openpage" = false;
          "browser.urlbar.suggest.quickactions" = false;
          "browser.urlbar.suggest.recentsearches" = false;
          "browser.urlbar.suggest.topsites" = false;

          # Customization for sidebery bar
          "sidebar.revamp" = true;
          "sidebar.visibility" = "hide-launcher";

          # Enable userChrome.css support.
          "toolkit.legacyUserProfileCustomizations.stylesheets" = true;

          # Automatically enable extensions installed declaratively.
          "extensions.autoDisableScopes" = 0;
        };

        extensions = {
          force = true;
          packages =
            with inputs.nur.legacyPackages.${pkgs.stdenv.hostPlatform.system}.repos.rycee.firefox-addons; [
              sidebery
              darkreader
              ublock-origin
              firefox-color
            ];

          settings = {
            "{7a7a4a92-a2a0-41d1-9fd7-1e92480d612d}".settings = {
              dbInChromeStorage = true;
            };
          };
        };
      };
    };

    stylix.targets.librewolf = {
      profileNames = [ "main" ];
      colorTheme.enable = true;
    };
  };
}
