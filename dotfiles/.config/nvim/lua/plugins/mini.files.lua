return {
  "nvim-mini/mini.files",
  version = "*",
  config = function()
    require("mini.files").setup({})

    vim.keymap.set("n", "<leader>e", "<cmd>lua MiniFiles.open(vim.api.nvim_buf_get_name(0))<CR>",
      { desc = "Open Mini file explorer" })
  end,
}
