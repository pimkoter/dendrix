{
  flake.homeModules.clone-repo =
    { pkgs, ... }:
    let
      githubUser = "pimkoter";
      clone-repo = pkgs.writeShellScriptBin "clone-repo" ''
        set -euo pipefail

        repo_dir="$HOME/Repos"
        mkdir -p "$repo_dir"

        ${pkgs.curl}/bin/curl -fsSL \
          "https://api.github.com/users/${githubUser}/repos?per_page=100" |
          ${pkgs.jq}/bin/jq -r '.[].clone_url' |
          while read -r url; do
            repo_name="$(${pkgs.coreutils}/bin/basename "$url" .git)"
            target="$repo_dir/$repo_name"

            if [ -d "$target/.git" ]; then
              echo "Already exists: $repo_name"
            else
              echo "Cloning: $url"
              ${pkgs.git}/bin/git clone "$url" "$target"
            fi
          done
      '';
    in
    {
      home.packages = [ clone-repo ];

      systemd.user.services.clone-repo = {
        Unit = {
          Description = "Clone all ${githubUser} GitHub repositories";
          After = [ "network-online.target" ];
          Wants = [ "network-online.target" ];
        };

        Service = {
          Type = "oneshot";
          ExecStart = "${clone-repo}/bin/clone-repo";
        };
      };
    };
}
