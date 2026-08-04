#!/usr/bin/env bash
nix build .#nixosConfigurations.iso.config.system.build.isoImage
cp result/iso/nixos-26.11.20260729.0954f7e-x86_64-linux.iso .
rm result
