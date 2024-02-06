local dap = require ('dap')
dap.adapters.python = function(cb, config)
  if config.request == 'attach' then
    --@diagnostic disable-next-line: undefined-field
    local port = (config.connect or config).port
    --@diagnostic disable-next-line: undefined-field
    local host = (config.connect or config).host or '127.0.0.1'
    cb({
      type = 'server',
      port = assert(port, '`connect.port` is required for a python `attach` configuration'),
      host = host,
      options = {
        source_filetype = 'python',
      },
    })
  else
    cb({
      type = 'executable',
      command = os.getenv('PYENV_ROOT') .. '/versions/dap/bin/python',
      args = { '-m', 'debugpy.adapter' },
      options = {
        source_filetype = 'python',
      },
    })
  end
end

dap.configurations.python = {
  {
    type = 'python';
    request = 'launch';
    name = "Launch file";

    program = "$(file)";
    pythonPath = function()
      if vim.env.VIRTUAL_ENV then return vim.env.VIRTUAL_ENV ..'/bin/python' end
      local cwd = vim.fn.getcwd()
      if vim.fn.executable(cwd .. '/venv/bin/python') == 1 then
        return cwd .. '/venv/bin/python'
      elseif vim.fn.executable(cwd .. '/.venv/bin/python') == 1 then
        return cwd .. '/.venv/bin/python'
      elseif vim.fn.executable(cwd .. '/.env/bin/python') == 1 then
        return cwd .. '/.env/bin/python'
      else
        return '/opt/conda/bin/python'
      end
    end;
  }
}
