local adapters = {'python'}

for _, adapter in ipairs(adapters) do
  require("custom.configs.dap-configs." .. adapter)
end
