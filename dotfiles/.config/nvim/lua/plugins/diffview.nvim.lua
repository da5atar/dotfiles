-- Diff view
return {
  "sindrets/diffview.nvim",
  config = function()
    require("diffview").setup()
    vim.keymap.set("n", "<leader>gd", ":DiffviewOpen -uno<CR>", {}, { desc = "Open diff view" })
    vim.keymap.set("n", "<leader>gf", ":DiffviewFileHistory %<CR>", {}, { desc = "Open file history" })
    vim.keymap.set("n", "<leader>gq", ":DiffviewClose<CR>", {}, { desc = "Close diff view" })
  end,
}
