1. Generate SSH key with ssh-keygen -t ed25519
2. RUN "nix run nixpkgs#ssh-to-age -- -private-key -i ~/.ssh/id_ed25519 > ~/.config/sops/age/keys.txt"

