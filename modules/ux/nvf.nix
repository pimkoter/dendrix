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
      defaultEditor = true;
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
          extraConfig = ''
            require("catppuccin").setup({
              flavour = "mocha",
              transparent_background = true,
              integrations = {
                blink_cmp = true,
                gitsigns = true,
                indent_blankline = { enabled = true },
                neotree = true,
                noice = true,
                treesitter = true,
                which_key = true,
              }
            })
          '';
        };

        # --- SHARP CORNERS & GLOBAL UI OVERRIDES ---
        luaConfigRC.borders = ''
          -- Force built-in LSP floating windows to use sharp/single borders
          local _border = "single"

          vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(
            vim.lsp.handlers.hover, {
              border = _border
            }
          )

          vim.lsp.handlers["textDocument/signatureHelp"] = vim.lsp.with(
            vim.lsp.handlers.signatureHelp, {
              border = _border
            }
          )

          vim.diagnostic.config({
            float = { border = _border },
          })
        '';

        # --- PLUGINS & LSP CONFIGURATION ---
        # Fixed: we removed top-level `visuals.enable` and configured submodules directly
        visuals = {
          nvim-web-devicons.enable = true;
          indent-blankline.enable = true; # Fixed: Corrected option name for newer NVF
        };

        tabline = {
          nvimBufferline = {
            enable = true;
            setupOpts.options = {
              diagnostics = "nvim_lsp";
              separator_style = "thin";
              offsets = [
                {
                  filetype = "neo-tree";
                  text = "File Explorer";
                  highlight = "Directory";
                  text_align = "left";
                }
              ];
            };
          };
        };

        ui = {
          noice = {
            enable = true;
            setupOpts = {
              lsp = {
                override = {
                  "vim.lsp.util.convert_markdown_to_lines" = true;
                  "vim.lsp.util.stylize_markdown" = true;
                  "cmp.entry.get_documentation" = true;
                };
              };
              presets = {
                bottom_search = true;
                command_palette = true;
                long_message_to_split = true;
              };
              views = {
                cmdline_popup = {
                  border = {
                    style = "single";
                  };
                };
                hover = {
                  border = {
                    style = "single";
                  };
                };
              };
            };
          };
        };

        filetree.neo-tree = {
          enable = true;
          setupOpts = {
            window = {
              width = 30;
              position = "left";
            };
            filesystem = {
              filtered_items = {
                visible = false;
                hide_dotfiles = false;
                hide_gitignored = true;
                hide_by_name = [
                  ".git"
                  ".DS_Store"
                  "thumbs.db"
                ];
              };
            };
          };
        };

        binds.whichKey.enable = true;
        git.gitsigns.enable = true;
        autopairs.nvim-autopairs.enable = true;
        comments.comment-nvim.enable = true;

        autocomplete.blink-cmp = {
          enable = true;
          setupOpts = {
            completion = {
              menu = {
                border = "single";
              };
              documentation = {
                window = {
                  border = "single";
                };
              };
            };
          };
        };

        fzf-lua = {
          enable = true;
          setupOpts = {
            winopts = {
              height = 0.85;
              width = 0.80;
              row = 0.35;
              col = 0.5;
              border = "single";
              preview = {
                layout = "vertical";
                border = "single";
              };
            };
          };
        };

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
