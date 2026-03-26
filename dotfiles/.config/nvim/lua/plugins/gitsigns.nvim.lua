-- Git signs
return {
  "lewis6991/gitsigns.nvim",
  config = function()
    require("gitsigns").setup()

    -- NOTE: The gh here stangs for git hunk
    vim.keymap.set("n", "<leader>GH", "", { desc = "[H]unks" })
    vim.keymap.set("n", "<leader>GHp", ":Gitsigns preview_hunk<CR>", { desc = "[p]review hunk" })
    vim.keymap.set("n", "<leader>GHs", ":Gitsigns stage_hunk<CR>", { desc = "[s]tage hunk" }) -- Stage or Unstage
    vim.keymap.set("n", "<leader>GHr", ":Gitsigns reset_hunk<CR>", { desc = "[r]eset hunk" }) -- Can only reset unstaged content
    vim.keymap.set("n", "<leader>GHn", ":Gitsigns nav_hunk next<CR>", { desc = "[n]ext hunk" })
  end,
}
