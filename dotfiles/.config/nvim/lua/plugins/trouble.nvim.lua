-- Show diagnostics in a structured way
return {
  "folke/trouble.nvim",
  dependencies = { "nvim-tree/nvim-web-devicons" },
  opts = {
    focus = true,
    preview = {
      type = "float",
      relative = "editor",
      border = "rounded",
      title = "Preview",
      title_pos = "center",
      position = { 0, -2 },
      size = { width = 0.4, height = 0.3 },
      zindex = 200,
    },
    keys = {
      {
        "<leader>d",
        "",
        desc = "Diagnostics (Trouble)",
      },
      {
        "<leader>db",
        "<cmd>Trouble diagnostics toggle filter.buf=0<cr>",
        desc = "[B]uffer Diagnostics (Trouble)",
      },
      {
        "<leader>dt",
        "<cmd>Trouble diagnostics toggle<cr>",
        desc = "[T]oggle Diagnostics (Trouble)",
      },
      {
        "<leader>ds",
        "<cmd>Trouble symbols toggle focus=false<cr>",
        desc = "[S]ymbols (Trouble)",
      },
      {
        "<leader>dp",
        "<cmd>Trouble lsp toggle focus=false win.position=right<cr>",
        desc = "LS[P] Definitions / references / ... (Trouble)",
      },
      {
        "<leader>dL",
        "<cmd>Trouble loclist toggle<cr>",
        desc = "[L]ocation List (Trouble)",
      },
      {
        "<leader>dq",
        "<cmd>Trouble qflist toggle<cr>",
        desc = "[Q]uickfix List (Trouble)",
      },
    },
    opts = {},
  },
}
