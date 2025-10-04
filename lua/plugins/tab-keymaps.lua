-- ~/.config/nvim/lua/plugins/tab-keymaps.lua
-- Tab keymaps for snippet expansion only (no autocomplete)

return {
  "L3MON4D3/LuaSnip",
  keys = {
    {
      "<Tab>",
      function()
        local luasnip = require("luasnip")

        -- Priority 1: Jump in active snippet
        if luasnip.locally_jumpable(1) then
          luasnip.jump(1)
          return
        end

        -- Priority 2: Check for exact snippet match
        local line = vim.fn.getline(".")
        local col = vim.fn.col(".") - 1
        local before_cursor = line:sub(1, col)
        local word = before_cursor:match("%S+$") or ""

        local snippets = luasnip.get_snippets(vim.bo.filetype)
        for _, snip in ipairs(snippets or {}) do
          if snip.trigger == word then
            luasnip.expand()
            return
          end
        end

        -- Priority 3: Jump over closing brackets
        local next_char = line:sub(col + 1, col + 1)
        if next_char:match("[)}%]'>\"']") then
          vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<Right>", true, false, true), "n", false)
          return
        end

        -- Priority 4: Normal Tab
        vim.api.nvim_feedkeys("\t", "n", false)
      end,
      mode = "i",
      desc = "Tab: Snippet expansion > bracket jump > normal tab",
    },
    {
      "<S-Tab>",
      function()
        local luasnip = require("luasnip")

        if luasnip.jumpable(-1) then
          luasnip.jump(-1)
        else
          vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<S-Tab>", true, false, true), "n", false)
        end
      end,
      mode = "i",
      desc = "Shift-Tab: Jump back in snippet",
    },
  },
}
