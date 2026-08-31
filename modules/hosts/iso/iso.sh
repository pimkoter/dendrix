#!/usr/bin/env bash
set -euo pipefail

nix build .#nixosConfigurations.iso.config.system.build.isoImage
cp result/iso/* .
rm result
