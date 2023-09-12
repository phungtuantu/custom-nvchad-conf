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
      local on_attach = function(client, bufnr)
        client.server_capabilities.documentFormattingProvider = false
        client.server_capabilities.documentRangeFormattingProvider = false
      end
      local capabilities = vim.lsp.protocol.make_client_capabilities()
      require("lspconfig").pylsp.setup {
        on_attach = on_attach,
        capabilities = capabilities,
      }

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
    lazy=false,
    config = function()
      require("custom.configs.gitsigns")
    end
  },

  {
    "mfussenegger/nvim-dap",
    after = "coq_nvim",
    lazy = false,
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
