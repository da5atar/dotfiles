local set = vim.keymap.set

-- Normal mode
--
-- Exit insert mode after creating a new line above or below the current line.
set("n", "o", "o<Esc>", { desc = "Open new line below" })
set("n", "O", "O<Esc>", { desc = "Open new line above" })
--

-- Insert mode
--
-- Faster Escape
set("i", "jj", "<Esc>", { desc = "Faster Escape" })

-- Command-line mode
--
-- Enter command-line mode
set("n", "<Leader><Leader>", ":", { desc = "Command-line mode" })
