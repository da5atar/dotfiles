return {
  "HakonHarnes/img-clip.nvim",
  event = "VeryLazy",
  opts = {
    default = {
      -- file and directory options
      dir_path = "./_resources",
      file_name = "%Y-%m-%d-%H-%M-%S",
      relative_to_current_file = true,
    },
  },
  keys = {
    -- suggested keymap
    { "<leader>ip", "<cmd>PasteImage<cr>", desc = "Paste image from system clipboard" },
  },
}
