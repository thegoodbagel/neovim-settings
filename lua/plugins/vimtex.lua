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

    -- Function to check if we're inside itemize/enumerate
    function _G.smart_item()
      local cur_line = vim.fn.getline(".")
      local col = vim.fn.col(".")
      local line_num = vim.fn.line(".")
      local lines = vim.fn.getbufline("%", 1, line_num)

      -- Check if cursor is right after \item with only whitespace between
      local before_cursor = cur_line:sub(1, col - 1)
      if before_cursor:match("^%s*\\item%s*$") then
        -- Determine the list type by looking backwards

        local list_type = "itemize" -- default

        for i = line_num, 1, -1 do
          local l = lines[i]
          if l:match("\\begin{enumerate}") then
            list_type = "enumerate"
            break
          elseif l:match("\\begin{itemize}") then
            list_type = "itemize"
            break
          end
        end

        -- Build the replacement text
        local keys = vim.api.nvim_replace_termcodes(
          "<C-u>\\begin{" .. list_type .. "}<CR>\\item <CR>\\end{" .. list_type .. "}<Esc>kA",
          true,
          false,
          true
        )

        return keys
      end

      -- Only trigger normal behavior if line starts with \item (optional spaces allowed)
      if not cur_line:match("^%s*\\item") then
        return vim.api.nvim_replace_termcodes("<CR>", true, false, true)
      end

      local inside_list = false
      local depth = 0

      for i = line_num, 1, -1 do
        local l = lines[i]
        if l:match("\\end{itemize}") or l:match("\\end{enumerate}") then
          depth = depth + 1
        elseif l:match("\\begin{itemize}") or l:match("\\begin{enumerate}") then
          depth = depth - 1
          if depth < 0 then
            inside_list = true
            break
          end
        end
      end

      if inside_list then
        return vim.api.nvim_replace_termcodes("<CR>\\item ", true, false, true)
      else
        return vim.api.nvim_replace_termcodes("<CR>", true, false, true)
      end
    end

    -- Normal Enter: smart_item
    vim.api.nvim_buf_set_keymap(0, "i", "<CR>", "v:lua.smart_item()", { expr = true, noremap = true })
    -- Shift+Enter: just a normal Enter (bypass smart_item)
    vim.api.nvim_buf_set_keymap(0, "i", "<S-CR>", "<CR>", { noremap = true, silent = true })

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
