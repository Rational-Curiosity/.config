vim.cmd([[
  syntax off
  filetype off
  filetype plugin indent off
]])
vim.opt.shadafile = "NONE"
local g = vim.g
g.loaded_gzip = false
g.loaded_netrwPlugin = false
g.loaded_tarPlugin = false
g.loaded_zipPlugin = false
g.loaded_2html_plugin = false
g.loaded_remote_plugins = false

g.sandwich_no_default_key_mappings = 1

local opt = vim.opt
opt.encoding = 'utf-8'
opt.fileencoding = 'utf-8'

vim.defer_fn(function()
  local status, err = pcall(require, 'impatient') -- .enable_profile()
  if not status then
    print('loading `impatient`: '..err)
  end
  require('config')

  vim.opt.shadafile = ""
  vim.cmd([[
    rshada!
    doautocmd BufRead
    syntax on
    filetype on
    filetype plugin indent on
    PackerLoad nvim-treesitter
  ]])
end, 0)
