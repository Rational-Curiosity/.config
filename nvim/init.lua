vim.loader.enable()
vim.api.nvim_command('syntax off')
vim.o.spell = false
vim.g.mapleader = ' '

local datapath = vim.fn.stdpath("data")
local lazypath = datapath .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable", -- latest stable release
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

local options = require("options")
options.performance.rtp.paths = { datapath .. "/site" }
require("lazy").setup("plugins", options)
