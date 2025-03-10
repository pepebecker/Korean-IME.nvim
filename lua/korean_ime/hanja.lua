local config = require("korean_ime.config")
local hangul = require("korean_ime.hangul")

local M = {}
local HANJADB = {}

---initialize hanja candidate list from external file
-- Requires libhangul's hanja.txt.
-- 1. Download https://github.com/libhangul/libhangul/blob/main/data/hanja/hanja.txt
-- 2. 2음절 이상인 데이터는 삭제
-- 3. runtimepath에 추가 (e.g. ~/.config/nvim/hanja.txt)
local function get_hanja_db(path)
  local db = {}
  for _, line in ipairs(vim.fn.readfile(path, "")) do
    if line:sub(1, 1) == "#" or line:find(":", 1, true) ~= 4 then
      goto continue
    end
    line = vim.fn.iconv(line, "utf-8", vim.o.enc)
    local hangul_from, hanja_to, desc = unpack(vim.fn.split(line, ":", 1))
    db[hangul_from] = db[hangul_from] or {}
    table.insert(db[hangul_from], { hanja_to, desc })
    ::continue::
  end
  return db
end

---Helper of get_hanja_db using hangul.config.opts
local function load_hanja_db()
  local hanjapath = vim.fn.split(vim.fn.globpath(config.opts.hanja_db_dirs, config.opts.hanja_db_name), "\n")
  if #hanjapath == 0 then
    HANJADB = {}
  else
    HANJADB = get_hanja_db(hanjapath[1])
  end
end

M.convert_hanja = function()
  if vim.fn.mode() ~= "i" or hangul.mode == "en" then
    return
  end

  if vim.tbl_isempty(HANJADB) then
    load_hanja_db()
  end

  local key = hangul.keystrokes()
  if HANJADB[key] == nil then
    if vim.o.verbose then
      require("korean_ime.notify").notify("No hanja match found.", "error", { title = "Korean-IME.nvim" })
    end
    return
  end
  local db = HANJADB[key]
  vim.print(db)

  local descpat = ""
  if config.opts.hanja_desc_limit > 0 then
    descpat = "^\\([^,]*\\(,[^,]*\\)\\{" .. (config.opts.hanja_desc_limit - 1) .. "}\\),.*$"
  end

  local cands = { key }
  for _, hanja_and_desc in ipairs(db) do
    local desc = ""
    if config.opts.hanja_desc_limit == 0 then
      desc = ""
    elseif config.opts.hanja_desc_limit > 0 then
      -- desc = vim.fn.substitute(hanja_and_desc[2], descpat, "\\1, ...", "")
      desc = hanja_and_desc[2]:gsub(descpat, "\\1, ...")
    else
      desc = hanja_and_desc[2]
    end
    table.insert(cands, { word = hanja_and_desc[1], menu = desc })
  end
  vim.fn.complete(vim.fn.col(".") - #key, cands)
end

return M
