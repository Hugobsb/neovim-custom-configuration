require("dap-vscode-js").setup({
  node_path = os.getenv("HOME") .. "/.nvm/versions/node/v16.20.1/bin", -- Path of node executable. Defaults to $NODE_PATH, and then "node"
  debugger_path = os.getenv("HOME") .. "/.local/share/nvim/lazy/vscode-js-debug", -- Path to vscode-js-debug installation.
  -- debugger_cmd = { "js-debug-adapter" }, -- Command to use to launch the debug server. Takes precedence over `node_path` and `debugger_path`.
  adapters = { 'pwa-node', 'pwa-chrome', 'node-terminal', 'pwa-extensionHost' }, -- which adapters to register in nvim-dap
  log_file_path = os.getenv("HOME") .. "/.cache/nvim/dap_vscode_js.log", -- Path for file logging
  log_file_level = 4, -- Logging level for output to file. Set to false to disable file logging.
  log_console_level = vim.log.levels.ERROR -- Logging level for output to console. Set to false to disable console output.
})

for _, language in ipairs({ "typescript", "javascript", "typescriptreact" }) do
  require("dap").configurations[language] = {
    {
      name = "Attach to Node process",
      type = "pwa-node",
      request = "attach",
      processId = require'dap.utils'.pick_process,
      cwd = "${workspaceFolder}",
    },
    {
      type = "pwa-node",
      request = "launch",
      name = "Debug Jest Tests",
      -- trace = true, -- include debugger info
      runtimeExecutable = "node",
      runtimeArgs = {
        "./node_modules/jest/bin/jest.js",
        "--runInBand",
      },
      rootPath = "${workspaceFolder}",
      cwd = "${workspaceFolder}",
      console = "integratedTerminal",
      internalConsoleOptions = "neverOpen",
    }
  }
end

return {}
