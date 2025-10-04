-- ~/.config/nvim/lua/plugins/completion.lua
-- Minimal setup: just snippets and autopairs, NO autocomplete menu

return {
  -- Disable blink.cmp autocomplete (but keep it installed for snippet support)
  {
    "saghen/blink.cmp",
    enabled = false, -- Completely disable it
  },

  -- Snippet engine only
  {
    "L3MON4D3/LuaSnip",
    build = "make install_jsregexp",
    config = function()
      local ls = require("luasnip")

      -- Load snippets
      require("luasnip.loaders.from_vscode").lazy_load()
      require("luasnip.loaders.from_lua").lazy_load({ paths = "~/.config/nvim/snippets" })

      -- Configure behavior
      ls.config.set_config({
        history = true,
        updateevents = "TextChanged,TextChangedI",
      })
    end,
    keys = {
      {
        "<Tab>",
        function()
          local ls = require("luasnip")

          -- If in snippet, jump forward
          if ls.locally_jumpable(1) then
            ls.jump(1)
            return
          end

          -- Check for exact snippet match
          local line = vim.fn.getline(".")
          local col = vim.fn.col(".") - 1
          local word = line:sub(1, col):match("%S+$") or ""

          for _, snip in ipairs(ls.get_snippets(vim.bo.filetype) or {}) do
            if snip.trigger == word then
              ls.expand()
              return
            end
          end

          -- Jump over closing brackets
          local next_char = line:sub(col + 1, col + 1)
          if next_char:match("[)}%]'>\"']") then
            vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<Right>", true, false, true), "n", false)
            return
          end

          -- Normal tab
          vim.api.nvim_feedkeys("\t", "n", false)
        end,
        mode = "i",
        desc = "Tab: snippet expansion and jump",
      },
      {
        "<S-Tab>",
        function()
          local ls = require("luasnip")

          if ls.jumpable(-1) then
            ls.jump(-1)
          else
            vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<S-Tab>", true, false, true), "n", false)
          end
        end,
        mode = "i",
        desc = "Shift-Tab: jump back in snippet",
      },
    },
  },

  -- Auto-close brackets/quotes
  {
    "windwp/nvim-autopairs",
    event = "InsertEnter",
    opts = {
      fast_wrap = {},
      disable_filetype = { "TelescopePrompt", "vim" },
    },
  },
}
