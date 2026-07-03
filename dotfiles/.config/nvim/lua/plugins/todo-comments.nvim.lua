-- Show TODO comments
local icons = {
  FIX = " ",
  TODO = " ",
  HACK = " ",
  WARN = " ",
  PERF = " ",
  NOTE = " ",
  ERROR = " ",
  REFS = "",
  SHIELD = "",
}
return {
  "folke/todo-comments.nvim",
  dependencies = { "nvim-lua/plenary.nvim" },
  opts = {
    -- showcase
    -- PERF: fully optimized
    -- HACK: this is weird
    -- TODO: things to be done
    -- NOTE: add a note here
    -- FIX: this need fixing
    -- WARNING:
    keywords = {
      FIX = { icon = icons.FIX },
      TODO = { icon = icons.TODO, alt = { "WIP" } },
      HACK = { icon = icons.HACK, color = "hack" },
      WARN = { icon = icons.WARN },
      PERF = { icon = icons.PERF },
      NOTE = { icon = icons.NOTE, alt = { "INFO", "NB" } },
      ERROR = { icon = icons.ERROR, color = "error", alt = { "ERR" } },
      REFS = { icon = icons.REFS },
      SAFETY = { icon = icons.SHIELD, color = "hint" },
      audit = { icon = icons.WARN, color = "warning" },
      -- auditissue = { icon = icons.ERROR, color = "error", alt = { "audit-issue" } },
      -- auditinfo = { icon = icons.NOTE, color = "hint", alt = { "audit-info" } },
    },
    highlight = {
      max_line_len = 120,
      pattern = { [[.*<(KEYWORDS)\s*:]], [[\/\/.+(audit)\s+]] },
    },
    colors = {
      error = { "DiagnosticError" },
      warning = { "DiagnosticWarn" },
      info = { "DiagnosticInfo" },
      hint = { "DiagnosticHint" },
      hack = { "Function" },
      ref = { "FloatBorder" },
      default = { "Identifier" },
    },
  },
}
