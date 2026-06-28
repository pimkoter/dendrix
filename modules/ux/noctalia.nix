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
          density = "default";
          enableClipPreview = true;
          enableClipboardHistory = true;
          enableSettingsSearch = true;
          enableWindowsSearch = true;
          iconMode = "tabler";
          ignoreMouseInput = false;
          overviewLayer = false;
          pinnedApps = [];
          position = "center";
          screenshotAnnotationTool = "";
          showCategories = true;
          showIconBackground = true;
          sortByMostUsed = true;
          terminalCommand = "xterm -e";
          useApp2Unit = false;
          viewMode = "list";
        };
        audio = {
          cavaFrameRate = 30;
          mprisBlacklist = [];
          preferredPlayer = "spotify";
          visualizerType = "mirrored";
          volumeFeedback = true;
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
          density = "default";
          displayMode = "always_visible";
          floating = false;
          frameRadius = 12;
          frameThickness = 8;
          hideOnOverview = false;
          marginHorizontal = 4;
          marginVertical = 4;
          monitors = [];
          outerCorners = true;
          position = "right";
          screenOverrides = [];
          showCapsule = true;
          showOutline = false;
          useSeparateOpacity = true;
          widgets = {
            center = [
              {
                characterCount = 2;
                colorizeIcons = false;
                emptyColor = "secondary";
                enableScrollWheel = false;
                focusedColor = "primary";
                followFocusedScreen = true;
                groupedBorderOpacity = 1;
                hideUnoccupied = true;
                iconScale = 0.8;
                id = "Workspace";
                labelMode = "index";
                occupiedColor = "secondary";
                pillSize = 0.6;
                reverseScroll = false;
                showApplications = false;
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
            ];
          };
        };
        brightness = {
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
          generationMethod = "monochrome";
          manualSunrise = "06:30";
          manualSunset = "18:30";
          monitorForColors = "eDP-2";
          predefinedScheme = "Noctalia (default)";
          schedulingMode = "off";
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
              enabled = false;
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
              {
                id = "Network";
              }
              {
                id = "Bluetooth";
              }
              {
                id = "WallpaperSelector";
              }
              {
                id = "NoctaliaPerformance";
              }
            ];
            right = [
              {
                id = "Notifications";
              }
              {
                id = "PowerProfile";
              }
              {
                id = "KeepAwake";
              }
              {
                id = "NightLight";
              }
            ];
          };
        };
        desktopWidgets = {
          enabled = true;
          gridSnap = true;
          monitorWidgets = [
            {
              name = "DP-6";
              widgets = [];
            }
          ];
        };
        dock = {
          animationSpeed = 1;
          backgroundOpacity = 1;
          colorizeIcons = false;
          deadOpacity = 0.6;
          displayMode = "auto_hide";
          enabled = false;
          floatingRatio = 1;
          inactiveIndicators = false;
          monitors = [];
          onlySameOutput = true;
          pinnedApps = [];
          pinnedStatic = false;
          position = "bottom";
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
          clockStyle = "custom";
          compactLockScreen = true;
          dimmerOpacity = 0.2;
          enableLockScreenCountdown = true;
          enableShadows = true;
          forceBlackScreenCorners = false;
          iRadiusRatio = 1;
          keybinds = {
            keyDown = "Down";
            keyEnter = "Return";
            keyEscape = "Esc";
            keyLeft = "Left";
            keyRight = "Right";
            keyUp = "Up";
          };
          language = "";
          lockOnSuspend = true;
          lockScreenAnimations = false;
          lockScreenCountdownDuration = 10000;
          lockScreenMonitors = [];
          radiusRatio = 1;
          scaleRatio = 1;
          screenRadiusRatio = 1;
          shadowDirection = "bottom_right";
          shadowOffsetX = 2;
          shadowOffsetY = 3;
          showChangelogOnStartup = true;
          showHibernateOnLockScreen = true;
          showScreenCorners = false;
          showSessionButtonsOnLockScreen = true;
          telemetryEnabled = false;
        };
        hooks = {
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
        "location" = {
          analogClockInCalendar = false;
          firstDayOfWeek = -1;
          hideWeatherCityName = false;
          hideWeatherTimezone = false;
          name = "Amsterdam";
          showCalendarEvents = true;
          showCalendarWeather = true;
          showWeekNumberInCalendar = true;
          use12hourFormat = false;
          useFahrenheit = false;
          weatherEnabled = true;
          weatherShowEffects = true;
        };
        network = {
          bluetoothDetailsViewMode = "grid";
          bluetoothHideUnnamedDevices = false;
          bluetoothRssiPollIntervalMs = 10000;
          bluetoothRssiPollingEnabled = false;
          wifiDetailsViewMode = "grid";
          wifiEnabled = true;
        };
        nightLight = {
          autoSchedule = true;
          dayTemp = "6500";
          enabled = false;
          forced = false;
          manualSunrise = "06:30";
          manualSunset = "18:30";
          nightTemp = "4000";
        };
        notifications = {
          backgroundOpacity = 1;
          criticalUrgencyDuration = 15;
          enableBatteryToast = true;
          enableKeyboardLayoutToast = true;
          enableMediaToast = false;
          enabled = true;
          "location" = "top_right";
          lowUrgencyDuration = 3;
          monitors = [];
          normalUrgencyDuration = 8;
          overlayLayer = true;
          respectExpireTimeout = false;
          saveToHistory = {
            critical = false;
            low = false;
            normal = false;
          };
          sounds = {
            criticalSoundFile = "";
            enabled = false;
            excludedApps = "discord,firefox,chrome,chromium,edge";
            lowSoundFile = "";
            normalSoundFile = "";
            separateSounds = false;
            volume = 0.5;
          };
        };
        osd = {
          autoHideMs = 2000;
          backgroundOpacity = 1;
          enabled = true;
          enabledTypes = [0 1 2 3];
          "location" = "top_right";
          monitors = [];
          overlayLayer = true;
        };
        plugins = {
          autoUpdate = false;
        };
        sessionMenu = {
          countdownDuration = 10000;
          enableCountdown = true;
          largeButtonsLayout = "grid";
          largeButtonsStyle = true;
          position = "center";
          powerOptions = [
            {
              action = "lock";
              command = "";
              countdownEnabled = true;
              enabled = true;
              keybind = "";
            }
            {
              action = "suspend";
              command = "";
              countdownEnabled = true;
              enabled = false;
              keybind = "";
            }
            {
              action = "hibernate";
              command = "";
              countdownEnabled = true;
              enabled = false;
              keybind = "";
            }
            {
              action = "reboot";
              command = "";
              countdownEnabled = true;
              enabled = true;
              keybind = "";
            }
            {
              action = "logout";
              command = "";
              countdownEnabled = true;
              enabled = true;
              keybind = "";
            }
            {
              action = "shutdown";
              command = "";
              countdownEnabled = true;
              enabled = true;
              keybind = "";
            }
          ];
          showHeader = true;
          showNumberLabels = false;
        };
        settingsVersion = 49;
        systemMonitor = {
          batteryCriticalThreshold = 5;
          batteryWarningThreshold = 20;
          cpuCriticalThreshold = 90;
          cpuPollingInterval = 1000;
          cpuWarningThreshold = 80;
          criticalColor = "";
          diskAvailCriticalThreshold = 10;
          diskAvailWarningThreshold = 20;
          diskCriticalThreshold = 90;
          diskPollingInterval = 30000;
          diskWarningThreshold = 80;
          enableDgpuMonitoring = false;
          externalMonitor = "resources || missioncenter || jdsystemmonitor || corestats || system-monitoring-center || gnome-system-monitor || plasma-systemmonitor || mate-system-monitor || ukui-system-monitor || deepin-system-monitor || pantheon-system-monitor";
          gpuCriticalThreshold = 90;
          gpuPollingInterval = 3000;
          gpuWarningThreshold = 80;
          loadAvgPollingInterval = 3000;
          memCriticalThreshold = 90;
          memPollingInterval = 1000;
          memWarningThreshold = 80;
          networkPollingInterval = 1000;
          swapCriticalThreshold = 90;
          swapWarningThreshold = 80;
          tempCriticalThreshold = 90;
          tempWarningThreshold = 80;
          useCustomColors = false;
          warningColor = "";
        };
        templates = {
          activeTemplates = [];
          enableUserTheming = false;
        };
        ui = {
          bluetoothDetailsViewMode = "grid";
          bluetoothHideUnnamedDevices = false;
          boxBorderEnabled = true;
          fontDefault = "Sans Serif";
          fontDefaultScale = 1;
          fontFixed = "monospace";
          fontFixedScale = 1;
          networkPanelView = "wifi";
          panelBackgroundOpacity = 0.93;
          panelsAttachedToBar = true;
          settingsPanelMode = "attached";
          tooltipsEnabled = true;
          wifiDetailsViewMode = "grid";
        };
        wallpaper = {
          automationEnabled = false;
          directory = "/run/current-system/sw/share/wallpapers";
          enableMultiMonitorDirectories = false;
          enabled = true;
          fillColor = "#000000";
          fillMode = "crop";
          hideWallpaperFilenames = false;
          monitorDirectories = [];
          overviewBlur = 0.4;
          overviewEnabled = false;
          overviewTint = 0.6;
          panelPosition = "follow_bar";
          randomIntervalSec = 300;
          setWallpaperOnAllMonitors = true;
          showHiddenFiles = false;
          solidColor = "#1a1a2e";
          sortOrder = "name";
          transitionDuration = 1500;
          transitionEdgeSmoothness = 0.05;
          transitionType = "random";
          useSolidColor = false;
          useWallhaven = false;
          viewMode = "single";
          wallhavenApiKey = "";
          wallhavenCategories = "111";
          wallhavenOrder = "desc";
          wallhavenPurity = "100";
          wallhavenQuery = "";
          wallhavenRatios = "";
          wallhavenResolutionHeight = "";
          wallhavenResolutionMode = "atleast";
          wallhavenResolutionWidth = "";
          wallhavenSorting = "relevance";
          wallpaperChangeMode = "random";
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
