local autocmd = vim.api.nvim_create_autocmd


autocmd("BufWritePost",
  {
    pattern = "*.py",
    callback = function()
      vim.cmd("silent !black --quiet %")
      vim.cmd("edit")
    end,
  })
autocmd("BufWritePre",
  {
    pattern = "*.{scala,lua}",
    callback = function()
      vim.lsp.buf.format { async = false }
    end,
  })
-- Auto resize panes when resizing nvim window
-- autocmd("VimResized", {
--   pattern = "*",
--   command = "tabdo wincmd =",
-- })
vim.opt.relativenumber = true
