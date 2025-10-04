-- ~/.config/nvim/snippets/tex.lua
local ls = require("luasnip")
local s = ls.snippet
local t = ls.text_node
local i = ls.insert_node

-- Return a flat array, not a table with a 'tex' key
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
  -- Theorems / proofs
  s("thm", { t({ "\\begin{theorem}", "\t" }), i(0), t({ "", "\\end{theorem}" }) }),
  s("pf", { t({ "\\begin{proof}", "\t" }), i(0), t({ "", "\\end{proof}" }) }),
  -- Other common environments
  s("center", { t({ "\\begin{center}", "\t" }), i(0), t({ "", "\\end{center}" }) }),
  s("quote", { t({ "\\begin{quote}", "\t" }), i(0), t({ "", "\\end{quote}" }) }),
  s("verbatim", { t({ "\\begin{verbatim}", "" }), i(0), t({ "", "\\end{verbatim}" }) }),
}
