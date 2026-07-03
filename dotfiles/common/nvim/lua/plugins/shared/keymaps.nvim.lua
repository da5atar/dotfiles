return {
  "abdul-hamid-achik/keymaps.nvim",
  opts = {
    category_icons = {
      ["LSP"] = "",
      ["Git"] = "",
      ["Navigation"] = "",
      ["Harpoon"] = "󱡀",
      ["Telescope"] = "",
      ["File Explorer"] = "",
      ["Editing"] = "",
      ["Comments"] = "",
      ["Debugging"] = "🕷️",
      ["Testing"] = "",
      ["Terminal"] = "",
      ["Other"] = "󰜡",
    },

    -- Icons for modes
    mode_icons = {
      n = "N", -- Normal
      i = "I", -- Insert
      v = "V", -- Visual
      x = "X", -- Visual Block
      s = "S", -- Select
      o = "O", -- Operator
      c = "C", -- Command
      t = "T", -- Terminal
    },
  },
  keys = {
    { "<leader>fk", "<cmd>Keymaps<cr>", desc = "Keymaps" },
  },
}
