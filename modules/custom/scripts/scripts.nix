{
  flake.homeModules.scripts = {
    config,
    pkgs,
    lib,
    ...
  }: let
    # Fix: Points to the current directory where this file and scripts sit together
    scriptsDir = ./.;

    # Read the current directory and filter out everything except .sh files
    scriptFiles =
      builtins.filter
      (name: lib.hasSuffix ".sh" name)
      (builtins.attrNames (builtins.readDir scriptsDir));

    # Map over the files and convert them to compiled Nix scripts
    customScripts =
      builtins.map (
        fileName: let
          binName = lib.removeSuffix ".sh" fileName;
          scriptContent = builtins.readFile "${scriptsDir}/${fileName}";
        in
          pkgs.writeShellScriptBin binName scriptContent
      )
      scriptFiles;
  in {
    home.packages = with pkgs;
      [
        rofi
        jq
        git
      ]
      ++ customScripts;
  };
}
