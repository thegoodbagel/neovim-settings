return {
  "windwp/nvim-autopairs",
  event = "InsertEnter",
  config = function()
    local npairs = require("nvim-autopairs")
    npairs.setup({
      fast_wrap = {},
      disable_filetype = { "TelescopePrompt", "vim" },
    })

    local Rule = require("nvim-autopairs.rule")

    -- Inline math: $...$
    local single_dollar = Rule("$", "$", { "tex", "latex", "markdown" }):with_pair(function(opts)
      local line = opts.line
      local col = opts.col
      local prev_char = line:sub(col - 1, col - 1)
      -- don’t trigger if already typed a $
      return prev_char ~= "$"
    end)

    -- Display math: $$...$$
    local double_dollar = Rule("$$", "$", { "tex", "latex", "markdown" })

    npairs.add_rules({ single_dollar, double_dollar })
  end,
}
