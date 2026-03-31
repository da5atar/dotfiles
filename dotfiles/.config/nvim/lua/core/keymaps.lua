--  See `:help vim.keymap.set()`

-- Leader
vim.g.mapleader = " "
vim.g.maplocalleader = "\\"

-- Arrows
-- Disable arrow keys in normal mode
-- vim.keymap.set('n', '<left>', '<cmd>echo "Use h to move!!"<CR>')
-- vim.keymap.set('n', '<right>', '<cmd>echo "Use l to move!!"<CR>')
-- vim.keymap.set('n', '<up>', '<cmd>echo "Use k to move!!"<CR>')
-- vim.keymap.set('n', '<down>', '<cmd>echo "Use j to move!!"<CR>')

-- Autocommands
-- Highlight when yanking (copying) text
--  Try it with `yap` in normal mode
--  See `:help vim.hl.on_yank()`
vim.api.nvim_create_autocmd("TextYankPost", {
  desc = "Highlight when yanking (copying) text",
  group = vim.api.nvim_create_augroup("kickstart-highlight-yank", { clear = true }),
  callback = function()
    vim.hl.on_yank()
  end,
})

-- Buffers
vim.keymap.set("n", "<leader>B", "", { desc = "[B]uffer" })

-- Diagnostics
vim.keymap.set("n", "<leader>D", "", { desc = "[D]iagnostics" })

-- Find
vim.keymap.set("n", "<leader>F", "", { desc = "[F]ind/[F]iles" })

-- Git
vim.keymap.set("n", "<leader>G", "", { desc = "[G]it" })

-- Window Splits
-- Keybinds to make split navigation easier.
--  Use CTRL+<hjkl> to switch between windows
--
--  See `:help wincmd` for a list of all window commands
vim.keymap.set("n", "<C-h>", "<C-w><C-h>", { desc = "Move focus to the left window split" })
vim.keymap.set("n", "<C-l>", "<C-w><C-l>", { desc = "Move focus to the right window split" })
vim.keymap.set("n", "<C-j>", "<C-w><C-j>", { desc = "Move focus to the lower window split" })
vim.keymap.set("n", "<C-k>", "<C-w><C-k>", { desc = "Move focus to the upper window split" })

-- NOTE: Some terminals have colliding keymaps or are not able to send distinct keycodes
-- vim.keymap.set("n", "<C-S-h>", "<C-w>H", { desc = "Move window to the left" })
-- vim.keymap.set("n", "<C-S-l>", "<C-w>L", { desc = "Move window to the right" })
-- vim.keymap.set("n", "<C-S-j>", "<C-w>J", { desc = "Move window to the lower" })
-- vim.keymap.set("n", "<C-S-k>", "<C-w>K", { desc = "Move window to the upper" })

-- Tabs
vim.keymap.set("n", "<leader>t", "", { desc = "[t]abs" })
vim.keymap.set("n", "<leader>tn", "<cmd>tabnext<cr>", { desc = "tab [n]ext" })
vim.keymap.set("n", "<leader>tp", "<cmd>tabprevious<cr>", { desc = "tab [p]revious" })
vim.keymap.set("n", "<leader>tc", "<cmd>tabclose<cr>", { desc = "tab [c]lose" })
vim.keymap.set("n", "<leader>to", "<cmd>tabonly<cr>", { desc = "tab [o]nly" })
vim.keymap.set("n", "<leader>tN", "<cmd>tabnew<cr>", { desc = "tab [N]ew" })

-- NOTE: Buffers hold the files in memory, Windows display them, and Tabs organize the workspace.
-- -- Use splits to view multiple files or parts of the same file side-by-side within one tab.
-- -- Use tabs to separate different tasks, contexts, or layouts that require distinct screen configurations.
-- -- You can extract a window into a new tab using Ctrl+w T

-- Terminal
-- Exit terminal mode in the builtin terminal with a shortcut that is a bit easier
-- for people to discover. Otherwise, you normally need to press <C-\><C-n>, which
-- is not what someone will guess without a bit more experience.
--
-- NOTE: This won't work in all terminal emulators/tmux/etc. Try your own mapping
-- or just use <C-\><C-n> to exit terminal mode
vim.keymap.set("t", "<Esc><Esc>", "<C-\\><C-n>", { desc = "Exit terminal mode" })

-- Lines
-- Break long lines
vim.keymap.set("n", "<leader>q", "gqq", { desc = "Format current line" })

-- vim: ts=2 sts=2 sw=2 et
