-- Diff view
return {
  "sindrets/diffview.nvim",
  config = function()
    require("diffview").setup()
    vim.keymap.set("n", "<leader>gd", "", { desc = "[D]iff view" })
    vim.keymap.set("n", "<leader>gdo", ":DiffviewOpen -uno<CR>", { desc = "Open [d]iff view" })
    vim.keymap.set("n", "<leader>gdf", ":DiffviewFileHistory %<CR>", { desc = "Open [f]ile history" })
    vim.keymap.set("n", "<leader>gdq", ":DiffviewClose<CR>", { desc = "[Q]uit diff view" })
  end,
}
