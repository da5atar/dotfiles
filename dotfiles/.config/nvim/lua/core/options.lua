-- sets up vim options

vim.opt.number = true             -- show line numbers
vim.opt.relativenumber = true     -- show relative line numbers

vim.opt.splitright = true         -- open new splits to the right
vim.opt.splitbelow = true         -- open new splits below

vim.opt.wrap = false              -- don't wrap lines

vim.opt.expandtab = true          -- use spaces instead of tabs
vim.opt.tabstop = 2               -- number of spaces per tab
vim.opt.shiftwidth = 2            -- number of spaces to use for indentation

vim.opt.clipboard = "unnamedplus" -- use system clipboard

vim.opt.scrolloff = 999           -- number of lines to keep above/below cursor

vim.opt.virtualedit = "block"     -- allow virtual editing in block mode

vim.opt.inccommand = "split"      -- show incremental search results in a split

vim.opt.ignorecase = true         -- ignore case in search

vim.opt.termguicolors = true      -- enable true color support
