---@type MappingsTable
local M = {}

M.general = {
  n = {
    [";"] = { ":", "enter command mode", opts = { nowait = true } },
    ["<leader>s"] = { "<cmd> syntax sync fromstart <CR>", "Resync the syntax highlighting" },
  },
  v = {
    ["<leader>ww"] = {
      function()
        local wrapper = vim.fn.input("Wrapper: ")
        vim.cmd("normal c"..wrapper)
        vim.cmd("normal p")
      end, "Wrap symbol around selection"},
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
    ["<leader>ct"] = { "<cmd> ContextToggle <CR>", "Toggle context" },
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

return M
