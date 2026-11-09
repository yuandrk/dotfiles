-- Options on top of LazyVim's defaults, which already cover line numbers,
-- 2-space indent, smartcase search, system clipboard, persistent undo, etc.
-- LazyVim loads this file itself, before plugins:
-- https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua

local opt = vim.opt

opt.scrolloff = 8 -- keep 8 lines visible above/below the cursor (LazyVim: 4)
opt.swapfile = false -- no .swp files; undo history is persistent anyway
opt.undodir = os.getenv("HOME") .. "/.local/share/nvim/undo"
