local M = {}

---@class Hangul.UserConfig
---@field public hanja_db_dirs string?
---@field public hanja_db_name string?
---@field public hanja_desc_limit number?

---@type Hangul.UserConfig
M.opts = {}

---@type Hangul.UserConfig
M.default_opts = {
  hanja_db_dirs = vim.o.rtp,
  hanja_db_name = "hanja.txt",
  hanja_desc_limit = 1,
}

return M
