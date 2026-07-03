return {
  "nvim-telescope/telescope.nvim",
  keys = {
    -- add a keymap to browse plugin files
    {
      "<leader>fP",
      function()
        require("telescope.builtin").find_files({ cwd = require("lazy.core.config").options.root })
      end,
      desc = "Find Plugin File",
    },
  },
}
