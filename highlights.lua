-- To find any highlight groups: "<cmd> Telescope highlights"
-- Each highlight group can take a table with variables fg, bg, bold, italic, etc
-- base30 variable names can also be used as colors

local M = {}

---@type Base46HLGroupsList
M.override = {
  Comment = {
    italic = true,
    fg = "#90B0A0"
  },
}
---@type HLTable
M.add = {
  NvimTreeOpenedFolderName = { fg = "green", bold = true },
  GitSignsDelete = { fg = "#ff6c6b" },
}

return M
