-- Git signs
return {
  "lewis6991/gitsigns.nvim",
  config = function()
    require("gitsigns").setup()

    -- NOTE: The gh here stangs for git hunk
    vim.keymap.set("n", "<leader>Gh", "", { desc = "[h]unks" })
    vim.keymap.set("n", "<leader>Ghp", ":Gitsigns preview_hunk<CR>", { desc = "[p]review hunk" })
    vim.keymap.set("n", "<leader>Ghs", ":Gitsigns stage_hunk<CR>", { desc = "[s]tage hunk" }) -- Stage or Unstage
    vim.keymap.set("n", "<leader>Ghr", ":Gitsigns reset_hunk<CR>", { desc = "[r]eset hunk" }) -- Can only reset unstaged content
    vim.keymap.set("n", "<leader>Ghn", ":Gitsigns nav_hunk next<CR>", { desc = "[n]ext hunk" })
  end,
}
