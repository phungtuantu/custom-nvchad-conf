local overrides = require("custom.configs.overrides")

---@type NvPluginSpec[]
local plugins = {

  -- Override plugin definition options

  {
    "neovim/nvim-lspconfig",
    dependencies = {
      -- format & linting
      {
        "jose-elias-alvarez/null-ls.nvim",
        config = function()
          require "custom.configs.null-ls"
        end,
      },
    },
    config = function()
      require "plugins.configs.lspconfig"
      require "custom.configs.lspconfig"
      -- local on_attach = function(client, bufnr)
      --   require "core.utils".load_mappings("lspconfig", { buffer = bufnr })
      --   client.server_capabilities.documentFormattingProvider = false
      --   client.server_capabilities.documentRangeFormattingProvider = false
      -- end
      -- local capabilities = vim.lsp.protocol.make_client_capabilities()
      -- require("lspconfig").pylsp.setup {
      --   on_attach = on_attach,
      --   capabilities = capabilities,
      -- }

    end, -- Override to setup mason-lspconfig
  },

  {
    'mhartington/formatter.nvim',
    config = function()
      local util = require "formatter.util"
      require("formatter").setup {
        -- Enable or disable logging
        logging = true,
        -- Set the log level
        log_level = vim.log.levels.WARN,
        -- All formatter configurations are opt-in
        filetype = {
          python = {

            -- You can also define your own configuration
            function()
              return {
                  exe = "black",
                  args = { "-q", "-" },
                  stdin = true,
                }
            end
          },
        }
      }
    end
  },

  -- override plugin configs
  {
    "williamboman/mason.nvim",
    opts = overrides.mason
  },

  {
    "nvim-treesitter/nvim-treesitter",
    opts = overrides.treesitter,
  },

  {
    "nvim-tree/nvim-tree.lua",
    opts = overrides.nvimtree,
  },

  {
    "hrsh7th/nvim-cmp",
    dependencies = {
      {
        -- snippet plugin
        "L3MON4D3/LuaSnip",
        dependencies = "rafamadriz/friendly-snippets",
        opts = { history = true, updateevents = "TextChanged,TextChangedI" },
        config = function(_, opts)
          require("plugins.configs.others").luasnip(opts)
        end,
      },

      -- autopairing of (){}[] etc
      {
        "windwp/nvim-autopairs",
        opts = {
          fast_wrap = {},
          disable_filetype = { "TelescopePrompt", "vim" },
        },
        config = function(_, opts)
          require("nvim-autopairs").setup(opts)

          -- setup cmp for autopairs
          local cmp_autopairs = require "nvim-autopairs.completion.cmp"
          require("cmp").event:on("confirm_done", cmp_autopairs.on_confirm_done())
        end,
      },

      -- cmp sources plugins
      {
        "saadparwaiz1/cmp_luasnip",
        "hrsh7th/cmp-nvim-lua",
        "hrsh7th/cmp-nvim-lsp",
        "hrsh7th/cmp-buffer",
        "hrsh7th/cmp-path",
      },

      {
        "zbirenbaum/copilot-cmp",
        after = "copilot.lua",
        config = function ()
          require("copilot_cmp").setup()
        end
      },

      {
        "zbirenbaum/copilot.lua",
        cmd = "Copilot",
        event = "InsertEnter",
        config = function()
          local opts = {
                          suggestion = { enabled = false},
                          panel = { enabled = false },
                          filetypes = {
                            markdown = true,
                            help = true,
                          },
                          keymap = {
                            accept = "<M-l>",
                            accept_word = false,
                            accept_line = false,
                            next = "<M-]>",
                            prev = "<M-[>",
                            dismiss = "<C-]>",
                          },
                        }
          require("core.utils").load_mappings("copilot")
          require("copilot").setup(opts)
        end,
       },
    },
    opts = overrides.cmp,
  },

  -- Install a plugin
  {
    "max397574/better-escape.nvim",
    event = "InsertEnter",
    config = function()
      require("better_escape").setup()
    end,
  },

  {
    "lewis6991/gitsigns.nvim",
    config = function()
      require("custom.configs.gitsigns")
    end
  },

  {
    "mfussenegger/nvim-dap",
    after = "coq_nvim",
    event = "InsertEnter",
    config = function()
      require("core.utils").load_mappings("nvimdap")
      require"custom.configs.dap"
    end,
    requires = {
      "Pocco81/DAPInstall.nvim",
      "mfussenegger/nvim-dap-python",
    },
  },

  {
    "rcarriga/nvim-dap-ui",
    after = "nvim-dap",
    cmd = "Toggle",
    config = function()
      require("dapui").setup()
    end,
  },

  {
    "scalameta/nvim-metals",
    dependencies = {
      "nvim-lua/plenary.nvim",
      {
        "mfussenegger/nvim-dap",
        config = function(self, opts)
          -- Debug settings if you're using nvim-dap
          local dap = require("dap")

          dap.configurations.scala = {
            {
              type = "scala",
              request = "launch",
              name = "RunOrTest",
              metals = {
                runType = "runOrTestFile",
                --args = { "firstArg", "secondArg", "thirdArg" }, -- here just as an example
              },
            },
            {
              type = "scala",
              request = "launch",
              name = "Test Target",
              metals = {
                runType = "testTarget",
              },
            },
          }
        end
      },
    },
    ft = {"scala", "sbt", "java"},
    opts = function()
      local metals_config = require("metals").bare_config()
      require("core.utils").load_mappings("lspconfig")

      -- Example of settings
      metals_config.settings = {
        showImplicitArguments = true,
        excludedPackages = { "akka.actor.typed.javadsl", "com.github.swagger.akka.javadsl" },
        enableSemanticHighlighting = false,
      }

      -- *READ THIS*
      -- I *highly* recommend setting statusBarProvider to true, however if you do,
      -- you *have* to have a setting to display this in your statusline or else
      -- you'll not see any messages from metals. There is more info in the help
      -- docs about this
      -- metals_config.init_options.statusBarProvider = "on"

      -- Example if you are using cmp how to make sure the correct capabilities for snippets are set
      metals_config.capabilities = require("cmp_nvim_lsp").default_capabilities()

      metals_config.on_attach = function(client, bufnr)
        require("metals").setup_dap()
      end
      return metals_config
    end,
    config = function(self, metals_config)
      local nvim_metals_group = vim.api.nvim_create_augroup("nvim-metals", { clear = true })
      vim.api.nvim_create_autocmd("FileType", {
        pattern = self.ft,
        callback = function()
          require("metals").initialize_or_attach(metals_config)
        end,
        group = nvim_metals_group,
      })
    end,

  },

  {
    "nvim-treesitter/nvim-treesitter-context",
    event = "BufReadPost",
    config = function()
      require("core.utils").load_mappings("context")
      require'treesitter-context'.setup{
        enable = true, -- Enable this plugin (Can be enabled/disabled later via commands)
        max_lines = 0, -- How many lines the window should span. Values <= 0 mean no limit.
        min_window_height = 0, -- Minimum editor window height to enable context. Values <= 0 mean no limit.
        line_numbers = true,
        multiline_threshold = 20, -- Maximum number of lines to show for a single context
        trim_scope = 'outer', -- Which context lines to discard if `max_lines` is exceeded. Choices: 'inner', 'outer'
        mode = 'cursor',  -- Line used to calculate context. Choices: 'cursor', 'topline'
        -- Separator between context and content. Should be a single character string, like '-'.
        -- When separator is set, the context will only show up when there are at least 2 lines above cursorline.
        separator = '—',
        zindex = 20, -- The Z-index of the context window
        on_attach = nil, -- (fun(buf: integer): boolean) return false to disable attaching
      }
      vim.cmd("TSContextEnable")
    end

  },

  {
    'stevearc/aerial.nvim',
    opts = {},
    event = "VeryLazy",
    config = function()
      require("aerial").setup({
        layout = {
          -- These control the width of the aerial window.
          -- They can be integers or a float between 0 and 1 (e.g. 0.4 for 40%)
          -- min_width and max_width can be a list of mixed types.
          -- max_width = {40, 0.2} means "the lesser of 40 columns or 20% of total"
          max_width = { 40, 0.2 },
          width = nil,
          min_width = 10,

          -- key-value pairs of window-local options for aerial window (e.g. winhl)
          win_opts = {},

          -- Determines the default direction to open the aerial window. The 'prefer'
          -- options will open the window in the other direction *if* there is a
          -- different buffer in the way of the preferred direction
          -- Enum: prefer_right, prefer_left, right, left, float
          default_direction = "left",

          -- Determines where the aerial window will be opened
          --   edge   - open aerial at the far right/left of the editor
          --   window - open aerial to the right/left of the current window
          placement = "window",

          -- When the symbols change, resize the aerial window (within min/max constraints) to fit
          resize_to_content = true,

          -- Preserve window size equality with (:help CTRL-W_=)
          preserve_equality = false,
        },
      })
      require("core.utils").load_mappings("aerial")
    end,
    dependencies = {
       "nvim-treesitter/nvim-treesitter",
       "nvim-tree/nvim-web-devicons"
    },
  },

  {
    "folke/flash.nvim",
    event = "VeryLazy",
    ---@type Flash.Config
    opts = {
      search = {
        modes = {
          -- options used when flash is activated through
          -- a regular search with `/` or `?`
          search = {
            highlight = { backdrop = true },
          }
        },
        highlight = {
          -- show a backdrop with hl FlashBackdrop
          backdrop = true,
          -- Highlight the search matches
          matches = true,
          -- extmark priority
          priority = 5000,
          groups = {
            match = "FlashMatch",
            current = "FlashCurrent",
            backdrop = "FlashPrompt",
            label = "FlashLabel",
          },
        },
      }
    },
    config = function()
      require("core.utils").load_mappings("flash")
    end,
    -- stylua: ignore
  },

  {
    "iamcco/markdown-preview.nvim",
    cmd = { "MarkdownPreviewToggle", "MarkdownPreview", "MarkdownPreviewStop" },
    build = "cd app && npm install",
    init = function()
      vim.g.mkdp_filetypes = { "markdown" }
    end,
    ft = { "markdown" },
    config = function()
      require("core.utils").load_mappings("markdown")
    end
  },
  {
    'nvim-focus/focus.nvim',
    event = "VeryLazy",
    version = '*',
    config = function()
      require("focus").setup({
          enable = true, -- Enable module
          commands = true, -- Create Focus commands
          autoresize = {
              enable = true, -- Enable or disable auto-resizing of splits
              width = 0, -- Force width for the focused window
              height = 0, -- Force height for the focused window
              minwidth = 0, -- Force minimum width for the unfocused window
              minheight = 0, -- Force minimum height for the unfocused window
              height_quickfix = 10, -- Set the height of quickfix panel
          },
          split = {
              bufnew = false, -- Create blank buffer for new split windows
              tmux = false, -- Create tmux splits instead of neovim splits
          },
          ui = {
              number = false, -- Display line numbers in the focussed window only
              relativenumber = false, -- Display relative line numbers in the focussed window only
              hybridnumber = false, -- Display hybrid line numbers in the focussed window only
              absolutenumber_unfocussed = false, -- Preserve absolute numbers in the unfocussed windows

              cursorline = true, -- Display a cursorline in the focussed window only
              cursorcolumn = false, -- Display cursorcolumn in the focussed window only
              colorcolumn = {
                  enable = false, -- Display colorcolumn in the foccused window only
                  list = '+1', -- Set the comma-saperated list for the colorcolumn
              },
              signcolumn = true, -- Display signcolumn in the focussed window only
              winhighlight = false, -- Auto highlighting for focussed/unfocussed windows
          }
      })
      require("core.utils").load_mappings("focus")
    end,
  },
  {
    "kylechui/nvim-surround",
    version = "*", -- Use for stability; omit to use `main` branch for the latest features
    event = "BufReadPost",
    config = function()
      require("nvim-surround").setup({
          -- Configuration here, or leave empty to use defaults
        keymaps = {
          -- insert = "<C-g>s",
          -- insert_line = "<C-g>S",
          -- normal = "ys",
          -- normal_cur = "yss",
          -- normal_line = "yS",
          -- normal_cur_line = "ySS",
          -- visual = "<leader>ww",
          -- visual_line = "<leader>wW",
          -- delete = "ds",
          -- change = "cs",
          -- change_line = "cS",
        },
      })
      require("core.utils").load_mappings("surround")
    end
}


  -- To make a plugin not be loaded
  -- {
  --   "NvChad/nvim-colorizer.lua",
  --   enabled = false
  -- },

  -- All NvChad plugins are lazy-loaded by default
  -- For a plugin to be loaded, you will need to set either `ft`, `cmd`, `keys`, `event`, or set `lazy = false`
  -- If you want a plugin to load on startup, add `lazy = false` to a plugin spec, for example
  -- {
  --   "mg979/vim-visual-multi",
  --   lazy = false,
  -- }
}

return plugins
