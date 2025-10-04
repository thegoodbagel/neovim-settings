-- ~/.config/nvim/lua/plugins/luasnip.lua
return {
  {
    "L3MON4D3/LuaSnip",
    build = "make install_jsregexp",
    config = function()
      local ls = require("luasnip")
      local cmp = pcall(require, "cmp") and require("cmp") or nil

      -- Load snippets
      require("luasnip.loaders.from_vscode").lazy_load()
      require("luasnip.loaders.from_lua").lazy_load({ paths = "~/.config/nvim/lua/plugins" })
      require("plugins.autocomplete-tex") -- just runs snippet definitions

      -- Tab mappings (snippets > completion > fallback)
      vim.keymap.set({ "i", "s" }, "<Tab>", function(fallback)
        if ls.expand_or_jumpable() then
          ls.expand_or_jump()
        elseif cmp and cmp.visible() then
          cmp.select_next_item()
        else
          fallback()
        end
      end, { silent = true })

      vim.keymap.set({ "i", "s" }, "<S-Tab>", function(fallback)
        if ls.jumpable(-1) then
          ls.jump(-1)
        elseif cmp and cmp.visible() then
          cmp.select_prev_item()
        else
          fallback()
        end
      end, { silent = true })
    end,
  },
}
