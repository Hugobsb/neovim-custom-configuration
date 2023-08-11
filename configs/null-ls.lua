local null_ls = require "null-ls"

local formatting = null_ls.builtins.formatting
local code_actions = null_ls.builtins.code_actions
local lint = null_ls.builtins.diagnostics
-- local completion = null_ls.builtins.completion

local sources = {
  formatting.gofumpt,
  formatting.goimports_reviser,
  formatting.golines,
  formatting.prettierd,
  formatting.xmlformatter,
  formatting.yamlfix,

  code_actions.eslint_d,
  code_actions.refactoring,

  -- completion,
  lint.eslint_d,
}

local config = {
  debug = true,
  sources = sources,
}

null_ls.setup(config)

return {}

