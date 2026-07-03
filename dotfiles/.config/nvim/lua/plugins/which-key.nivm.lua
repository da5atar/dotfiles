-- Remember keymaps
return {
  "folke/which-key.nvim",
  event = "VeryLazy",
  opts = {
    icons = {
      rules = {
        { pattern = "readability", icon = "󰊰 ", color = "blue" },
        { pattern = "optimize", icon = " ", color = "green" },
        { pattern = "summarize", icon = " ", color = "cyan" },
        { pattern = "explain", icon = "󰘦 ", color = "orange" },
        { pattern = "fix", icon = "  ", color = "red" },
        { pattern = "tests", icon = " ", color = "azure" },
        { pattern = "ask", icon = "󱜺 ", color = "green" },
        { pattern = "refresh", icon = " ", color = "yellow" },
        { pattern = "focus", icon = "󰋱 ", color = "purple" },
        { pattern = "model", icon = " ", color = "grey" },
        { pattern = "repo", icon = " ", color = "cyan" },
        { pattern = "overseer", icon = "󰑮 ", color = "cyan" },
      },
    },
  },
  keys = {
    {
      "<leader>bk",
      function()
        require("which-key").show({ global = false })
      end,
      desc = "Buffer Local Keymaps (which-key)",
    },
  },
}
