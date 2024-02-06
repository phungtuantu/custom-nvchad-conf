local autocmd = vim.api.nvim_create_autocmd


autocmd("BufWritePost",
{
  pattern = "*.py",
  callback = function()
      vim.cmd("silent !black --quiet %")
      vim.cmd("edit")
  end,
})
-- Auto resize panes when resizing nvim window
-- autocmd("VimResized", {
--   pattern = "*",
--   command = "tabdo wincmd =",
-- })
vim.opt.relativenumber = true
