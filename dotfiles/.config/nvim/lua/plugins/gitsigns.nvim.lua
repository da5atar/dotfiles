-- Git signs
return {
  "lewis6991/gitsigns.nvim",
  config = function()
    require("gitsigns").setup()

    -- NOTE: The gh here stangs for git hunk
    vim.keymap.set("n", "<leader>gh", "", { desc = "[h]unks" })
    vim.keymap.set("n", "<leader>ghp", ":Gitsigns preview_hunk<CR>", { desc = "[p]review hunk" })
    vim.keymap.set("n", "<leader>ghs", ":Gitsigns stage_hunk<CR>", { desc = "[s]tage hunk" }) -- Stage or Unstage
    vim.keymap.set("n", "<leader>ghr", ":Gitsigns reset_hunk<CR>", { desc = "[r]eset hunk" }) -- Can only reset unstaged content
    vim.keymap.set("n", "<leader>ghn", ":Gitsigns nav_hunk next<CR>", { desc = "[n]ext hunk" })
    vim.keymap.set("n", "<leader>ghp", ":Gitsigns nav_hunk prev<CR>", { desc = "[p]revious hunk" })
  end,
}
