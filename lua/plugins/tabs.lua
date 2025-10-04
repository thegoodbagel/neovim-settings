-- ~/.config/nvim/lua/plugins/tab-completion.lua
-- Consolidated Tab completion: blink.cmp + LuaSnip + autopairs

return {
  -- Blink.cmp - completion engine
  {
    "saghen/blink.cmp",
    dependencies = { "L3MON4D3/LuaSnip", "windwp/nvim-autopairs" },
    opts = {
      keymap = {
        preset = "none", -- Completely disable blink's Tab handling
        ["<C-space>"] = { "show", "hide" },
        ["<C-e>"] = { "hide" },
        ["<CR>"] = { "accept", "fallback" },
        ["<Up>"] = { "select_prev", "fallback" },
        ["<Down>"] = { "select_next", "fallback" },
        ["<C-p>"] = { "select_prev", "fallback" },
        ["<C-n>"] = { "select_next", "fallback" },
        ["<C-u>"] = { "scroll_documentation_up", "fallback" },
        ["<C-d>"] = { "scroll_documentation_down", "fallback" },
      },
      snippets = {
        preset = "luasnip",
      },
      sources = {
        default = { "lsp", "path", "snippets", "buffer" },
      },
    },
  },

  -- LuaSnip - snippet engine
  {
    "L3MON4D3/LuaSnip",
    build = "make install_jsregexp",
    config = function()
      local ls = require("luasnip")

      -- Load snippets from various sources
      require("luasnip.loaders.from_vscode").lazy_load()
      require("luasnip.loaders.from_lua").lazy_load({ paths = "~/.config/nvim/snippets" })

      -- Configure LuaSnip behavior
      ls.config.set_config({
        history = true,
        updateevents = "TextChanged,TextChangedI",
        enable_autosnippets = false,
      })
    end,
  },

  -- Autopairs - automatic bracket pairing
  {
    "windwp/nvim-autopairs",
    event = "InsertEnter",
    opts = {
      fast_wrap = {},
      disable_filetype = { "TelescopePrompt", "vim" },
    },
    config = function(_, opts)
      local npairs = require("nvim-autopairs")
      npairs.setup(opts)

      -- Integrate with blink.cmp
      local cmp_ok, cmp = pcall(require, "blink.cmp")
      if cmp_ok then
        -- Auto-insert brackets after function/method completion
        local cmp_autopairs = require("nvim-autopairs.completion.cmp")
        -- Note: blink.cmp might need different integration
        -- This is a placeholder for future blink.cmp + autopairs integration
      end
    end,
  },
}
