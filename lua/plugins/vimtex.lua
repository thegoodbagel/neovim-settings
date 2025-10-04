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
    _G.smart_tab = function()
      local line_num = vim.fn.line(".")
      local col = vim.fn.col(".")
      local lines = vim.api.nvim_buf_get_lines(0, 0, -1, false)
      local cur_line = lines[line_num]
      local before_cursor = cur_line:sub(1, col - 1)

      -- Check if we're on an \item line (with optional content after)
      if before_cursor:match("^%s*\\item%s*") then
        -- Find the current list environment
        local list_type = nil
        local list_start_line = nil
        local depth = 0

        for i = line_num, 1, -1 do
          local l = lines[i]
          if l:match("\\end{itemize}") or l:match("\\end{enumerate}") or l:match("\\end{description}") then
            depth = depth + 1
          elseif l:match("\\begin{itemize}") then
            depth = depth - 1
            if depth < 0 then
              list_type = "itemize"
              list_start_line = i
              break
            end
          elseif l:match("\\begin{enumerate}") then
            depth = depth - 1
            if depth < 0 then
              list_type = "enumerate"
              list_start_line = i
              break
            end
          elseif l:match("\\begin{description}") then
            depth = depth - 1
            if depth < 0 then
              list_type = "description"
              list_start_line = i
              break
            end
          end
        end

        if list_type and list_start_line then
          -- Move to the line after \end{list_type}
          -- Find the matching \end
          for i = line_num, #lines do
            local l = lines[i]
            if l:match("\\end{" .. list_type .. "}") then
              -- Move cursor to end of the \end line
              local keys = vim.api.nvim_replace_termcodes("<Esc>" .. i .. "GA", true, false, true)
              return keys
            end
          end
        end
      end

      -- Return nil to let other handlers process Tab
      return nil
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
