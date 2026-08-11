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
        defaultEditor = true;
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

          autopairs.nvim-autopairs.enable = true;
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

          # --- Terminal ---
          luaConfigRC.terminal = ''
            -- ==============================================================
            -- Floating tmux terminal
            --
            -- <leader>t → open terminal
            -- <Esc>     → close floating window
            --
            -- The terminal connects to a persistent tmux session named
            -- "neovim".
            --
            -- Closing the floating window does NOT terminate tmux.
            -- Running "exit" DOES terminate tmux and causes the terminal
            -- state to be reset so the next <leader>t starts fresh.
            -- ==============================================================

            local terminal = {
              buf = nil,
              win = nil,
              job = nil,
            }

            -- --------------------------------------------------------------
            -- Helpers
            -- --------------------------------------------------------------

            local function is_window_open()
              return terminal.win
                and vim.api.nvim_win_is_valid(terminal.win)
            end

            local function is_terminal_running()
              if not terminal.job then
                return false
              end

              -- jobwait() returns:
              --   -1 → still running
              --   >=0 → process has exited
              local result = vim.fn.jobwait({ terminal.job }, 0)[1]

              return result == -1
            end

            local function reset_terminal()
              terminal.job = nil
              terminal.buf = nil
              terminal.win = nil
            end

            -- --------------------------------------------------------------
            -- Close floating window
            -- --------------------------------------------------------------

            local function close_terminal()
              if is_window_open() then
                vim.api.nvim_win_close(terminal.win, true)
              end

              terminal.win = nil
            end

            -- --------------------------------------------------------------
            -- Create floating window
            -- --------------------------------------------------------------

            local function create_window()
              local width = math.floor(vim.o.columns * 0.8)
              local height = math.floor(vim.o.lines * 0.7)

              local row = math.floor((vim.o.lines - height) / 2)
              local col = math.floor((vim.o.columns - width) / 2)

              terminal.win = vim.api.nvim_open_win(
                terminal.buf,
                true,
                {
                  relative = "editor",
                  width = width,
                  height = height,
                  row = row,
                  col = col,
                  border = "rounded",
                  style = "minimal",
                }
              )
            end

            -- --------------------------------------------------------------
            -- Start terminal
            -- --------------------------------------------------------------

            local function start_terminal()
              -- Always create a fresh buffer when starting a new terminal.
              terminal.buf = vim.api.nvim_create_buf(false, true)

              vim.api.nvim_buf_set_option(
                terminal.buf,
                "bufhidden",
                "hide"
              )

              create_window()

              -- Start tmux.
              --
              -- `new-session -A`:
              --   create the session if it doesn't exist
              --   otherwise attach to the existing session
              --
              -- `-s neovim`:
              --   use the persistent session named "neovim"
              terminal.job = vim.fn.termopen(
                "tmux new-session -A -s neovim",
                {
                  on_exit = function()
                    -- on_exit can happen while Neovim is processing another
                    -- event, so defer the cleanup safely.
                    vim.schedule(function()
                      -- The tmux session has ended, so this terminal can no
                      -- longer be reused.
                      if is_window_open() then
                        vim.api.nvim_win_close(terminal.win, true)
                      end

                      reset_terminal()
                    end)
                  end,
                }
              )

              vim.cmd("startinsert")
            end

            -- --------------------------------------------------------------
            -- Open terminal
            -- --------------------------------------------------------------

            local function open_terminal()
              -- If the terminal job is still running, simply reopen its window.
              if is_terminal_running() then
                if not is_window_open() then
                  create_window()
                end

                vim.cmd("startinsert")
                return
              end

              -- The previous terminal process has exited.
              --
              -- Clean up the old buffer before starting a new one.
              if terminal.buf and vim.api.nvim_buf_is_valid(terminal.buf) then
                vim.api.nvim_buf_delete(
                  terminal.buf,
                  { force = true }
                )
              end

              reset_terminal()

              start_terminal()
            end

            -- --------------------------------------------------------------
            -- Toggle
            -- --------------------------------------------------------------

            local function toggle_terminal()
              if is_window_open() then
                close_terminal()
              else
                open_terminal()
              end
            end

            -- --------------------------------------------------------------
            -- Keymaps
            -- --------------------------------------------------------------

            -- Normal mode:
            -- open/reopen the floating terminal.
            vim.keymap.set("n", "<leader>t", toggle_terminal, {
              desc = "Toggle terminal",
              silent = true,
            })

            -- Terminal mode:
            -- Escape closes only the floating window.
            --
            -- The tmux session remains alive, so processes continue running.
            vim.keymap.set("t", "<Esc>", close_terminal, {
              desc = "Close terminal",
              silent = true,
            })

            -- --------------------------------------------------------------
            -- Window lifecycle
            -- --------------------------------------------------------------

            vim.api.nvim_create_autocmd("WinClosed", {
              callback = function(args)
                if terminal.win
                  and tostring(terminal.win) == args.match
                then
                  terminal.win = nil
                end
              end,
            })
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
              key = "<C-x>";
              mode = "n";
              action = "<cmd>lua require('harpoon'):list():prev()<CR>";
              desc = "Harpoon previous";
              silent = true;
            }
            {
              key = "<C-c>";
              mode = "n";
              action = "<cmd>lua require('harpoon'):list():next()<CR>";
              desc = "Harpoon next";
              silent = true;
            }
            {
              key = "<leader>hq";
              mode = "n";
              action = "<cmd>lua require('harpoon'):list():select(1)<CR>";
              desc = "Harpoon file 1";
              silent = true;
            }
            {
              key = "<leader>hw";
              mode = "n";
              action = "<cmd>lua require('harpoon'):list():select(2)<CR>";
              desc = "Harpoon file 2";
              silent = true;
            }
            {
              key = "<leader>he";
              mode = "n";
              action = "<cmd>lua require('harpoon'):list():select(3)<CR>";
              desc = "Harpoon file 3";
              silent = true;
            }
            {
              key = "<leader>hr";
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
              key = "<C-k>";
              mode = "i";
              action = "<cmd>lua vim.lsp.buf.signature_help()<CR>";
              desc = "Show signature help";
              silent = true;
            }

            # -- Diagnostics ---
            {
              key = "<leader>do";
              mode = "n";
              action = "<cmd>lua vim.diagnostic.open_float()<CR>";
              desc = "Show diagnostic";
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
              key = "<leader>gh";
              mode = "n";
              action = "<cmd>Gitsigns preview_hunk<CR>";
              desc = "Preview hunk";
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
            # --- HOTKEYS ---
            {
              key = "<leader>y";
              mode = "n";
              action = "<cmd>%y+<CR>";
              desc = "Copy whole file";
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
            vim.o.winborder = "rounded"

            vim.api.nvim_set_hl(0, "NormalFloat", {
              bg = "#1e1e2e",
            })

            vim.api.nvim_set_hl(0, "FloatBorder", {
              fg = "#585b70",
              bg = "#1e1e2e",
            })

            vim.api.nvim_set_hl(0, "FloatTitle", {
              fg = "#cdd6f4",
              bg = "#1e1e2e",
              bold = true,
            })


            local original_hover = vim.lsp.handlers["textDocument/hover"]

            vim.lsp.handlers["textDocument/hover"] = function(
              err,
              result,
              ctx,
              config
            )
              config = config or {}

              config.border = "rounded"

              config.max_width = 100
              config.max_height = 30

              return original_hover(err, result, ctx, config)
            end
          '';

          luaConfigRC.diagnostics = ''
            vim.diagnostic.config({
              float = {
                border = "rounded",
                source = "if_many",
                header = "",
                prefix = "",
                max_width = 100,
                max_height = 20,
              },
            })
          '';

          # --- Dashboard ---
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
