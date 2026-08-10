{
  flake.homeModules.pythonScripts =
    {
      pkgs,
      lib,
      ...
    }:

    let
      scriptsDir = ./.;
      scriptFiles = builtins.filter (name: lib.hasSuffix ".py" name) (
        builtins.attrNames (builtins.readDir scriptsDir)
      );

      customScripts = builtins.map (
        fileName:
        let
          binName = lib.removeSuffix ".py" fileName;
          scriptContent = builtins.readFile "${scriptsDir}/${fileName}";
        in
        pkgs.writeScriptBin binName ''
          #!${lib.getExe pkgs.python3}
          ${scriptContent}
        ''
      ) scriptFiles;
    in
    {
      home.packages = customScripts;
    };
}
