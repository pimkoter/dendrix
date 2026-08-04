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
            neogit.enable = true;
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
          # Opens oil at the root of the project
          luaConfigRC.projectRoot = ''
            vim.keymap.set("n", "<leader>md", function()
              local root = vim.fs.root(0, { ".git" })

              if root then
                vim.api.nvim_set_current_dir(root)
                vim.notify("Project root: " .. root)
              else
                vim.notify("No Git root found", vim.log.levels.WARN)
              end
            end, {
              desc = "Change to project root",
              silent = true,
            })
          '';

          # --- Hotkeys ---
          globals.mapleader = " ";
          keymaps = [
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
              key = "<leader>nd";
              mode = "n";
              action = "<cmd>lua vim.diagnostic.jump({ count = 1, float = true })<CR>";
              desc = "Next diagnostic";
              silent = true;
            }
            {
              key = "<leader>pd";
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
        };
      };
    };
}
