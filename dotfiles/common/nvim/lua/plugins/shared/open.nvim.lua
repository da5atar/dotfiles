-- "ofirgall/open.nvim"
return {
  "ofirgall/open.nvim",
  requires = "nvim-lua/plenary.nvim",
  config = function()
    require("open").setup({})
  end,
}
