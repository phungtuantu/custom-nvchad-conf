---@type ChadrcConfig
local M = {}

-- Path to overriding theme and highlights files
local highlights = require "custom.highlights"

M.ui = {
  theme = "doomchad",
  theme_toggle = { "doomchad", "one_light" },

  hl_override = highlights.override,
  hl_add = highlights.add,
}

M.plugins = "custom.plugins"
vim.api.nvim_set_hl(0, "@comment", {link = "Comment"})

-- check core.mappings for table structure
M.mappings = require "custom.mappings"

return M
