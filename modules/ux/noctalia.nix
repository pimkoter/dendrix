{
  self,
  inputs,
  ...
}: {
  flake.homeModules.noctalia = {lib, ...}: {
    home.file.".config/noctalia/settings.json.template" = {
      text = builtins.toJSON {
        appLauncher = {
          autoPasteClipboard = false;
          clipboardWatchImageCommand = "wl-paste --type image --watch cliphist store";
          clipboardWatchTextCommand = "wl-paste --type text --watch cliphist store";
          clipboardWrapText = true;
          customLaunchPrefix = "";
          customLaunchPrefixEnabled = false;
          density = "comfortable";
          enableClipPreview = true;
          enableClipboardChips = true;
          enableClipboardHistory = true;
          enableClipboardSmartIcons = true;
          enableSessionSearch = false;
          enableSettingsSearch = false;
          enableWindowsSearch = false;
          iconMode = "native";
          ignoreMouseInput = false;
          overviewLayer = true;
          pinnedApps = [];
          position = "center";
          screenshotAnnotationTool = "";
          showCategories = true;
          showIconBackground = true;
          sortByMostUsed = true;
          terminalCommand = "kitty -e";
          viewMode = "list";
        };
        audio = {
          mprisBlacklist = [];
          preferredPlayer = "spotify";
          spectrumFrameRate = 30;
          spectrumMirrored = true;
          visualizerType = "mirrored";
          volumeFeedback = true;
          volumeFeedbackSoundFile = "";
          volumeOverdrive = true;
          volumeStep = 5;
        };
        bar = {
          autoHideDelay = 500;
          autoShowDelay = 150;
          backgroundOpacity = 0.7000000000000001;
          barType = "simple";
          capsuleColorKey = "none";
          capsuleOpacity = 1;
          contentPadding = 2;
          density = "default";
          displayMode = "always_visible";
          enableExclusionZoneInset = true;
          fontScale = 1;
          frameRadius = 12;
          frameThickness = 8;
          hideOnOverview = true;
          marginHorizontal = 4;
          marginVertical = 4;
          middleClickAction = "none";
          middleClickCommand = "";
          middleClickFollowMouse = false;
          monitors = [];
          mouseWheelAction = "none";
          mouseWheelWrap = true;
          outerCorners = true;
          position = "right";
          reverseScroll = false;
          rightClickAction = "controlCenter";
          rightClickCommand = "";
          rightClickFollowMouse = true;
          screenOverrides = [];
          showCapsule = true;
          showOnWorkspaceSwitch = true;
          showOutline = false;
          useSeparateOpacity = true;
          widgetSpacing = 6;
          widgets = {
            center = [
              {
                characterCount = 2;
                colorizeIcons = false;
                emptyColor = "secondary";
                enableScrollWheel = false;
                focusedColor = "primary";
                followFocusedScreen = true;
                fontWeight = "bold";
                groupedBorderOpacity = 1;
                hideUnoccupied = true;
                iconScale = 0.8;
                id = "Workspace";
                labelMode = "index";
                occupiedColor = "secondary";
                pillSize = 0.6;
                showApplications = false;
                showApplicationsHover = false;
                showBadge = true;
                showLabelsOnlyWhenOccupied = false;
                unfocusedIconsOpacity = 1;
              }
              {
                clockColor = "none";
                customFont = "";
                formatHorizontal = "HH:mm ddd, MMM dd";
                formatVertical = "HH mm - dd MM";
                id = "Clock";
                tooltipFormat = "HH:mm ddd, MMM dd";
                useCustomFont = false;
              }
              {
                deviceNativePath = "";
                displayMode = "alwaysShow";
                hideIfIdle = true;
                hideIfNotDetected = false;
                id = "Battery";
                showNoctaliaPerformance = true;
                showPowerProfiles = true;
              }
            ];
            left = [
              {
                colorizeDistroLogo = false;
                colorizeSystemIcon = "none";
                colorizeSystemText = "none";
                customIconPath = "";
                enableColorization = false;
                icon = "noctalia";
                id = "ControlCenter";
                useDistroLogo = true;
              }
              {
                colorName = "primary";
                hideWhenIdle = false;
                id = "AudioVisualizer";
                width = 200;
              }
            ];
            right = [
              {
                iconColor = "none";
                id = "WallpaperSelector";
              }
              {
                displayMode = "onhover";
                iconColor = "none";
                id = "Bluetooth";
                textColor = "none";
              }
              {
                iconColor = "error";
                id = "SessionMenu";
              }
              {
                id = "plugin:hassio";
              }
            ];
          };
        };
        brightness = {
          backlightDeviceMappings = [];
          brightnessStep = 5;
          enableDdcSupport = false;
          enforceMinimum = true;
        };
        calendar = {
          cards = [
            {
              enabled = true;
              id = "calendar-header-card";
            }
            {
              enabled = true;
              id = "calendar-month-card";
            }
            {
              enabled = true;
              id = "weather-card";
            }
          ];
        };
        colorSchemes = {
          darkMode = true;
          generationMethod = "faithful";
          manualSunrise = "06:30";
          manualSunset = "18:30";
          monitorForColors = "eDP-1";
          predefinedScheme = "Noctalia (default)";
          schedulingMode = "off";
          syncGsettings = true;
          useWallpaperColors = true;
        };
        controlCenter = {
          cards = [
            {
              enabled = true;
              id = "profile-card";
            }
            {
              enabled = true;
              id = "shortcuts-card";
            }
            {
              enabled = true;
              id = "audio-card";
            }
            {
              enabled = true;
              id = "brightness-card";
            }
            {
              enabled = true;
              id = "weather-card";
            }
            {
              enabled = true;
              id = "media-sysmon-card";
            }
          ];
          diskPath = "/";
          position = "close_to_bar_button";
          shortcuts = {
            left = [
              {id = "Network";}
              {id = "Bluetooth";}
              {id = "WallpaperSelector";}
              {id = "NoctaliaPerformance";}
            ];
            right = [
              {id = "Notifications";}
              {id = "PowerProfile";}
              {id = "KeepAwake";}
              {id = "NightLight";}
            ];
          };
        };
        desktopWidgets = {
          enabled = true;
          gridSnap = true;
          gridSnapScale = false;
          monitorWidgets = [
            {
              name = "DP-6";
              widgets = [];
            }
            {
              name = "eDP-1";
              widgets = [
                {
                  diskPath = "/";
                  id = "SystemStat";
                  layout = "bottom";
                  roundedCorners = true;
                  showBackground = true;
                  statType = "CPU";
                  x = 150;
                  y = 150;
                }
                {
                  diskPath = "/";
                  id = "SystemStat";
                  layout = "bottom";
                  roundedCorners = true;
                  showBackground = true;
                  statType = "Memory";
                  x = 1081;
                  y = 759;
                }
                {
                  diskPath = "/";
                  id = "SystemStat";
                  layout = "bottom";
                  roundedCorners = true;
                  showBackground = true;
                  statType = "Network";
                  x = 414;
                  y = 322;
                }
                {
                  id = "Weather";
                  roundedCorners = true;
                  showBackground = true;
                  x = 828;
                  y = 184;
                }
                {
                  colorName = "primary";
                  height = 400;
                  hideWhenIdle = false;
                  id = "AudioVisualizer";
                  roundedCorners = true;
                  showBackground = true;
                  visualizerType = "linear";
                  width = 600;
                  x = 161;
                  y = 575;
                }
                {
                  clockColor = "none";
                  clockStyle = "digital";
                  customFont = "";
                  format = "HH:mm\\nd MMMM yyyy";
                  id = "Clock";
                  roundedCorners = true;
                  showBackground = true;
                  useCustomFont = false;
                  x = 1104;
                  y = 391;
                }
              ];
            }
          ];
          overviewEnabled = true;
        };
        dock = {
          animationSpeed = 1;
          backgroundOpacity = 1;
          colorizeIcons = false;
          deadOpacity = 0.6;
          displayMode = "auto_hide";
          dockType = "floating";
          enabled = false;
          floatingRatio = 1;
          groupApps = false;
          groupClickAction = "cycle";
          groupContextMenuMode = "extended";
          groupIndicatorStyle = "dots";
          inactiveIndicators = false;
          indicatorColor = "primary";
          indicatorOpacity = 0.6;
          indicatorThickness = 3;
          launcherIcon = "";
          launcherIconColor = "none";
          launcherPosition = "end";
          launcherUseDistroLogo = false;
          monitors = [];
          onlySameOutput = true;
          pinnedApps = [];
          pinnedStatic = false;
          position = "bottom";
          showDockIndicator = false;
          showLauncherIcon = false;
          sitOnFrame = false;
          size = 1;
        };
        general = {
          allowPanelsOnScreenWithoutBar = true;
          allowPasswordWithFprintd = false;
          animationDisabled = false;
          animationSpeed = 1;
          autoStartAuth = false;
          avatarImage = "/home/pim/.face";
          boxRadiusRatio = 1;
          clockFormat = "hh\nmm";
          clockStyle = "digital";
          compactLockScreen = true;
          dimmerOpacity = 0.2;
          enableBlurBehind = true;
          enableLockScreenCountdown = true;
          enableLockScreenMediaControls = false;
          enableShadows = true;
          forceBlackScreenCorners = false;
          iRadiusRatio = 1;
          keybinds = {
            keyDown = ["Down"];
            keyEnter = ["Return"];
            keyEscape = ["Esc"];
            keyLeft = ["Left"];
            keyRemove = ["Del"];
            keyRight = ["Right"];
            keyUp = ["Up"];
          };
          language = "";
          lockOnSuspend = true;
          lockScreenAnimations = true;
          lockScreenBlur = 0.2;
          lockScreenCountdownDuration = 10000;
          lockScreenMonitors = [];
          lockScreenTint = 0;
          passwordChars = true;
          radiusRatio = 1;
          reverseScroll = false;
          scaleRatio = 1;
          screenRadiusRatio = 1;
          shadowDirection = "bottom_right";
          shadowOffsetX = 2;
          shadowOffsetY = 3;
          showChangelogOnStartup = true;
          showHibernateOnLockScreen = true;
          showScreenCorners = false;
          showSessionButtonsOnLockScreen = true;
          smoothScrollEnabled = true;
          telemetryEnabled = false;
        };
        hooks = {
          colorGeneration = "";
          darkModeChange = "";
          enabled = false;
          performanceModeDisabled = "";
          performanceModeEnabled = "";
          screenLock = "";
          screenUnlock = "";
          session = "";
          startup = "";
          wallpaperChange = "";
        };
        idle = {
          customCommands = "[]";
          enabled = true;
          fadeDuration = 5;
          lockCommand = "";
          lockTimeout = 300;
          resumeLockCommand = "";
          resumeScreenOffCommand = "";
          resumeSuspendCommand = "";
          screenOffCommand = "";
          screenOffTimeout = 0;
          suspendCommand = "";
          suspendTimeout = 0;
        };
        location = {
          analogClockInCalendar = false;
          autoLocate = true;
          firstDayOfWeek = 1;
          hideWeatherCityName = false;
          hideWeatherTimezone = false;
          name = "Alphen aan den Rijn";
          showCalendarEvents = true;
          showCalendarWeather = true;
          showWeekNumberInCalendar = true;
          use12hourFormat = false;
          useFahrenheit = false;
          weatherEnabled = true;
          weatherShowEffects = true;
        };
      };
    };

    home.activation.noctaliaSettingsInit = lib.hm.dag.entryAfter ["writeBoundary"] ''
      SETTINGS_FILE="$HOME/.config/noctalia/settings.json"
      TEMPLATE_FILE="$HOME/.config/noctalia/settings.json.template"

      if [ ! -f "$SETTINGS_FILE" ] || [ -L "$SETTINGS_FILE" ]; then
        $DRY_RUN_CMD rm -f "$SETTINGS_FILE"
        $DRY_RUN_CMD cp "$TEMPLATE_FILE" "$SETTINGS_FILE"
        $DRY_RUN_CMD chmod 644 "$SETTINGS_FILE"
      fi
    '';

    home.activation.noctaliaWarning = lib.hm.dag.entryAfter ["noctaliaSettingsInit"] ''
      $DRY_RUN_CMD echo ""
      $DRY_RUN_CMD echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
      $DRY_RUN_CMD echo "🌙 Noctalia Shell is ENABLED"
      $DRY_RUN_CMD echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
      $DRY_RUN_CMD echo ""
      $DRY_RUN_CMD echo "⚠️  Waybar has been automatically disabled"
      $DRY_RUN_CMD echo ""
      $DRY_RUN_CMD echo "📝 Configuration: ~/.config/noctalia/settings.json (GUI-editable)"
      $DRY_RUN_CMD echo "🎨 Settings synced from GUI (use ./sync-from-gui.py to update)"
      $DRY_RUN_CMD echo "✏️  All GUI changes persist across reboots"
      $DRY_RUN_CMD echo ""
      $DRY_RUN_CMD echo "💡 To update Nix template from GUI changes:"
      $DRY_RUN_CMD echo "   cd modules/home/noctalia-shell && ./sync-from-gui.py"
      $DRY_RUN_CMD echo ""
      $DRY_RUN_CMD echo "📚 Docs: https://docs.noctalia.dev"
      $DRY_RUN_CMD echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
      $DRY_RUN_CMD echo ""
    '';
  };
}
