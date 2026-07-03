-- willyelm/pulse.nvim
--
-- Pulse uses a prefix approach to move quickly between navigator modes:
-- Prefix 	Mode
-- (no prefix) 	 files
-- : 	 commands
-- ~ 	 git
-- ! 	 diagnostics
-- @ 	 symbols (current buffer)
-- # 	 workspace symbols
-- $ 	 live grep
-- ? 	 fuzzy search (current buffer)
-- > 	 code actions (current buffer)
return {
  "willyelm/pulse.nvim",
  dependencies = { "nvim-tree/nvim-web-devicons" },
  opts = {
    cmdline = true,
    position = "top",
    height = 0.9,
    width = 0.7,
    workspace_label = true,
    navigators = {
      files = {
        icons = true,
        filters = { "^%.git$", "%.DS_Store$" },
        git = {
          enable = true,
          ignore = false,
        },
        open_on_directory = true,
      },
    },
  },
  keys = {
    { "<leader>P", "<cmd>Pulse<cr>", desc = "Open Command Palette (Pulse)" },
    { "<leader>Pg", "<cmd>Pulse git<cr>", desc = "Pulse Git" },
    { "<leader>Pd", "<cmd>Pulse diagnostics<cr>", desc = "Pulse Diagnostics" },
    { "<leader>Pc", "<cmd>Pulse code_actions<cr>", desc = "Pulse Code Actions" },
    { "<leader>Ps", "<cmd>Pulse symbols<cr>", desc = "Pulse Symbols" },
    { "<leader>Pw", "<cmd>Pulse workspace_symbols<cr>", desc = "Pulse Workspace Symbols" },
    { "<leader>Pl", "<cmd>Pulse live_grep<cr>", desc = "Pulse Live Grep" },
    { "<leader>Pf", "<cmd>Pulse fuzzy_search<cr>", desc = "Pulse Fuzzy Search" },
  },
}
