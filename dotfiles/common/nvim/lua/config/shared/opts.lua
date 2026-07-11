-- sets up shared vim options
--
-- local opt = vim.opt -- Vim optionals
local g = vim.g
local opt = vim.opt

-- Python
g.python3_host_prog = "~/.virtualenvs/base/bin/python"
g.python_host_prog = "~/.virtualenvs/base/bin/python"

-- Completion
opt.conceallevel = 2 -- obsidian.nvim requirement

-- Set the winbar content (displayed at the top of the window)
opt.winbar = "%=%m %f"
