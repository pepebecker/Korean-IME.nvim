local config = require("korean_ime.config")
local core = require("korean_ime.core")

M = {}

---@param opts Hangul.UserConfig?
M.setup = function(opts)
  opts = opts or {}
  config.opts = vim.tbl_deep_extend("force", {}, config.default_opts, opts)
  core.essential_mappings()
end

M.change_mode = core.change_mode
M.convert_hanja = core.convert_hanja
M.get_mode = function()
  return config.mode
end

return M
