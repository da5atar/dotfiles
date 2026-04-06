return {
  "nvim-mini/mini.files",
  version = "*",
  config = function()
    require("mini.files").setup({})

    vim.keymap.set("n", "<leader>e", "<cmd>lua MiniFiles.open()<CR>", {}, { desc = "Open Mini file explorer" })
  end,
}
