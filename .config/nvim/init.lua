-- Leader key (must be set before lazy.nvim)
vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- Bootstrap lazy.nvim & plugins
require("config.lazy")

-- Core settings
require("config.options")
require("config.keymaps")
