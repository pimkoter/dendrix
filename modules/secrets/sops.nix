{ inputs, ... }: {
  flake.nixosModules.sops = {
    imports = [ inputs.sops-nix.nixosModules.sops ];

    sops = {
      defaultSopsFile = ./secrets.yaml;
      age = {
        sshKeyPaths = [ "/etc/ssh/ssh_host_ed25519_key" ];
        keyFile = "/var/lib/sops-nix/key.txt";
        generateKey = true;
      };

      secrets = {
        "passwords/pim".neededForUsers = true;
        "private_keys/pim" = {
          path = "/home/pim/.ssh/id_ed25519";
          owner = "pim";
          group = "users";
          mode = "0600";
        };
      };
    };
  };
}
