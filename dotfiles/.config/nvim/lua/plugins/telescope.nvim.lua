-- Fuzzy finder
return {
  {
    "nvim-telescope/telescope.nvim",
    version = "*",
    dependencies = {
      "nvim-lua/plenary.nvim",
      -- optional but recommended to make telescope faster
      { "nvim-telescope/telescope-fzf-native.nvim", build = "make" },
    },
    config = function()
      local ok, telescope = pcall(require, "telescope")
      if not ok then
        return
      end
      local project_actions = require("telescope._extensions.project.actions")
      -- Setup Telescope
      telescope.setup({
        defaults = {},
        pickers = {
          -- Default configuration for builtin pickers goes here:
          -- picker_name = {
          --   picker_config_key = value,
          --   ...
          -- }
          -- Now the picker_config_key will be applied every time you call this
          -- builtin picker
          find_files = {
            theme = "dropdown",
          },
          live_grep = {
            theme = "ivy",
          },
        },
        --
        -- Telescope Extensions
        extensions = {
          -- Your extension configuration goes here:
          -- extension_name = {
          --   extension_config_key = value,
          -- }
          -- please take a look at the readme of the extension you want to configure
          ["fzf"] = {},
          ["media_files"] = {
            -- filetypes whitelist
            -- defaults to {"png", "jpg", "mp4", "webm", "pdf"}
            filetypes = { "png", "webp", "jpg", "jpeg" },
            -- find command (defaults to `fd`)
            find_cmd = "rg",
          },
        },
        ["project"] = {
          base_dirs = {
            { path = "~/Dev", max_depth = 5 },
          },
          ignore_missing_dirs = true, -- default: false
          hidden_files = true,        -- default: false
          theme = "dropdown",
          order_by = "asc",
          search_by = "title",
          sync_with_nvim_tree = true, -- default false
          -- default for on_project_selected = find project files
          on_project_selected = function(prompt_bufnr)
            -- Do anything you want in here. For example:
            project_actions.change_working_directory(prompt_bufnr, false)
          end,
          mappings = {
            n = {
              ["d"] = project_actions.delete_project,
              ["r"] = project_actions.rename_project,
              ["c"] = project_actions.add_project,
              ["C"] = project_actions.add_project_cwd,
              ["f"] = project_actions.find_project_files,
              ["b"] = project_actions.browse_project_files,
              ["s"] = project_actions.search_in_project_files,
              ["R"] = project_actions.recent_project_files,
              ["w"] = project_actions.change_working_directory,
              ["o"] = project_actions.next_cd_scope,
            },
            i = {
              ["<c-d>"] = project_actions.delete_project,
              ["<c-v>"] = project_actions.rename_project,
              ["<c-a>"] = project_actions.add_project,
              ["<c-A>"] = project_actions.add_project_cwd,
              ["<c-f>"] = project_actions.find_project_files,
              ["<c-b>"] = project_actions.browse_project_files,
              ["<c-s>"] = project_actions.search_in_project_files,
              ["<c-r>"] = project_actions.recent_project_files,
              ["<c-l>"] = project_actions.change_working_directory,
              ["<c-o>"] = project_actions.next_cd_scope,
            },
          },
        },
        ["repo"] = {
          list = {
            fd_opts = {
              "--no-ignore-vcs",
            },
            search_dirs = {
              "~/Dev",
            },
          },
        },
        ["ui-select"] = {},
      })
      --
      -- load extensions
      telescope.load_extension("fzf")
      telescope.load_extension("media_files")
      telescope.load_extension("project")
      telescope.load_extension("repo")
      telescope.load_extension("ui-select")

      -- Custom keymaps
      local builtin = require("telescope.builtin")
      vim.keymap.set("n", "<leader>Ff", builtin.find_files, { desc = "Telescope [f]ind files" })
      vim.keymap.set("n", "<leader>Fg", builtin.live_grep, { desc = "Telescope live [g]rep" })
      vim.keymap.set("n", "<leader>Fb", builtin.buffers, { desc = "Telescope [b]uffers" })
      vim.keymap.set("n", "<leader>Fh", builtin.help_tags, { desc = "Telescope [h]elp tags" })
      vim.keymap.set("n", "<leader>Fm", "<cmd>Telescope media_files<CR>", { desc = "Telescope [m]edia files" })
      vim.keymap.set("n", "<leader>Fp", "<cmd>Telescope project<CR>", { desc = "Telescope [p]roject" })
      vim.keymap.set("n", "<leader>Fr", "<cmd>Telescope repo list<CR>", { desc = "List [r]epos" })
    end,
    --
  },
  {
    "nvim-telescope/telescope-media-files.nvim",
    dependencies = {
      { "nvim-lua/popup.nvim" },
      { "nvim-telescope/telescope.nvim" },
    },
  },
  {
    "nvim-telescope/telescope-project.nvim",
    dependencies = {
      "nvim-telescope/telescope.nvim",
    },
  },
  {
    "cljoly/telescope-repo.nvim",
    dependencies = {
      "nvim-telescope/telescope.nvim",
    },
  },
  { "nvim-telescope/telescope-ui-select.nvim",
    dependencies = {
      "nvim-telescope/telescope.nvim",
    },
  },
}
