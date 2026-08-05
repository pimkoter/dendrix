{ inputs, ... }:
{
  flake.homeModules.nvf =
    {
      pkgs,
      lib,
      ...
    }:
    {
      imports = [ inputs.nvf.homeManagerModules.default ];
      programs.nvf = {
        enable = true;
        settings.vim = {

          # --- Additional packages ---
          startPlugins = with pkgs.vimPlugins; [
            harpoon2
            plenary-nvim
          ];

          # --- Clipboard settings ---
          clipboard = {
            enable = true;
            registers = "unnamedplus";
          };
          options = {
            number = true;
            relativenumber = true;
            scrolloff = 999;

            expandtab = true;
            shiftwidth = 2;
            tabstop = 2;
            softtabstop = 2;

            autoindent = true;
            smartindent = true;

            undofile = true;

            signcolumn = "yes";
            wrap = false;
            cmdheight = 0;
            ignorecase = true;
            smartcase = true;
          };

          # --- Plugins ---
          telescope = {
            enable = true;
          };

          # Have Telescope automatically use the nearest .git for root of fuzzyfinder, else use current directory
          luaConfigRC = {
            telescope = ''
              local telescope = require("telescope.builtin")

              local function find_files()
                local root = vim.fs.root(0, { ".git" })
                telescope.find_files({
                  cwd = root or vim.fn.getcwd(),
                })
              end

              vim.keymap.set("n", "<leader>ff", find_files, {
                desc = "Find files",
              })
            '';
          };

          autocomplete.blink-cmp = {
            enable = true;
          };

          lsp = {
            enable = true;
            formatOnSave = true;
          };

          languages = {
            enableFormat = true;
            enableTreesitter = true;
            nix = {
              enable = true;
              format.type = [ "nixfmt" ];
            };
            python.enable = true;
            clang.enable = true;
            rust.enable = true;
          };

          git = {
            gitsigns.enable = true;
            neogit = {
              enable = true;

              setupOpts = {
                disable_commit_confirmation = true;

                integrations = {
                  telescope = true;
                };

                kind = "split";

                commit_popup = {
                  kind = "split";
                };
              };
            };
          };

          # Make gh behave like a toggle for "diffthis"
          luaConfigRC.gitsigns = ''
            vim.keymap.set("n", "<leader>gh", function()
              if vim.wo.diff then
                vim.cmd("diffoff!")
                vim.cmd("only")
              else
                vim.cmd("Gitsigns diffthis")
              end
            end, { silent = true })
          '';

          utility.oil-nvim.enable = true;

          # Enable harpoon and configure settings
          luaConfigRC.harpoon = ''
            local harpoon = require("harpoon")

            harpoon:setup({
              settings = {
                save_on_toggle = true,
                save_on_change = true,
                mark_branch = true,
              },
            })

            pcall(vim.keymap.del, "n", "<C-w>d")
            pcall(vim.keymap.del, "n", "<C-w><C-d>")
          '';

          # --- Hotkeys ---
          globals.mapleader = " ";
          keymaps = [
            # --- WINDOW NAVIGATION ---
            {
              key = "<C-h>";
              mode = "n";
              action = "<C-w>h";
              desc = "Move to left window";
              silent = true;
            }
            {
              key = "<C-j>";
              mode = "n";
              action = "<C-w>j";
              desc = "Move to lower window";
              silent = true;
            }
            {
              key = "<C-k>";
              mode = "n";
              action = "<C-w>k";
              desc = "Move to upper window";
              silent = true;
            }
            {
              key = "<C-l>";
              mode = "n";
              action = "<C-w>l";
              desc = "Move to right window";
              silent = true;
            }

            # --- UNDO ---
            {
              key = "<leader>u";
              mode = "n";
              action = "<cmd>packadd nvim.undotree | lua require('undotree').open()<CR>";
              desc = "Undo tree";
              silent = true;
            }

            # --- TELESCOPE ---
            {
              key = "<leader>fg";
              mode = "n";
              action = "<cmd>Telescope live_grep<CR>";
              desc = "Live grep";
              silent = true;
            }
            {
              key = "<leader>fr";
              mode = "n";
              action = "<cmd>Telescope oldFiles<CR>";
              desc = "Recent files";
              silent = true;
            }
            {
              key = "<leader>fd";
              mode = "n";
              action = "<cmd>Telescope diagnostics<CR>";
              desc = "Diagnostics";
              silent = true;
            }
            {
              key = "<leader>fs";
              mode = "n";
              action = "<cmd>Telescope lsp_document_symbols<CR>";
              desc = "Document symbols";
              silent = true;
            }
            {
              key = "<leader>fS";
              mode = "n";
              action = "<cmd>Telescope lsp_dynamic_workspace_symbols<CR>";
              desc = "Workspace symbols";
              silent = true;
            }

            # --- OIL ---
            {
              key = "<leader>cd";
              mode = "n";
              action = "<cmd>Oil<CR>";
              desc = "Open file explorer";
              silent = true;
            }

            # --- HARPOON ---
            {
              key = "<leader>ha";
              mode = "n";
              action = "<cmd>lua require('harpoon'):list():add()<CR>";
              desc = "Harpoon add file";
              silent = true;
            }
            {
              key = "<leader>hh";
              mode = "n";
              action = "<cmd>lua require('harpoon').ui:toggle_quick_menu(require('harpoon'):list())<CR>";
              desc = "Harpoon menu";
              silent = true;
            }
            {
              key = "<C-s>";
              mode = "n";
              action = "<cmd>lua require('harpoon'):list():prev()<CR>";
              desc = "Harpoon previous";
              silent = true;
            }
            {
              key = "<C-d>";
              mode = "n";
              action = "<cmd>lua require('harpoon'):list():next()<CR>";
              desc = "Harpoon next";
              silent = true;
            }
            {
              key = "<C-q>";
              mode = "n";
              action = "<cmd>lua require('harpoon'):list():select(1)<CR>";
              desc = "Harpoon file 1";
              silent = true;
            }
            {
              key = "<C-w>";
              mode = "n";
              action = "<cmd>lua require('harpoon'):list():select(2)<CR>";
              desc = "Harpoon file 2";
              silent = true;
            }
            {
              key = "<C-e>";
              mode = "n";
              action = "<cmd>lua require('harpoon'):list():select(3)<CR>";
              desc = "Harpoon file 3";
              silent = true;
            }
            {
              key = "<C-r>";
              mode = "n";
              action = "<cmd>lua require('harpoon'):list():select(4)<CR>";
              desc = "Harpoon file 4";
              silent = true;
            }
            {
              key = "<C-r>";
              mode = "n";
              action = "<cmd>lua require('harpoon'):list():select(4)<CR>";
              desc = "Harpoon file 4";
              silent = true;
            }

            # --- LSP ---
            {
              key = "gd";
              mode = "n";
              action = "<cmd>lua vim.lsp.buf.definition()<CR>";
              desc = "Go to definition";
              silent = true;
            }
            {
              key = "gr";
              mode = "n";
              action = "<cmd>lua vim.lsp.buf.references()<CR>";
              desc = "Find references";
              silent = true;
            }
            {
              key = "K";
              mode = "n";
              action = "<cmd>lua vim.lsp.buf.hover()<CR>";
              desc = "Show documentation";
              silent = true;
            }
            {
              key = "<leader>dn";
              mode = "n";
              action = "<cmd>lua vim.diagnostic.jump({ count = 1, float = true })<CR>";
              desc = "Next diagnostic";
              silent = true;
            }
            {
              key = "<leader>dp";
              mode = "n";
              action = "<cmd>lua vim.diagnostic.jump({ count = -1, float = true })<CR>";
              desc = "Previous diagnostic";
              silent = true;
            }
            # --- Code Actions ---
            {
              key = "<leader>la";
              mode = "n";
              action = "<cmd>lua vim.lsp.buf.code_action()<CR>";
              desc = "Code actions";
              silent = true;
            }
            {
              key = "<leader>lr";
              mode = "n";
              action = "<cmd>lua vim.lsp.buf.rename()<CR>";
              desc = "Rename symbol";
              silent = true;
            }
            {
              key = "<leader>li";
              mode = "n";
              action = "<cmd>lua vim.lsp.buf.implementation()<CR>";
              desc = "Go to implementation";
              silent = true;
            }
            {
              key = "<leader>lt";
              mode = "n";
              action = "<cmd>lua vim.lsp.buf.type_definition()<CR>";
              desc = "Go to type definition";
              silent = true;
            }

            # --- GIT ---
            {
              key = "<leader>gn";
              mode = "n";
              action = "<cmd>Gitsigns next_hunk<CR>";
              desc = "Next hunk";
              silent = true;
            }
            {
              key = "<leader>gp";
              mode = "n";
              action = "<cmd>Gitsigns prev_hunk<CR>";
              desc = "Previous hunk";
              silent = true;
            }
            {
              key = "<leader>gs";
              mode = "n";
              action = "<cmd>Gitsigns stage_hunk<CR>";
              desc = "Stage hunk";
              silent = true;
            }
            {
              key = "<leader>gr";
              mode = "n";
              action = "<cmd>Gitsigns reset_hunk<CR>";
              desc = "Reset hunk";
              silent = true;
            }
            {
              key = "<leader>gl";
              mode = "n";
              action = "<cmd>Gitsigns blame_line<CR>";
              desc = "Blame line";
              silent = true;
            }
            {
              key = "<leader>gg";
              mode = "n";
              action = "<cmd>Neogit<CR>";
              desc = "Open Neogit";
              silent = true;
            }
            {
              key = "<leader>gc";
              mode = "n";
              action = "<cmd>Neogit commit<CR>";
              desc = "Commit staged changes";
              silent = true;
            }
          ];

          binds.whichKey = {
            enable = true;

            setupOpts = {
              plugins = {
                presets = {
                  operators = false;
                  motions = false;
                  text_objects = false;
                  windows = false;
                  nav = false;
                  z = false;
                  g = false;
                };
              };
            };
          };

          # --- Theme ---
          theme = {
            enable = true;
            name = lib.mkForce "catppuccin";
            style = lib.mkForce "mocha";
            transparent = lib.mkForce true;
          };

          luaConfigRC.floats = ''
            vim.api.nvim_set_hl(0, "NormalFloat", {
              bg = "#1e1e2e",
            })

            vim.api.nvim_set_hl(0, "FloatBorder", {
              bg = "#1e1e2e",
            })
          '';

          # --- Dashboard
          dashboard.dashboard-nvim = {
            enable = true;

            setupOpts = {
              theme = "hyper";

              config = {
                header = [
                  ""
                  "        ███╗   ██╗██╗   ██╗██╗███╗   ███╗"
                  "        ████╗  ██║██║   ██║██║████╗ ████║"
                  "        ██╔██╗ ██║██║   ██║██║██╔████╔██║"
                  "        ██║╚██╗██║╚██╗ ██╔╝██║██║╚██╔╝██║"
                  "        ██║ ╚████║ ╚████╔╝ ██║██║ ╚═╝ ██║"
                  "        ╚═╝  ╚═══╝  ╚═══╝  ╚═╝╚═╝     ╚═╝"
                  ""
                ];

                shortcut = [
                  {
                    desc = "Find file";
                    group = "Telescope";
                    key = "f";
                    action = "Telescope find_files";
                  }
                  {
                    desc = "Recent files";
                    group = "Telescope";
                    key = "r";
                    action = "Telescope oldfiles";
                  }
                  {
                    desc = "Live grep";
                    group = "Telescope";
                    key = "g";
                    action = "Telescope live_grep";
                  }
                  {
                    desc = "File explorer";
                    group = "Oil";
                  }
                  {
                    desc = "Git";
                    group = "Neogit";
                    key = "G";
                    action = "Neogit";
                  }
                  {
                    desc = "Quit";
                    group = "Neovim";
                    key = "q";
                    action = "qa";
                  }
                ];
              };
            };
          };
        };
      };
    };
}
