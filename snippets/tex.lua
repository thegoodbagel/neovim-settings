-- ~/.config/nvim/snippets/tex.lua
local ls = require("luasnip")
local s = ls.snippet
local t = ls.text_node
local i = ls.insert_node
local f = ls.function_node

local rep = require("luasnip.extras").rep

-- Helper function for smart inline math spacing
local function mk_space(args, snip)
  local next_char = vim.fn.getline("."):sub(vim.fn.col("."))
  if next_char:match("[%w]") then
    return " "
  else
    return ""
  end
end

-- Define the subscript function
local function subscript_fn(args, snip)
  local letter = snip.captures[1]
  local number = snip.captures[2]
  return letter .. "_{" .. number .. "}"
end

return {
  -- Lists
  s("itm", { t({ "\\begin{itemize}", "\t\\item " }), i(0), t({ "", "\\end{itemize}" }) }),
  s("enu", { t({ "\\begin{enumerate}", "\t\\item " }), i(0), t({ "", "\\end{enumerate}" }) }),
  s("desc", { t({ "\\begin{description}", "\t\\item " }), i(0), t({ "", "\\end{description}" }) }),
  s("it", { t("\\item ") }),

  -- Figures
  s("fig", {
    t({ "\\begin{figure}[h]", "\t\\centering", "\t" }),
    i(0),
    t({ "", "\\caption{}", "\\label{}", "\\end{figure}" }),
  }),

  -- Tables
  s("tbl", {
    t({ "\\begin{table}[h]", "\t\\centering", "\t\\begin{tabular}{|c|c|}", "\t\\hline" }),
    i(0),
    t({ "", "\t\\hline", "\t\\end{tabular}", "\\caption{}", "\\label{}", "\\end{table}" }),
  }),

  -- Math environments
  s("align", { t({ "\\begin{align}", "\t" }), i(0), t({ "", "\\end{align}" }) }),
  s("equation", { t({ "\\begin{equation}", "\t" }), i(0), t({ "", "\\end{equation}" }) }),
  s("gather", { t({ "\\begin{gather}", "\t" }), i(0), t({ "", "\\end{gather}" }) }),

  -- Sections
  s("sec", { t("\\section{"), i(0), t("}") }),
  s("ssec", { t("\\subsection{"), i(0), t("}") }),
  s("sssec", { t("\\subsubsection{"), i(0), t("}") }),

  -- Formatting
  s("bf", { t("\\textbf{"), i(0), t("}") }),
  s("em", { t("\\emph{"), i(0), t("}") }),
  s("ul", { t("\\underline{"), i(0), t("}") }),

  -- Theorems / proofs
  s("thm", { t({ "\\begin{theorem}", "\t" }), i(0), t({ "", "\\end{theorem}" }) }),
  s("pf", { t({ "\\begin{proof}", "\t" }), i(0), t({ "", "\\end{proof}" }) }),

  -- Other environments
  s("center", { t({ "\\begin{center}", "\t" }), i(0), t({ "", "\\end{center}" }) }),
  s("quote", { t({ "\\begin{quote}", "\t" }), i(0), t({ "", "\\end{quote}" }) }),
  s("verbatim", { t({ "\\begin{verbatim}", "" }), i(0), t({ "", "\\end{verbatim}" }) }),
  s("comment", { t({ "\\begin{comment}", "\t" }), i(0), t({ "", "\\end{comment}" }) }),

  -- Inline math (mk) with smart spacing
  s({ trig = "mk", wordTrig = true }, {
    t("$"),
    i(1),
    t("$"),
    f(mk_space, {}),
  }),

  -- Display math (dm)
  s({ trig = "dm", wordTrig = true }, {
    t({ "\\[", "" }),
    i(1),
    t({ ".\\]", "" }),
    i(0),
  }),

  -- Begin / end environment
  s({ trig = "beg", wordTrig = true, regTrig = false, snippetType = "autosnippet" }, {
    t("\\begin{"),
    i(1),
    t({ "}", "\t" }),
    i(0),
    t({ "", "\\end{" }),
    rep(1),
    t("}"),
  }),

  -- Subscripts (single digit) - using Lua patterns
  s(
    {
      trig = "([A-Za-z])(%d)",
      regTrig = true,
      wordTrig = false,
      trigEngine = "pattern", -- Use Lua pattern engine
      snippetType = "autosnippet",
    },
    f(function(_, snip)
      return snip.captures[1] .. "_{" .. snip.captures[2] .. "}"
    end)
  ),

  -- Subscripts (two digits)
  s(
    {
      trig = "([A-Za-z])_(%d%d)",
      regTrig = true,
      wordTrig = false,
      trigEngine = "pattern",
      snippetType = "autosnippet",
    },
    f(function(_, snip)
      return snip.captures[1] .. "_{" .. snip.captures[2] .. "}"
    end)
  ),
  -- Superscripts
  s({ trig = "sr", snippetType = "autosnippet" }, t("^2")),
  s({ trig = "cb", snippetType = "autosnippet" }, t("^3")),
  s({ trig = "compl", snippetType = "autosnippet" }, t("^{c}")),
  s({ trig = "td", snippetType = "autosnippet" }, { t("^{"), i(1), t("}") }),

  -- Fractions
  s({ trig = "//", snippetType = "autosnippet" }, {
    t("\\frac{"),
    i(1),
    t("}{"),
    i(2),
    t("}"),
  }),

  -- Visual fraction
  s({ trig = "/", snippetType = "autosnippet" }, {
    t("\\frac{"),
    i(1),
    t("}{"),
    i(2),
    t("}"),
  }),

  s({ trig = "test%d", regTrig = true, snippetType = "autosnippet" }, t("REGEX WORKS")),
  s({ trig = "zzz", snippetType = "autosnippet" }, t("AUTO WORKS")),
}
