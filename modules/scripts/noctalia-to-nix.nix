{
  perSystem =
    { pkgs, ... }:
    {
      packages.noctalia-to-nix = pkgs.writeShellApplication {
        name = "noctalia-to-nix";

        runtimeInputs = with pkgs; [
          jq
          nixfmt
        ];

        text = ''
          set -euo pipefail

          INPUT="''${1:-$HOME/.config/noctalia/settings.json}"
          OUTPUT="''${2:-/tmp/noctalia.nix}"

          if [[ ! -f "$INPUT" ]]; then
            echo "error: file not found: $INPUT" >&2
            exit 1
          fi

          if ! jq empty "$INPUT" >/dev/null 2>&1; then
            echo "error: invalid JSON: $INPUT" >&2
            exit 1
          fi

          mkdir -p "$(dirname "$OUTPUT")"

          # Convert the JSON file into a Nix-compatible quoted string.
          json="$(jq -Rs . < "$INPUT")"

          cat > "$OUTPUT" <<EOF
          {
            inputs,
            ...
          }:
          {
            flake.homeModules.noctalia = {
              imports = [ inputs.noctalia.homeModules.default ];

              home.file.".config/noctalia/settings.json".text =
                builtins.toJSON (
                  builtins.fromJSON $json
                );
            };
          }
          EOF

          nixfmt "$OUTPUT"

          echo
          echo "Generated and formatted:"
          echo "  $OUTPUT"
        '';
      };
    };
}
