-- Treesitter
-- Interface to treesitter core in nvim for installing parsers
return {
  {
    "nvim-treesitter/nvim-treesitter",
    branch = "main",
    lazy = false,
    build = ":TSUpdate",
    dependencies = {
      "nvim-treesitter/nvim-treesitter-context",
    },
    config = function()
      -- Auto-install parsers and enable treesitter highlight/indent per filetype.
      -- See:
      -- - https://github.com/nvim-treesitter/nvim-treesitter/discussions/7927
      -- - https://github.com/nvim-treesitter/nvim-treesitter/discussions/8621
      vim.api.nvim_create_autocmd("FileType", {
        pattern = { "*" },
        callback = function(args)
          local ft = vim.bo[args.buf].filetype
          local lang = vim.treesitter.language.get_lang(ft)
          if not vim.treesitter.language.add(lang) then
            local available = vim.g.ts_available or require("nvim-treesitter").get_available()
            if not vim.g.ts_available then
              vim.g.ts_available = available
            end
            if vim.tbl_contains(available, lang) then
              require("nvim-treesitter").install(lang)
            end
          end
          if vim.treesitter.language.add(lang) then
            vim.treesitter.start(args.buf, lang)
            vim.bo[args.buf].indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
          end
        end,
      })

      -- Folding via treesitter.
      vim.api.nvim_create_autocmd({ "BufEnter", "BufAdd", "BufNew", "BufNewFile", "BufWinEnter" }, {
        group = vim.api.nvim_create_augroup("TS_FOLD_WORKAROUND", {}),
        callback = function()
          vim.opt.foldmethod = "expr"
          vim.opt.foldexpr = "v:lua.vim.treesitter.foldexpr()"
        end,
      })
    end,
  },
  -- Textobject selections and movement
  {
    "nvim-treesitter/nvim-treesitter-textobjects",
    branch = "main",
    event = "BufReadPost",
    dependencies = { "nvim-treesitter/nvim-treesitter" },
    init = function()
      -- Disable entire built-in ftplugin mappings to avoid conflicts.
      -- See https://github.com/neovim/neovim/tree/master/runtime/ftplugin for built-in ftplugins.
      vim.g.no_plugin_maps = true

      -- Or, disable per filetype (add as you like)
      -- vim.g.no_python_maps = true
      -- vim.g.no_ruby_maps = true
      -- vim.g.no_rust_maps = true
      -- vim.g.no_go_maps = true
    end,
    config = function()
      require("nvim-treesitter-textobjects").setup({
        select = {
          -- Automatically jump forward to textobj, similar to targets.vim
          lookahead = true,
          -- You can choose the select mode (default is charwise "v")
          --
          -- Can also be a function which gets passed a table with the keys
          -- * query_string: eg "@function.inner"
          -- * method: eg 'v' or 'o'
          -- and should return the mode ("v", "V", or "<c-v>") or a table
          -- mapping query_strings to modes.
          selection_modes = {
            ["@parameter.outer"] = "v", -- charwise
            ["@function.outer"] = "V", -- linewise
            ["@class.outer"] = "<c-v>", -- blockwise
            ["@local.scope"] = "V", -- linewise
          },
          move = {
            -- whether to set jumps in the jumplist
            -- This is similar to ]m, [m, ]M, [M Neovim"s mappings to jump to the next or previous function.
            set_jumps = true,
          },
        },
      })

      -- Textobject selections
      local set = vim.keymap.set
      local select = require("nvim-treesitter-textobjects.select").select_textobject

      set({ "x", "o" }, "af", function()
        select("@function.outer", "textobjects")
      end, { desc = "outer function" })
      set({ "x", "o" }, "if", function()
        select("@function.inner", "textobjects")
      end, { desc = "inner function" })
      set({ "x", "o" }, "ac", function()
        select("@class.outer", "textobjects")
      end, { desc = "outer class" })
      set({ "x", "o" }, "ic", function()
        select("@class.inner", "textobjects")
      end, { desc = "inner class" })
      set({ "x", "o" }, "aa", function()
        select("@parameter.outer", "textobjects")
      end, { desc = "outer argument" })
      set({ "x", "o" }, "ia", function()
        select("@parameter.inner", "textobjects")
      end, { desc = "inner argument" })
      set({ "x", "o" }, "as", function()
        select("@local.scope", "locals")
      end, { desc = "outer scope" })
      --

      -- Movement
      local move = require("nvim-treesitter-textobjects.move")

      set({ "n", "x", "o" }, "]f", function()
        move.goto_next_start("@function.outer", "textobjects")
      end, { desc = "next function start" })
      set({ "n", "x", "o" }, "[f", function()
        move.goto_previous_start("@function.outer", "textobjects")
      end, { desc = "previous function start" })
      set({ "n", "x", "o" }, "]F", function()
        move.goto_next_end("@function.outer", "textobjects")
      end, { desc = "next function end" })
      set({ "n", "x", "o" }, "[F", function()
        move.goto_previous_end("@function.outer", "textobjects")
      end, { desc = "previous function end" })
      set({ "n", "x", "o" }, "]c", function()
        move.goto_next_start("@class.outer", "textobjects")
      end, { desc = "next class start" })
      set({ "n", "x", "o" }, "[c", function()
        move.goto_previous_start("@class.outer", "textobjects")
      end, { desc = "previous class start" })
      set({ "n", "x", "o" }, "]C", function()
        move.goto_next_end("@class.outer", "textobjects")
      end, { desc = "next class end" })
      set({ "n", "x", "o" }, "[C", function()
        move.goto_previous_end("@class.outer", "textobjects")
      end, { desc = "previous class end" })
      --

      -- Swaps
      local swap = require("nvim-treesitter-textobjects.swap")

      set({ "n", "x", "o" }, "<localleader>san", function()
        swap.swap_textobject("@parameter.inner.next", "textobjects")
      end, { desc = "swap next argument" })
      set({ "n", "x", "o" }, "<localleader>sap", function()
        swap.swap_textobject("@parameter.inner.prev", "textobjects")
      end, { desc = "swap previous argument" })
      set({ "n", "x", "o" }, "<localleader>sa", function()
        swap.swap_textobject("@parameter.inner", "textobjects")
      end, { desc = "swap argument" })

      -- set({ "n", "x", "o" }, "<localleader>sfn", function()
      --   swap.swap_next("@function.outer")
      -- end)
      -- set("n", "<localleader>sfp", function()
      --   swap.swap_previous("@function.outer")
      -- end)

      -- repeat
      local ts_repeat_move = require("nvim-treesitter-textobjects.repeatable_move")

      -- Repeat movement with ; and ,
      -- ensure ; goes forward and , goes backward regardless of the last direction
      set({ "n", "x", "o" }, ";", ts_repeat_move.repeat_last_move_next, { desc = "repeat last move next" })
      set({ "n", "x", "o" }, ",", ts_repeat_move.repeat_last_move_previous, { desc = "repeat last move previous" })

      -- vim way: ; goes to the direction you were moving.
      set({ "n", "x", "o" }, ";", ts_repeat_move.repeat_last_move, { desc = "repeat last move" })
      set({ "n", "x", "o" }, ",", ts_repeat_move.repeat_last_move_opposite, { desc = "repeat last move opposite" })

      -- Optionally, make builtin f, F, t, T also repeatable with ; and ,
      set({ "n", "x", "o" }, "f", ts_repeat_move.builtin_f_expr, { expr = true })
      set({ "n", "x", "o" }, "F", ts_repeat_move.builtin_F_expr, { expr = true })
      set({ "n", "x", "o" }, "t", ts_repeat_move.builtin_t_expr, { expr = true })
      set({ "n", "x", "o" }, "T", ts_repeat_move.builtin_T_expr, { expr = true })
      --
    end,
    --
  },
  -- Context
  {
    "nvim-treesitter/nvim-treesitter-context",
    event = "VeryLazy",
    dependencies = { "nvim-treesitter/nvim-treesitter" },
    opts = {
      max_lines = 5,
      min_window_height = 20,
    },
    keys = {
      {
        "[c",
        function()
          require("treesitter-context").go_to_context()
        end,
        desc = "go to context",
      },
    },
  },
}
