{
  flake.homeModules.nvf = {
    inputs,
    lib,
    pkgs,
    config,
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
          cmdheight = 0;
          scrolloff = 999;
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
            action = "<cmd>Neotree filesystem reveal left<CR>";
            silent = true;
          }
          {
            key = "<leader>fw";
            mode = "n";
            action = "<cmd>FzfLua grep_cword<CR>";
            silent = true;
          }
          {
            key = "<leader>fr>";
            mode = "n";
            action = "<cmd>FzfLua resume<CR>";
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

        # --- THEMING ---
        theme = {
          enable = true;
          name = lib.mkForce "catppuccin";
          style = lib.mkForce "mocha";
          transparent = lib.mkForce true;
        };

        # --- PLUGINS & LSP CONFIGURATION ---
        filetree.neo-tree.enable = true;
        binds.whichKey.enable = true;
        git.gitsigns.enable = true;
        autopairs.nvim-autopairs.enable = true;
        comments.comment-nvim.enable = true;
        autocomplete.blink-cmp.enable = true;
        fzf-lua.enable = true;
        lsp = {
          enable = true;
          formatOnSave = true;
        };
        languages = {
          enableFormat = true;
          enableTreesitter = true;
          nix.enable = true;
          clang.enable = true;
          python.enable = true;
          rust.enable = true;
          bash.enable = true;
          lua.enable = true;
        };
        statusline.lualine = {
          enable = true;
          setupOpts = {
            options = {
              # We feed your global stylix base16 color mapping directly into lualine!
              theme = {
                normal = {
                  a = {
                    fg = config.lib.stylix.colors.withHashtag.base00;
                    bg = config.lib.stylix.colors.withHashtag.base0D;
                    bold = true;
                  };
                  b = {
                    fg = config.lib.stylix.colors.withHashtag.base05;
                    bg = config.lib.stylix.colors.withHashtag.base02;
                  };
                  c = {
                    fg = config.lib.stylix.colors.withHashtag.base05;
                    bg = config.lib.stylix.colors.withHashtag.base01;
                  };
                };
                insert = {
                  a = {
                    fg = config.lib.stylix.colors.withHashtag.base00;
                    bg = config.lib.stylix.colors.withHashtag.base0B;
                    bold = true;
                  };
                };
                visual = {
                  a = {
                    fg = config.lib.stylix.colors.withHashtag.base00;
                    bg = config.lib.stylix.colors.withHashtag.base0E;
                    bold = true;
                  };
                };
                replace = {
                  a = {
                    fg = config.lib.stylix.colors.withHashtag.base00;
                    bg = config.lib.stylix.colors.withHashtag.base08;
                    bold = true;
                  };
                };
                inactive = {
                  a = {
                    fg = config.lib.stylix.colors.withHashtag.base03;
                    bg = config.lib.stylix.colors.withHashtag.base01;
                  };
                  b = {
                    fg = config.lib.stylix.colors.withHashtag.base03;
                    bg = config.lib.stylix.colors.withHashtag.base01;
                  };
                  c = {
                    fg = config.lib.stylix.colors.withHashtag.base03;
                    bg = config.lib.stylix.colors.withHashtag.base01;
                  };
                };
              };
              section_separators = "";
              component_separators = "";
              icons_enabled = true;
            };
            sections = {
              lualine_a = ["mode"];
              lualine_b = ["branch" "diagnostics"];
              lualine_c = ["filename"];
              lualine_x = ["filetype"];
              lualine_y = ["progress"];
              lualine_z = ["location"];
            };
          };
        };
        extraPlugins = with pkgs.vimPlugins; {
          vim-tpipeline = {
            package = vim-tpipeline;
          };
        };
      };
    };
  };
}
