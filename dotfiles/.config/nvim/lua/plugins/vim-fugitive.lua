-- Git integration
return {
  "tpope/vim-fugitive",
  event = "VeryLazy",
  keys = {
    { "<leader>gG", ":Git <cr>", desc = "Fugitive" },
  },
}
