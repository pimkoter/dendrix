{
  perSystem = { pkgs, ... }: {
    packages.noctalia-to-nix = pkgs.writeShellApplication {
      name = "noctalia-to-nix";

      runtimeInputs = with pkgs; [
        nix
        nixfmt
        coreutils
      ];

      text = ''
        set -euo pipefail

        INPUT="''${1:-$HOME/.config/noctalia/config.toml}"
        OUTPUT="''${2:-/tmp/noctalia.nix}"

        if [[ ! -f "$INPUT" ]]; then
          echo "error: file not found: $INPUT" >&2
          exit 1
        fi

        mkdir -p "$(dirname "$OUTPUT")"

        # Validate TOML and convert it to JSON.
        if ! nix-instantiate --eval --strict --json --expr \
          'builtins.fromTOML (builtins.readFile (builtins.toPath (builtins.getEnv "INPUT_FILE")))' \
          --argstr unused "" \
          >/dev/null 2>&1; then
          :
        fi

        if ! nix-instantiate --eval --strict --json --expr \
          "builtins.fromTOML (builtins.readFile \"$INPUT\")" \
          > /dev/null 2>&1; then
          echo "error: invalid TOML: $INPUT" >&2
          exit 1
        fi

        # Serialize the parsed TOML as JSON.
        JSON="$(nix-instantiate --eval --strict --json --expr \
          "builtins.toJSON (builtins.fromTOML (builtins.readFile \"$INPUT\"))")"

        # Write the settings JSON to a temporary file.
        JSON_FILE="$(mktemp)"
        trap 'rm -f "$JSON_FILE"' EXIT
        printf '%s\n' "$JSON" > "$JSON_FILE"

        # Generate a Nix module that reads the JSON file.
        cat > "$OUTPUT" <<EOF
        {
          inputs,
          ...
        }:
        {
          flake.homeModules.noctalia = {
            imports = [ inputs.noctalia.homeModules.default ];

            programs.noctalia = {
              enable = true;
              settings = builtins.fromJSON (builtins.readFile "$JSON_FILE");
            };
          };
        }
        EOF

        nixfmt "$OUTPUT"

        echo
        echo "Generated and formatted:"
        echo "  $OUTPUT"
        echo
        echo "Note: the generated module references the temporary JSON file:"
        echo "  $JSON_FILE"
      '';
    };
  };
}
