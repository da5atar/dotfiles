-- sets up vim options
--
local opt = vim.opt; -- Vim optionals
--
-- Hint: use `:h <option>` to figure out the meaning if needed

-- Clipboard & Mouse
opt.clipboard = "unnamedplus" -- Use system clipboard
opt.mouse = "a"               -- allow the mouse to be used in Nvim
--

-- Diagnostics
vim.diagnostic.config({
  float = { border = "rounded", source = "if_many" },
  jump = { float = true },
  -- signs = true,  -- Show signs for diagnostics
  -- severity_sort = true, -- Sort diagnostics by severity
  -- underline = true, -- Underline diagnostics
  -- update_in_insert = false, -- Do not update diagnostics in insert mode
  virtual_lines = true, -- Show virtual lines underneath for diagnostics
})
--

-- Folding
opt.foldmethod = "syntax"

-- Indentation
opt.expandtab = true   -- use spaces instead of tabs
opt.tabstop = 2        -- number of spaces per tab
opt.shiftwidth = 2     -- number of spaces to use for indentation
opt.smartindent = true -- Turn on smart indentation. See in the docs for more info
--

-- Misc
opt.completeopt = { "menu", "menuone", "noselect" }
opt.fixeol = false   -- Turn off appending new line in the end of a file
opt.swapfile = false -- no .swp file
--

-- Searching
opt.ignorecase = true    -- Ignore case if all characters in lower case
opt.joinspaces = false   -- Join multiple spaces in search
opt.smartcase = true     -- When there is a one capital letter search for exact match
opt.showmatch = true     -- Highlight search instances
opt.incsearch = true     -- search as characters are entered
opt.inccommand = "split" -- show incremental search results in a split
-- opt.hlsearch = false  -- do not highlight matches
--

-- UI config
opt.number = true         -- show line numbers
opt.relativenumber = true -- show relative line numbers
opt.cursorline = true     -- highlight cursor line underneath the cursor horizontally
opt.termguicolors = true  -- enable true color support
-- Buffer
opt.scrolloff = 999       -- number of lines to keep above/below cursor
opt.virtualedit = "block" -- allow virtual editing in block mode
opt.wrap = false          -- don't wrap lines
-- Window
opt.splitbelow = true     -- Put new windows below current
opt.splitright = true     -- Put new vertical splits to right
opt.winborder = "rounded" -- add rounded border for floating window
--

-- Wild Menu
opt.wildmenu = true
opt.wildmode = "longest:full,full"
--

-- vim: tabstop=2 shiftwidth=2 expandtab syntax=lua foldmethod=marker foldlevelstart=1
