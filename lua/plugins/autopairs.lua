return {
  "windwp/nvim-autopairs",
  opts = {
    fast_wrap = {},
  },
  config = function(_, opts)
    local npairs = require("nvim-autopairs")
    npairs.setup(opts)

    -- Add a mapping: Tab jumps over closing bracket if present
    vim.keymap.set("i", "<Tab>", function()
      local col = vim.fn.col(".") - 1
      local line = vim.fn.getline(".")
      local next_char = line:sub(col + 1, col + 1)
      if next_char:match("[)}%]]") then
        return "<Right>"
      else
        return "<Tab>"
      end
    end, { expr = true, noremap = true })
  end,
}
