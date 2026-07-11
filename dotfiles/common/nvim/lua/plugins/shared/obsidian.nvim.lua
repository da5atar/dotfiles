return {
  "obsidian-nvim/obsidian.nvim",
  version = "*", -- use latest release, remove to use latest commit
  ---@module 'obsidian'
  ---@type obsidian.config
  opts = {
    legacy_commands = false, -- this will be removed in 4.0.0,
    picker = {
      -- name = "snacks.picker", -- use snacks picker
      -- name = "telescope.nvim",   -- or telescope
      name = "fzf-lua", -- or fzf-lua
      -- name = "mini.pick",   -- or mini.pick
    },
    workspaces = {
      {
        name = "My_Files",
        path = "~/Library/CloudStorage/Dropbox/My_Files",
      },
    },
  },
  vim.keymap.set("n", "<leader>O", "", { desc = "Obsidian" }),
  vim.keymap.set("n", "<leader>On", "<cmd>Obsidian new<cr>", { desc = "New note" }),
  vim.keymap.set("n", "<leader>Of", "<cmd>Obsidian quick_switch<cr>", { desc = "Find note" }),
  vim.keymap.set("n", "<leader>Os", "<cmd>Obsidian search<cr>", { desc = "Search notes" }),
  vim.keymap.set("n", "<leader>Ot", "<cmd>Obsidian today<cr>", { desc = "Today's daily note" }),
  vim.keymap.set("n", "<leader>Ow", "<cmd>Obsidian workspace<cr>", { desc = "Switch workspace" }),
  vim.keymap.set("n", "<leader>Oz", "<cmd>Obsidian unique_note<cr>", { desc = "New unique note" }),
}
