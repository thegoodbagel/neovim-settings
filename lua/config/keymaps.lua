-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here

local ls = require("luasnip")

vim.keymap.set({ "i", "s" }, "<Tab>", function()
  if ls.expand_or_jumpable() then
    ls.expand_or_jump()
  else
    return vim.api.nvim_replace_termcodes("<Tab>", true, true, true)
  end
end, { expr = false, silent = true })

vim.keymap.set({ "i", "s" }, "<S-Tab>", function()
  if ls.jumpable(-1) then
    ls.jump(-1)
  else
    return vim.api.nvim_replace_termcodes("<S-Tab>", true, true, true)
  end
end, { expr = false, silent = true })
