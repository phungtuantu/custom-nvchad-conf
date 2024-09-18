local configs = require("plugins.configs.lspconfig")

local on_attach = configs.on_attach
local on_init = configs.on_init
local capabilities = configs.capabilities

local lspconfig = require "lspconfig"

-- if you just want default config for the servers then put them in a table
local servers = { "html", "cssls", "ts_ls", "rust_analyzer" }

for _, lsp in ipairs(servers) do
  lspconfig[lsp].setup {
    on_attach = on_attach,
    on_init = on_init,
    capabilities = capabilities,
  }
end

-- 
-- lspconfig.pyright.setup { blabla}
--
lspconfig.pylsp.setup {
  on_attach = function(client, bufnr)
    require "core.utils".load_mappings("lspconfig", { buffer = bufnr })
    client.server_capabilities.documentFormattingProvider = false
    client.server_capabilities.documentRangeFormattingProvider = false
  end,
  capabilities = capabilities,
  settings = {
   pylsp = {
      plugins = {
        pycodestyle = {
          ignore = {'W391', 'W503', 'E501', 'E203'},
          maxLineLength = 100
        },
        jedi_definition = {
          follow_builtin_definitions = true
        }
      }
    },
  }
}

lspconfig.pyright.setup {
  on_attach = on_attach,
  capabilities = capabilities,
  settings = {
    pyright = {autoImportCompletion = true,},
    python = {
      analysis = {
        autoSearchPaths = true,
        diagnosticMode = 'openFilesOnly',
        useLibraryCodeForTypes = true,
        typeCheckingMode = 'off'}
    }
  }
}

lspconfig.ruff_lsp.setup {
  on_attach = on_attach,
  capabilities = capabilities,
  init_options = {
    settings = {
      -- Any extra CLI arguments for `ruff` go here.
      args = {},
    }
  }
}

lspconfig.clangd.setup {
  on_attach = on_attach,
  on_init = on_init,
  capabilities = {
    textDocument = {
      completion = {
        editsNearCursor = true,
      },
    },
    offsetEncoding =  'utf-16' ,
  },
}

require("core.utils").load_mappings("black")
