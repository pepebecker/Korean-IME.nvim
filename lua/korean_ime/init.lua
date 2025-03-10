local config = require("korean_ime.config")
local hangul = require("korean_ime.hangul")

local M = {}

---@param opts Hangul.UserConfig?
M.setup = function(opts)
  opts = opts or {}
  config.opts = vim.tbl_deep_extend("force", {}, config.default_opts, opts)
  hangul.essential_mappings()
end

M.change_mode = hangul.change_mode
M.get_mode = function()
  return hangul.mode
end
M.convert_hanja = function()
  -- load the module only when you use it.
  return require("korean_ime.hanja").convert_hanja()
end

return M
