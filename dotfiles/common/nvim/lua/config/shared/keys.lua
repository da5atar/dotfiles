local set = vim.keymap.set

-- Insert mode
--
-- Faster Escape
set("i", "jj", "<Esc>", { desc = "Faster Escape" })

-- Normal mode
--
-- Exit insert mode after creating a new line above or below the current line.
set("n", "o", "o<Esc>", { desc = "Open new line below" })
set("n", "O", "O<Esc>", { desc = "Open new line above" })
--

-- Images
set("n", "<Leader>i", "", { desc = "[I]mages" })
--

-- Lines
-- Break long lines
set("n", "<Leader>lf", "gqq", { desc = "Format current line" })

-- Visual mode
-- move line up and down
set("v", "J", ":m '>+1<CR>gv==kgvo<esc>=kgvo", { desc = "move highlighted text down" })
set("v", "K", ":m '<-2<CR>gv==jgvo<esc>=jgvo", { desc = "move highlighted text up" })
