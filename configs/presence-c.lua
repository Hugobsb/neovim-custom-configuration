local utils = require "custom/utils"

local blacklist = { "bees", "gateway" }

local function is_black_listed (...)
  local args = { ... }

  local str = table.concat(args, '|')

  for _, list_item in ipairs(blacklist) do
    if string.match(str, list_item) then
      return true
    end
  end

  return false
end

local function display_text_file(action)
  return function(filename)
    local directory = utils.get_buffer_directory()

    if (is_black_listed(filename, directory)) then
      return string.format("%s a confidential file", action)
    end

    return string.format("%s %s", action, filename)
  end
end

local function display_text_proj(action)
  return function(project_name)
    if project_name ~= nil then
      if is_black_listed(project_name) then
        return string.format("%s a confidential project", action)
      end

      return string.format("%s %s", action, project_name)
    end
  end
end

local function display_buttons(_, repo_url)
  local converted_url = utils.validate_and_convert_github_url(repo_url)

  if (converted_url == nil) then
    return nil
  end

  if is_black_listed(repo_url) then
    return {{ label = "View Repository", url = "https://bitly.com/98K8eH" }}
  end

  return {{ label = "View Repository", url = converted_url }}
end

local config = {
    -- General options
    auto_update         = true,                             -- Update activity based on autocmd events (if `false`, map or manually execute `:lua package.loaded.presence:update()`)
    neovim_image_text   = "The One True Text Editor",       -- Text displayed when hovered over the Neovim image
    main_image          = "neovim",                         -- Main image display (either "neovim" or "file")
    client_id           = "793271441293967371",             -- Use your own Discord application client id (not recommended)
    log_level           = nil,                              -- Log messages at or above this level (one of the following: "debug", "info", "warn", "error")
    debounce_timeout    = 10,                               -- Number of seconds to debounce events (or calls to `:lua package.loaded.presence:update(<filename>, true)`)
    enable_line_number  = false,                            -- Displays the current line number instead of the current project
    blacklist           = {},                               -- A list of strings or Lua patterns that disable Rich Presence if the current file name, path, or workspace matches
    buttons             = display_buttons,                  -- Configure Rich Presence button(s), either a boolean to enable/disable, a static table (`{{ label = "<label>", url = "<url>" }, ...}`, or a function(buffer: string, repo_url: string|nil): table)
    file_assets         = {},                               -- Custom file asset definitions keyed by file names and extensions (see default config at `lua/presence/file_assets.lua` for reference)
    show_time           = true,                             -- Show the timer

    -- Rich Presence text options
    editing_text        = display_text_file("Editing"),     -- Format string rendered when an editable file is loaded in the buffer (either string or function(filename: string): string)
    file_explorer_text  = display_text_file("Browsing"),    -- Format string rendered when browsing a file explorer (either string or function(file_explorer_name: string): string)
    git_commit_text     = "Committing changes",             -- Format string rendered when committing changes in git (either string or function(filename: string): string)
    plugin_manager_text = "Managing plugins",               -- Format string rendered when managing plugins (either string or function(plugin_manager_name: string): string)
    reading_text        = display_text_file("Reading"),     -- Format string rendered when a read-only or unmodifiable file is loaded in the buffer (either string or function(filename: string): string)
    workspace_text      = display_text_proj("Working on"),  -- Format string rendered when in a git repository (either string or function(project_name: string|nil, filename: string): string)
    line_number_text    = "Line %s out of %s",              -- Format string rendered when `enable_line_number` is set to true (either string or function(line_number: number, line_count: number): string)
}

return config
