return {
  "lervag/vimtex",
  ft = "tex", -- only load for LaTeX files
  config = function()
    -- VimTeX settings
    vim.g.vimtex_view_method = "skim"
    vim.g.vimtex_complete_enabled = 0
    vim.g.vimtex_indent_enabled = 1
    vim.g.vimtex_mappings_enabled = 1
    vim.g.vimtex_view_skim_sync = 1
    vim.g.vimtex_view_skim_activate = 1

    -- Filetype-specific settings
    vim.api.nvim_create_autocmd("FileType", {
      pattern = "tex",
      callback = function()
        vim.opt_local.wrap = true
        vim.opt_local.conceallevel = 0
        vim.opt_local.concealcursor = ""
        vim.opt.relativenumber = false
        vim.opt.number = true
      end,
    })
  end,
}
