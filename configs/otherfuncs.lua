local M = {}

-- toggle cmp completion
vim.g.cmp_toggle_flag = true -- initialize
M.toggle_completion = function()
  local ok, cmp = pcall(require, "cmp")
  if ok then
    vim.g.cmp_toggle_flag = not vim.g.cmp_toggle_flag
    if (vim.g.cmp_toggle_flag) then
      print ("cmp on")
    else
      print ("cmp off")
    end
    cmp.setup({
      enabled = function()
        return vim.g.cmp_toggle_flag
      end,
    })
  else
    print("completion not available")
  end
end

return M
