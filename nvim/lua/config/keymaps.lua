-- Keymaps on top of LazyVim's defaults (press <space> and wait: which-key
-- lists them all). LazyVim loads this file itself, on the VeryLazy event:
-- https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua

local map = vim.keymap.set

map("i", "jk", "<ESC>", { desc = "Exit insert mode" })

-- Keep the cursor centred while paging
map("n", "<C-d>", "<C-d>zz", { desc = "Scroll down and center" })
map("n", "<C-u>", "<C-u>zz", { desc = "Scroll up and center" })

-- Move the selection up / down (LazyVim's own keys for this are Alt-j / Alt-k)
map("v", "J", ":m '>+1<CR>gv=gv", { desc = "Move selection down" })
map("v", "K", ":m '<-2<CR>gv=gv", { desc = "Move selection up" })

-- Pasting over a selection keeps what was yanked
map("v", "p", '"_dP', { desc = "Paste without yanking" })
