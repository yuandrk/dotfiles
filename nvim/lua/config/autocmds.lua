-- Autocmds on top of LazyVim's defaults (yank highlight, close-with-q, auto
-- mkdir on save, ...). LazyVim loads this file itself, on the VeryLazy event:
-- https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/autocmds.lua

-- Strip trailing whitespace on save. Not in Markdown (two trailing spaces are
-- a line break there) and not in diffs (whitespace is part of the patch).
vim.api.nvim_create_autocmd("BufWritePre", {
  group = vim.api.nvim_create_augroup("trim_whitespace", { clear = true }),
  callback = function()
    if vim.tbl_contains({ "markdown", "diff", "gitcommit" }, vim.bo.filetype) then
      return
    end
    local view = vim.fn.winsaveview()
    vim.cmd([[keeppatterns %s/\s\+$//e]])
    vim.fn.winrestview(view)
  end,
})
