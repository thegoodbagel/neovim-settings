local ls = require("luasnip")

vim.keymap.set({ "i", "s" }, "<Tab>", function()
  if ls.expand_or_jumpable() then
    ls.expand_or_jump()
  else
    return "<Tab>"
  end
end, { expr = true, silent = true })

vim.keymap.set({ "i", "s" }, "<S-Tab>", function()
  if ls.jumpable(-1) then
    ls.jump(-1)
  end
end, { silent = true })
