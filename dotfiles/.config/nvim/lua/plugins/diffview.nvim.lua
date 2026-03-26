-- Diff view
return {
  "sindrets/diffview.nvim",
  config = function()
    require("diffview").setup()
    vim.keymap.set("n", "<leader>Gd", ":DiffviewOpen -uno<CR>", { desc = "Open [d]iff view" })
    vim.keymap.set("n", "<leader>Gf", ":DiffviewFileHistory %<CR>", { desc = "Open [f]ile history" })
    vim.keymap.set("n", "<leader>GQ", ":DiffviewClose<CR>", { desc = "[Q]uit diff view" })
  end,
}
