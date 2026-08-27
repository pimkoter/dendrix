{
  perSystem = { pkgs, ... }: {

    packages.noctalia-to-nix = pkgs.writeShellApplication {
      name = "noctalia-to-nix";

      runtimeInputs = with pkgs; [
        jq
        nixfmt
        python3
        gnused
        coreutils
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

            is_nix_identifier() {
              [[ "$1" =~ ^[A-Za-z_][A-Za-z0-9_\'-]*$ ]]
            }

            nix_string() {
              local value="$1"

              python3 - "$value" <<'PY'
        import json
        import sys

        value = sys.argv[1]
        print(json.dumps(value, ensure_ascii=False))
        PY
            }

            remove_blank_lines() {
              sed -i '/^[[:space:]]*$/d' "$1"
            }

            json_to_nix() {
              local json="$1"
              local indent="$2"
              local type

              type="$(jq -r 'type' <<< "$json")"

              case "$type" in
                object)
                  local length
                  length="$(jq 'length' <<< "$json")"

                  if [[ "$length" -eq 0 ]]; then
                    printf '{}'
                    return
                  fi

                  printf '{\n'

                  jq -c 'to_entries[]' <<< "$json" |
                  while IFS= read -r entry; do
                    local key
                    local value

                    key="$(jq -r '.key' <<< "$entry")"
                    value="$(jq -c '.value' <<< "$entry")"

                    printf '%s' "$indent"

                    if is_nix_identifier "$key"; then
                      printf '%s' "$key"
                    else
                      printf '%s' "$(nix_string "$key")"
                    fi

                    printf ' = '

                    json_to_nix "$value" "''${indent}  "

                    printf ';\n'
                  done

                  printf '%s}' "''${indent::-2}"
                  ;;

                array)
                  local length
                  length="$(jq 'length' <<< "$json")"

                  if [[ "$length" -eq 0 ]]; then
                    printf '[ ]'
                    return
                  fi

                  printf '[\n'

                  jq -c '.[]' <<< "$json" |
                  while IFS= read -r value; do
                    printf '%s' "$indent"
                    json_to_nix "$value" "''${indent}  "
                    printf '\n'
                  done

                  printf '%s]' "''${indent::-2}"
                  ;;

                string)
                  nix_string "$(jq -r '.' <<< "$json")"
                  ;;

                number)
                  jq -c '.' <<< "$json"
                  ;;

                boolean)
                  if [[ "$(jq -r '.' <<< "$json")" == "true" ]]; then
                    printf 'true'
                  else
                    printf 'false'
                  fi
                  ;;

                null)
                  printf 'null'
                  ;;

                *)
                  echo "error: unsupported JSON type: $type" >&2
                  exit 1
                  ;;
              esac
            }

            echo "Reading:  $INPUT"
            echo "Writing:  $OUTPUT"

            mkdir -p "$(dirname "$OUTPUT")"

            {
              cat <<'EOF'
            {
              inputs,
              ...
            }:
            {
              flake.homeModules.noctalia = { lib, ... }: {
                imports = [ inputs.noctalia.homeModules.default ];
                home.file.".config/noctalia/settings.json" = {
                  text = builtins.toJSON
            EOF

              json_to_nix "$(cat "$INPUT")" "        "

              cat <<'EOF'
            ;
                };
              };
            }
            EOF
            } > "$OUTPUT"

            remove_blank_lines "$OUTPUT"
            nixfmt "$OUTPUT"

            echo
            echo "Generated and formatted:"
            echo "  $OUTPUT"
      '';
    };
  };
}
