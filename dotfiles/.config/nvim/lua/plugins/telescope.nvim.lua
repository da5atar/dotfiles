-- Fuzzy finder
return {
  {
    "nvim-telescope/telescope.nvim",
    version = '*',
    dependencies = {
      "nvim-lua/plenary.nvim",
      -- optional but recommended to make telescope faster
      { "nvim-telescope/telescope-fzf-native.nvim", build = "make" },
    },
    config = function()
      require("telescope").setup({
        pickers = {
          -- Default configuration for builtin pickers goes here:
          -- picker_name = {
          --   picker_config_key = value,
          --   ...
          -- }
          -- Now the picker_config_key will be applied every time you call this
          -- builtin picker
          find_files = {
            theme = "dropdown" -- or "ivy"
          }
        },
        -- extensions
        extensions = {
          -- Your extension configuration goes here:
          -- extension_name = {
          --   extension_config_key = value,
          -- }
          -- please take a look at the readme of the extension you want to configure
          fzf = {},
        }
      })
      require("telescope").load_extension("fzf")
      -- keymaps
      local builtin = require("telescope.builtin")
      vim.keymap.set('n', "<leader>Ff", builtin.find_files, { desc = "Telescope find files" })
      vim.keymap.set('n', "<leader>Fg", builtin.live_grep, { desc = "Telescope live grep" })
      vim.keymap.set('n', "<leader>Fb", builtin.buffers, { desc = "Telescope buffers" })
      vim.keymap.set('n', "<leader>Fh", builtin.help_tags, { desc = "Telescope help tags" })
    end
    --
  }
}
