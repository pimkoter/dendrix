{
  perSystem = { pkgs, ... }: {

    packages.clone-repos = pkgs.writeShellApplication {
      name = "clone-repos";

      runtimeInputs = with pkgs; [
        gh
        git
        coreutils
      ];

      text = ''
        echo "Fetching repository list from GitHub..."

        repos="$(
          gh repo list \
            --limit 1000 \
            --json sshUrl,isArchived \
            --jq '.[] | select(.isArchived == false) | .sshUrl'
        )"

        if [ -z "$repos" ]; then
          echo "No repositories found or failed to fetch list."
          exit 1
        fi

        while IFS= read -r repo; do
          echo "----------------------------------------"

          repo_name="$(basename "$repo" .git)"

          if [ -d "$repo_name" ]; then
            echo "Directory $repo_name already exists. Pulling latest changes..."
            git -C "$repo_name" pull
          else
            echo "Cloning $repo..."
            git clone "$repo"
          fi
        done <<< "$repos"

        echo "----------------------------------------"
        echo "All done! Repositories were downloaded!"
      '';
    };
  };
}
