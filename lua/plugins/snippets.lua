-- ~/.config/nvim/lua/plugins/snippets.lua
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

      -- Configure behavior
      ls.config.set_config({
        history = true,
        updateevents = "TextChanged,TextChangedI",
        enable_autosnippets = true,
        region_check_events = "CursorMoved,CursorMovedI",
      })

      -- Load snippets
      require("luasnip.loaders.from_vscode").lazy_load()
      require("luasnip.loaders.from_lua").lazy_load({ paths = "~/.config/nvim/snippets" })
    end,

    keys = {
      {
        "<Tab>",
        function()
          local ls = require("luasnip")

          -- Priority 1: LuaSnip expansion/jumping
          if ls.expand_or_jumpable() then
            ls.expand_or_jump()
            return
          end

          -- Priority 2: Jump over closing brackets
          local line = vim.fn.getline(".")
          local col = vim.fn.col(".") - 1
          local next_char = line:sub(col + 1, col + 1)
          if next_char:match("[)}%]>\"']") or next_char == "$" then
            vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<Right>", true, false, true), "n", false)
            return
          end

          -- Priority 3: LaTeX list exit behavior (only for tex files)
          if vim.bo.filetype == "tex" and _G.smart_tab then
            local result = _G.smart_tab()
            if result then
              vim.api.nvim_feedkeys(result, "n", false)
              return
            end
          end

          -- Priority 4: Default tab
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
