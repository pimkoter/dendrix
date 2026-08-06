#!/usr/bin/env bash
nix build .#nixosConfigurations.iso.config.system.build.isoImage
cp result/iso/* .
rm result
