{
  self,
  inputs,
  ...
}: {
  flake.homeModules.nvf = {
    inputs,
    lib,
    ...
  }: {
    imports = [inputs.nvf.homeManagerModules.default];
    programs.nvf = {
      enable = true;
      settings.vim = {
        # --- OPTIONS ---
        options = {
          number = true;
          relativenumber = true;
          expandtab = true;
          shiftwidth = 2;
          tabstop = 2;
          smartindent = true;
        };

        # --- CLIPBOARD CONFIGURATION ---
        clipboard = {
          enable = true;
          registers = "unnamedplus";
          providers = {
            wl-copy.enable = true;
            xsel.enable = true;
          };
        };

        # --- KEY MAPPINGS ---
        globals.mapleader = " ";
        keymaps = [
          {
            key = "<leader>cd";
            mode = "n";
            action = "<cmd>Ex<CR>";
            silent = true;
          }
          {
            key = "<leader>fw";
            mode = "n";
            action = "<cmd>FzfLua grep_cword";
            silent = true;
          }
          {
            key = "<leader>fr>";
            mode = "n";
            action = "<cmd>FzfLua resume";
            silent = true;
          }
          {
            key = "<leader>ff";
            mode = "n";
            action = "<cmd>FzfLua files<CR>";
            silent = true;
          }
          {
            key = "<leader>fo";
            mode = "n";
            action = "<cmd>FzfLua oldfiles<CR>";
            silent = true;
          }
          {
            key = "<leader>fb";
            mode = "n";
            action = "<cmd>FzfLua buffers<CR>";
            silent = true;
          }
          {
            key = "<leader>fg";
            mode = "n";
            action = "<cmd>FzfLua live_grep<CR>";
            silent = true;
          }
          {
            key = "gd";
            mode = "n";
            action = "<cmd>lua vim.lsp.buf.definition()<CR>";
            silent = true;
          }
          {
            key = "gr";
            mode = "n";
            action = "<cmd>lua vim.lsp.buf.references()<CR>";
            silent = true;
          }
          {
            key = "K";
            mode = "n";
            action = "<cmd>lua vim.lsp.buf.hover()<CR>";
            silent = true;
          }
          {
            key = "gl";
            mode = "n";
            action = "<cmd>lua vim.diagnostic.open_float()<CR>";
            silent = true;
          }
          {
            key = "<leader>nd";
            mode = "n";
            action = "<cmd>lua vim.diagnostic.goto_next()<CR>";
            silent = true;
          }
          {
            key = "<leader>pd";
            mode = "n";
            action = "<cmd>lua vim.diagnostic.goto_prev()<CR>";
            silent = true;
          }
        ];
        # --- AI INTEGRATION ---

        # --- THEMING ---
        theme = {
          enable = true;
          name = lib.mkForce "catppuccin";
          style = lib.mkForce "auto";
        };

        # --- PLUGINS & LSP CONFIGURATION ---
        lsp = {
          enable = true;
          formatOnSave = true;
        };
        binds.whichKey.enable = true;
        git.gitsigns.enable = true;
        autopairs.nvim-autopairs.enable = true;
        comments.comment-nvim.enable = true;
        autocomplete.blink-cmp.enable = true;
        languages = {
          enableFormat = true;
          enableTreesitter = true;
          nix.enable = true;
          typescript.enable = true;
          python.enable = true;
        };
        fzf-lua.enable = true;
        statusline.lualine = {
          enable = true;
        };
      };
    };
  };
}
