---@type MappingsTable
local M = {}

M.general = {
  n = {
    [";"] = { ":", "enter command mode", opts = { nowait = true } },
    ["<leader>s"] = { "<cmd> syntax sync fromstart <CR>", "Resync the syntax highlighting" },
  },
}

M.telescope = {
  plugin = true,

  n = {
    -- find
    ["<leader>fg"] = { "<cmd> Telescope live_grep <CR>", "Live grep" },
  },
}
-- more keybinds!

M.nvimtree = {
  plugin = true,

  n = {
    -- toggle
    ["<leader><C-t>"] = { "<cmd> NvimTreeToggle <CR>", "Toggle nvimtree" },
  },
}

M.nvimdap = {
  plugin = true,

  n = {
    ["<leader>dp"] = {
      function()
        require("dap").repl.toggle()
      end,
      "Toggle REPL State Inspector"},

    ["<leader>dd"] = {
      function()
        require("dapui").toggle()
      end,
      "Toggle DAP UI"},

    ["<leader>db"] = {
      function()
        require("dap").toggle_breakpoint()
      end,
      "Debug toggle breakpoint"},

    ["<leader>dc"] = {
      function()
        require("dap").continue()
      end,
      "Debug continue"},

    ["<leader>ds"] = {
      function()
        require("dap").step_over()
      end,
      "Debug step over"},

    ["<leader>dS"] = {
      function ()
        require("dap").step_into()
      end,
      "Debug step into"},
  },
}

M.black = {
  plugin = true,
  n = {
    ["<leader>cf"] = { "<cmd> !black % <CR>", "Run Black formatter" }
  },
}

M.copilot = {
  n = {
    ["<leader>cp"] = { "<cmd> Copilot panel <CR>", "Open up the copilot panel" },
  }
}

M.context = {
  n = {
    ["<leader>ct"] = { "<cmd> TSContextToggle <CR>", "Toggle context" },
  }
}

M.aerial = {
  n = {
    ["<leader>aa"] = { "<cmd> AerialToggle <CR>", "Toggle aerial" },
    ["<leader>{"] = { "<cmd> AerialPrev <CR>", "Jump backward with aerial" },
    ["<leader>}"] = { "<cmd> AerialNext <CR>", "Jump forward with aerial" },
    ["<leader>fr"] = { "<cmd> Telescope aerial <CR>", "Telescope search with aerial" },
  }
}

M.flash = {
  n = {
    ["s"] = { function() require("flash").jump() end, "Flash" },
    ["<C-S>"] = { function() require("flash").toggle() end, "Flash toogle Search" }
  }
}

M.gitsigns = {
  n = {
    ["<leader>gg"] = { "<cmd> Gitsigns toggle_current_line_blame <CR>", "Gitsigns toggle current line blame"}
  }
}

M.markdown = {
  n = {
    ["<leader>mp"] = { "<cmd> MarkdownPreviewToggle <CR>", "Toggle markdown preview" }
  }
}

M.focus = {
  n = {
    ["<leader>wf"] = { "<cmd> FocusToggle <CR>", "Toggle Focus" },
    ["<leader>ws"] = { "<cmd> FocusSplitNicely <CR>", "Split window based on golden ration" },
    ["<leader>wc"] = { "<cmd> FocusSplitCycle <CR>", "Cycle through splits" }
  }
}

M.surround = {
  plugin = true,

  i = {
    ["<C-g>s"] = {
      function()
        require('nvim-surround').insert_surround({ line_mode = false })
      end,
      "In Insert mode, add a surrounding pair around the cursor",
      opts = { buffer = false, silent=true}},
    ["<C-g>S"] = {
      function()
        require('nvim-surround').insert_surround({ line_mode = true })
      end,
      "In Insert mode, add a surrounding pair around the cursor on new lines",
      opts = { buffer = false, silent=true}},
  },

  n = {
    ["ys"] = {
      function()
        return require('nvim-surround').normal_surround({ line_mode = false })
      end,
      "In normal mode, add a surrounding pair around the cursor",
      opts = { buffer = false, silent = true, expr = true}},
    ["yS"] = {
      function()
        return require('nvim-surround').normal_surround({ line_mode = true })
      end,
      "In normal mode, add a surrounding pair around the cursor on new lines",
      opts = { buffer = false, silent = true, expr = true}},
    ["ds"] = {
      function()
        require("nvim-surround").delete_surround()
      end,
      "In normal mode, remove a surrounding pair around the cursor",
      opts = { buffer = false, silent = true, expr = true}},
    ["cs"] = {
      function()
        return require('nvim-surround').change_surround({ line_mode = false})
      end,
      "In normal mode, change a surrounding pair around the cursor",
      opts = { buffer = false, silent = true, expr = true}},
    ["cS"] = {
      function()
        return require('nvim-surround').change_surround({ line_mode = true })
      end,
      "In normal mode, change a surrounding pair around the cursor on new lines",
      opts = { buffer = false, silent = true, expr = true}},
  },

  v = {
    ["<leader>ww"] = {
      function()
        local curpos = require("nvim-surround.buffer").get_curpos()
        return string.format(
            ":lua require'nvim-surround'.visual_surround({ line_mode = false, curpos = { %d, %d }, curswant = %d })<CR>",
            curpos[1],
            curpos[2],
            vim.fn.winsaveview().curswant
        )
      end,
      "In visual mode, add a surrounding pair around the selection",
      opts = { buffer = false, silent = true, expr = true}},
    ["<leader>wW"] = {
      function()
        local curpos = require("nvim-surround.buffer").get_curpos()
        return string.format(
            ":lua require'nvim-surround'.visual_surround({ line_mode = true, curpos = { %d, %d }, curswant = 0 })<CR>",
            curpos[1],
            curpos[2]
        )
      end,
      "In visual mode, add a surrounding pair around the selection on new lines",
      opts = { buffer = false, silent = true, expr = true}},
  }
}

M.csvlens = {
  n = {
    ["<leader>cv"] = { "<cmd> Csvlens <CR>", "Open Csv Viewer" },
  }
}

return M
