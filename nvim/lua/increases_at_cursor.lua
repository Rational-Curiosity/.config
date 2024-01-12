local M = {}
local increases_at_cursor = {
  {
    pattern = [[\l]],
    fun = function(match, steps)
      local a = string.byte('a')
      local z = string.byte('z')
      return string.char(
        (string.byte(match) + steps - a) % (z - a + 1) + a
      )
    end,
  },
  {
    pattern = [[\u]],
    fun = function(match, steps)
      local a = string.byte('A')
      local z = string.byte('Z')
      return string.char(
        (string.byte(match) + steps - a) % (z - a + 1) + a
      )
    end,
  },
  {
    pattern = [[\d\{4}-\d\{2}-\d\{2}]],
    range = 10,
    fun = function(match, step)
      local ts = vim.fn.strptime("%Y-%m-%d", match)
      if ts == 0 then
        return nil
      end
      return vim.fn.strftime("%Y-%m-%d", ts + step * 24 * 60 * 60)
    end,
  },
  {
    pattern = [[\d\{2}/\d\{2}/\d\{4}]],
    range = 10,
    fun = function(match, step)
      local ts = vim.fn.strptime("%d/%m/%Y", match)
      if ts == 0 then
        return nil
      end
      return vim.fn.strftime("%d/%m/%Y", ts + step * 24 * 60 * 60)
    end,
  },
}

for _, increase in ipairs(increases_at_cursor) do
  increase.regex = vim.regex(increase.pattern)
end

function M.increase_at_cursor(step)
  local step = (step or 1) * (vim.v.count == 0 and 1 or vim.v.count)
  local line_, col = unpack(vim.api.nvim_win_get_cursor(0))
  local line = line_ - 1
  for _, increase in ipairs(increases_at_cursor) do
    local start
    if increase.range == nil then
      start = vim.fn.searchpos(increase.pattern, 'nb', line_)[2] - 1
    else
      start = col - increase.range + 1
    end
    start = math.max(start, 0)
    local beg, fin = increase.regex:match_line(0, line, start)
    if beg ~= nil and fin ~= nil then
      beg = start + beg
      fin = start + fin
      if beg <= col and col < fin then
        local match = string.sub(vim.fn.getline(line_), beg + 1, fin)
        local replace = increase.fun(match, step)
        if replace ~= nil then
          vim.api.nvim_buf_set_text(0, line, beg, line, fin, { replace })
          return
        end
      end
    end
  end
  if step >= 0 then
    vim.cmd("normal!" .. step .. "")
  else
    vim.cmd("normal!" .. - step .. "")
  end
end

function M.decrease_at_cursor(step)
  M.increase_at_cursor(-(step or 1))
end

return M
