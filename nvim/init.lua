vim.loader.enable()
vim.api.nvim_command('syntax off')
vim.opt.spell = false
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

require("options")
require("lazy").setup("plugins", {
  defaults = { lazy = true },
  install = { colorscheme = { "tokyonight" } },
  performance = {
    cache = {
      enabled = true,
    },
    rtp = {
      reset = true,
      paths = { datapath .. "/site" },
      disabled_plugins = {
        "gzip",
        "matchit",
        "matchparen",
        "netrwPlugin",
        "tarPlugin",
        "tohtml",
        "tutor",
        "zipPlugin",
      },
    },
  },
})
