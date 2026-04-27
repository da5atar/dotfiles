local bo = vim.bo
local fn = vim.fn
local wo = vim.wo
local api = vim.api
local cmd = vim.cmd
local lsp = vim.lsp
local opt = vim.opt
local set = vim.keymap.set
local diagnostic = vim.diagnostic

opt.termguicolors = true
cmd.colorscheme("habamax")

local function set_transparent() -- set UI component to transparent
  local groups = {
    "Normal",
    "NormalNC",
    "EndOfBuffer",
    "NormalFloat",
    "FloatBorder",
    "SignColumn",
    "StatusLine",
    "StatusLineNC",
    "TabLine",
    "TabLineFill",
    "TabLineSel",
    "ColorColumn",
  }
  for _, g in ipairs(groups) do
    api.nvim_set_hl(0, g, { bg = "none" })
  end
  api.nvim_set_hl(0, "TabLineFill", { bg = "none", fg = "#767676" })
end

set_transparent()

-- ============================================================================
-- OPTIONS
-- ============================================================================

-- Lines
opt.number = true         -- line number
opt.relativenumber = true -- relative line numbers
opt.cursorline = true     -- highlight current line
opt.wrap = false          -- do not wrap lines by default
opt.scrolloff = 10        -- keep 10 lines above/below cursor
opt.sidescrolloff = 10    -- keep 10 lines to left/right of cursor

-- Indentation
opt.tabstop = 2        -- tabwidth
opt.shiftwidth = 2     -- indent width
opt.softtabstop = 2    -- soft tab stop not tabs on tab/backspace
opt.expandtab = true   -- use spaces instead of tabs
opt.smartindent = true -- smart auto-indent
opt.autoindent = true  -- copy indent from current line

-- Search
opt.ignorecase = true -- case insensitive search
opt.smartcase = true  -- case sensitive if uppercase in string
opt.hlsearch = true   -- highlight search matches
opt.incsearch = true  -- show matches as you type

-- Completion
opt.signcolumn = "yes"                        -- always show a sign column
opt.colorcolumn = "100"                       -- show a column at 100 position chars
opt.showmatch = true                          -- highlights matching brackets
opt.cmdheight = 1                             -- single line command line
opt.completeopt = "menuone,noinsert,noselect" -- completion options
opt.showmode = false                          -- do not show the mode, instead have it in statusline
opt.pumheight = 10                            -- popup menu height
opt.pumblend = 10                             -- popup menu transparency
opt.winblend = 0                              -- floating window transparency
opt.conceallevel = 2                          -- obsidian requirement
opt.concealcursor = ""                        -- do not hide cursorline in markup
opt.lazyredraw = true                         -- do not redraw during macros
opt.synmaxcol = 300                           -- syntax highlighting limit
opt.fillchars = { eob = " " }                 -- hide "~" on empty lines

-- Persist undo history
local undodir = fn.expand("~/.vim/undodir")
if
    fn.isdirectory(undodir) == 0 -- create undodir if nonexistent
then
  fn.mkdir(undodir, "p")
end

opt.backup = false                  -- do not create a backup file
opt.writebackup = false             -- do not write to a backup file
opt.swapfile = false                -- do not create a swapfile
opt.undofile = true                 -- do create an undo file
opt.undodir = undodir               -- set the undo directory
opt.updatetime = 300                -- faster completion
opt.timeoutlen = 500                -- timeout duration
opt.ttimeoutlen = 50                -- key code timeout
opt.autoread = true                 -- auto-reload changes if outside of neovim
opt.autowrite = false               -- do not auto-save

opt.hidden = true                   -- allow hidden buffers
opt.errorbells = false              -- no error sounds
opt.backspace = "indent,eol,start"  -- better backspace behaviour
opt.autochdir = false               -- do not autochange directories
opt.iskeyword:append("-")           -- include - in words
opt.path:append("**")               -- include subdirs in search
opt.selection = "inclusive"         -- include last char in selection
opt.mouse = "a"                     -- enable mouse support
opt.clipboard:append("unnamedplus") -- use system clipboard
opt.modifiable = true               -- allow buffer modifications
opt.encoding = "utf-8"              -- set encoding

-- Block and blinking cursor in normal, insert, visual, and replace modes
-- vim.opt.guicursor = "n-v-c:block,i-ci-ve:block,r-cr:hor20,o:hor50,a:blinkwait700-blinkoff400-blinkon250-Cursor/lCursor,sm:block-blinkwait175-blinkoff150-blinkon175"

-- Folding: requires treesitter available at runtime; safe fallback if not
opt.foldmethod = "expr"                          -- use expression for folding
opt.foldexpr = "v:lua.vim.treesitter.foldexpr()" -- use treesitter for folding
opt.foldlevel = 99                               -- start with all folds open

opt.splitbelow = true                            -- horizontal splits go below
opt.splitright = true                            -- vertical splits go right

opt.wildmenu = true                              -- tab completion
opt.wildmode =
"longest:full,full"                              -- complete longest common match, full completion list, cycle through with Tab
opt.diffopt:append("linematch:60")               -- improve diff display
opt.redrawtime = 10000                           -- increase neovim redraw tolerance
opt.maxmempattern = 20000                        -- increase max memory

-- ============================================================================
-- STATUSLINE
-- ============================================================================

-- Git branch function with caching and Nerd Font icon
local cached_branch = ""
local last_check = 0
local function git_branch()
  local now = vim.loop.now()
  if now - last_check > 5000 then -- Check every 5 seconds
    cached_branch = fn.system("git branch --show-current 2>/dev/null | tr -d '\n'")
    last_check = now
  end
  if cached_branch ~= "" then
    return " \u{e725} " .. cached_branch .. " " -- nf-dev-git_branch
  end
  return ""
end

-- File type with Nerd Font icon
local function file_type()
  local ft = bo.filetype
  local icons = {
    lua = "\u{e620} ",        -- nf-dev-lua
    python = "\u{e73c} ",     -- nf-dev-python
    javascript = "\u{e74e} ", -- nf-dev-javascript
    typescript = "\u{e628} ", -- nf-dev-typescript
    javascriptreact = "\u{e7ba} ",
    typescriptreact = "\u{e7ba} ",
    html = "\u{e736} ",     -- nf-dev-html5
    css = "\u{e749} ",      -- nf-dev-css3
    scss = "\u{e749} ",
    json = "\u{e60b} ",     -- nf-dev-json
    markdown = "\u{e73e} ", -- nf-dev-markdown
    vim = "\u{e62b} ",      -- nf-dev-vim
    sh = "\u{f489} ",       -- nf-oct-terminal
    bash = "\u{f489} ",
    zsh = "\u{f489} ",
    rust = "\u{e7a8} ",  -- nf-dev-rust
    go = "\u{e724} ",    -- nf-dev-go
    c = "\u{e61e} ",     -- nf-dev-c
    cpp = "\u{e61d} ",   -- nf-dev-cplusplus
    java = "\u{e738} ",  -- nf-dev-java
    php = "\u{e73d} ",   -- nf-dev-php
    ruby = "\u{e739} ",  -- nf-dev-ruby
    swift = "\u{e755} ", -- nf-dev-swift
    kotlin = "\u{e634} ",
    dart = "\u{e798} ",
    elixir = "\u{e62d} ",
    haskell = "\u{e777} ",
    sql = "\u{e706} ",
    yaml = "\u{f481} ",
    toml = "\u{e615} ",
    xml = "\u{f05c} ",
    dockerfile = "\u{f308} ", -- nf-linux-docker
    gitcommit = "\u{f418} ",  -- nf-oct-git_commit
    gitconfig = "\u{f1d3} ",  -- nf-fa-git
    vue = "\u{fd42} ",        -- nf-md-vuejs
    svelte = "\u{e697} ",
    astro = "\u{e628} ",
  }

  if ft == "" then
    return " \u{f15b} " -- nf-fa-file_o
  end

  return ((icons[ft] or " \u{f15b} ") .. ft)
end

-- File size with Nerd Font icon
local function file_size()
  local size = fn.getfsize(fn.expand("%"))
  if size < 0 then
    return ""
  end
  local size_str
  if size < 1024 then
    size_str = size .. "B"
  elseif size < 1024 * 1024 then
    size_str = string.format("%.1fK", size / 1024)
  else
    size_str = string.format("%.1fM", size / 1024 / 1024)
  end
  return " \u{f016} " .. size_str .. " " -- nf-fa-file_o
end

-- Mode indicators with Nerd Font icons
local function mode_icon()
  local mode = fn.mode()
  local modes = {
    n = " \u{f121}  NORMAL",
    i = " \u{f11c}  INSERT",
    v = " \u{f0168} VISUAL",
    V = " \u{f0168} V-LINE",
    ["\22"] = " \u{f0168} V-BLOCK",
    c = " \u{f120} COMMAND",
    s = " \u{f0c5} SELECT",
    S = " \u{f0c5} S-LINE",
    ["\19"] = " \u{f0c5} S-BLOCK",
    R = " \u{f044} REPLACE",
    r = " \u{f044} REPLACE",
    ["!"] = " \u{f489} SHELL",
    t = " \u{f120} TERMINAL",
  }
  return modes[mode] or (" \u{f059} " .. mode)
end

-- _G is a global namespace
_G.mode_icon = mode_icon
_G.git_branch = git_branch
_G.file_type = file_type
_G.file_size = file_size

vim.cmd([[
  highlight StatusLineBold gui=bold cterm=bold
]])

-- Function to change statusline based on window focus
local function setup_dynamic_statusline()
  api.nvim_create_autocmd({ "WinEnter", "BufEnter" }, {
    callback = function()
      vim.opt_local.statusline = table.concat({
        "  ",
        "%#StatusLineBold#",
        "%{v:lua.mode_icon()}",
        "%#StatusLine#",
        " \u{e0b1} %f %h%m%r",  -- nf-pl-left_hard_divider
        "%{v:lua.git_branch()}",
        "\u{e0b1} ",            -- nf-pl-left_hard_divider
        "%{v:lua.file_type()}",
        "\u{e0b1} ",            -- nf-pl-left_hard_divider
        "%{v:lua.file_size()}",
        "%=",                   -- Right-align everything after this
        " \u{f017} %l:%c  %P ", -- nf-fa-clock_o for line/col
      })
    end,
  })
  api.nvim_set_hl(0, "StatusLineBold", { bold = true })

  api.nvim_create_autocmd({ "WinLeave", "BufLeave" }, {
    callback = function()
      vim.opt_local.statusline = "  %f %h%m%r \u{e0b1} %{v:lua.file_type()} %=  %l:%c   %P "
    end,
  })
end

setup_dynamic_statusline()

-- ============================================================================
-- KEYMAPS
-- ============================================================================

vim.g.mapleader = " "       -- space for leader
vim.g.maplocalleader = "\\" -- Backslash for localleader

-- better movement in wrapped text
set("n", "j", function()
  return vim.v.count == 0 and "gj" or "j"
end, { expr = true, silent = true, desc = "Down (wrap-aware)" })
set("n", "k", function()
  return vim.v.count == 0 and "gk" or "k"
end, { expr = true, silent = true, desc = "Up (wrap-aware)" })

set("n", "<leader>c", ":nohlsearch<CR>", { desc = "Clear search highlights" })

set("n", "n", "nzzzv", { desc = "Next search result (centered)" })
set("n", "N", "Nzzzv", { desc = "Previous search result (centered)" })
set("n", "<C-d>", "<C-d>zz", { desc = "Half page down (centered)" })
set("n", "<C-u>", "<C-u>zz", { desc = "Half page up (centered)" })

set("x", "<leader>p", '"_dP', { desc = "Paste without yanking" })
set({ "n", "v" }, "<leader>x", '"_d', { desc = "Delete without yanking" })

set("n", "<leader>bn", ":bnext<CR>", { desc = "Next buffer" })
set("n", "<leader>bp", ":bprevious<CR>", { desc = "Previous buffer" })

set("n", "<C-h>", "<C-w>h", { desc = "Move to left window" })
set("n", "<C-j>", "<C-w>j", { desc = "Move to bottom window" })
set("n", "<C-k>", "<C-w>k", { desc = "Move to top window" })
set("n", "<C-l>", "<C-w>l", { desc = "Move to right window" })

set("n", "<leader>sv", ":vsplit<CR>", { desc = "Split window vertically" })
set("n", "<leader>sh", ":split<CR>", { desc = "Split window horizontally" })
set("n", "<C-Up>", ":resize +2<CR>", { desc = "Increase window height" })
set("n", "<C-Down>", ":resize -2<CR>", { desc = "Decrease window height" })
set("n", "<C-Left>", ":vertical resize -2<CR>", { desc = "Decrease window width" })
set("n", "<C-Right>", ":vertical resize +2<CR>", { desc = "Increase window width" })

set("n", "<A-j>", ":m .+1<CR>==", { desc = "Move line down" })
set("n", "<A-k>", ":m .-2<CR>==", { desc = "Move line up" })
set("v", "<A-j>", ":m '>+1<CR>gv=gv", { desc = "Move selection down" })
set("v", "<A-k>", ":m '<-2<CR>gv=gv", { desc = "Move selection up" })

set("v", "<", "<gv", { desc = "Indent left and reselect" })
set("v", ">", ">gv", { desc = "Indent right and reselect" })

set("n", "J", "mzJ`z", { desc = "Join lines and keep cursor position" })

-- Show and yank full file path
set("n", "<leader>pa", function()
  local path = fn.expand("%:p")
  fn.setreg("+", path)
  print("file:", path)
end, { desc = "Copy full file path" })

set("n", "<leader>td", function()
  vim.diagnostic.enable(not vim.diagnostic.is_enabled())
end, { desc = "Toggle diagnostics" })

-- ============================================================================
-- AUTOCMDS
-- ============================================================================

local augroup = vim.api.nvim_create_augroup("UserConfig", { clear = true })

-- Format on save (ONLY real file buffers, ONLY when efm is attached)
api.nvim_create_autocmd("BufWritePre", {
  group = augroup,
  pattern = {
    "*.lua",
    "*.py",
    "*.go",
    "*.js",
    "*.jsx",
    "*.ts",
    "*.tsx",
    "*.json",
    "*.css",
    "*.scss",
    "*.html",
    "*.sh",
    "*.bash",
    "*.zsh",
    "*.c",
    "*.cpp",
    "*.h",
    "*.hpp",
  },
  callback = function(args)
    -- avoid formatting non-file buffers (helps prevent weird write prompts)
    if bo[args.buf].buftype ~= "" then
      return
    end
    if not bo[args.buf].modifiable then
      return
    end
    if api.nvim_buf_get_name(args.buf) == "" then
      return
    end

    local has_efm = false
    for _, c in ipairs(lsp.get_clients({ bufnr = args.buf })) do
      if c.name == "efm" then
        has_efm = true
        break
      end
    end
    if not has_efm then
      return
    end

    pcall(lsp.buf.format, {
      bufnr = args.buf,
      timeout_ms = 2000,
      filter = function(c)
        return c.name == "efm"
      end,
    })
  end,
})

-- highlight yanked text
api.nvim_create_autocmd("TextYankPost", {
  group = augroup,
  callback = function()
    vim.hl.on_yank()
  end,
})

-- return to last cursor position
api.nvim_create_autocmd("BufReadPost", {
  group = augroup,
  desc = "Restore last cursor position",
  callback = function()
    if vim.o.diff then -- except in diff mode
      return
    end

    local last_pos = vim.api.nvim_buf_get_mark(0, '"') -- {line, col}
    local last_line = vim.api.nvim_buf_line_count(0)

    local row = last_pos[1]
    if row < 1 or row > last_line then
      return
    end

    pcall(vim.api.nvim_win_set_cursor, 0, last_pos)
  end,
})

-- wrap, linebreak and spellcheck on markdown and text files
api.nvim_create_autocmd("FileType", {
  group = augroup,
  pattern = { "markdown", "text", "gitcommit" },
  callback = function()
    vim.opt_local.wrap = true
    vim.opt_local.linebreak = true
    vim.opt_local.spell = true
  end,
})

-- ============================================================================
-- PLUGINS (vim.pack)
-- ============================================================================
vim.pack.add({
  "https://www.github.com/lewis6991/gitsigns.nvim",
  "https://www.github.com/echasnovski/mini.nvim",
  "https://www.github.com/ibhagwan/fzf-lua",
  "https://www.github.com/nvim-tree/nvim-tree.lua",
  {
    src = "https://github.com/nvim-treesitter/nvim-treesitter",
    branch = "main",
    build = ":TSUpdate",
  },
  -- Language Server Protocols
  "https://www.github.com/neovim/nvim-lspconfig",
  "https://github.com/mason-org/mason.nvim",
  "https://github.com/creativenull/efmls-configs-nvim",
  {
    src = "https://github.com/saghen/blink.cmp",
    version = vim.version.range("1.*"),
  },
  "https://github.com/L3MON4D3/LuaSnip",
  "https://github.com/obsidian-nvim/obsidian.nvim",
  "https://github.com/folke/which-key.nvim",
})

-- ============================================================================
-- PLUGIN CONFIGS
-- ============================================================================

local setup_treesitter = function()
  local treesitter = require("nvim-treesitter")
  treesitter.setup({})
  local ensure_installed = {
    "vim",
    "vimdoc",
    "rust",
    "c",
    "cpp",
    "go",
    "html",
    "css",
    "javascript",
    "json",
    "lua",
    "markdown",
    "python",
    "typescript",
    "vue",
    "svelte",
    "bash",
  }

  local config = require("nvim-treesitter.config")

  local already_installed = config.get_installed()
  local parsers_to_install = {}

  for _, parser in ipairs(ensure_installed) do
    if not vim.tbl_contains(already_installed, parser) then
      table.insert(parsers_to_install, parser)
    end
  end

  if #parsers_to_install > 0 then
    treesitter.install(parsers_to_install)
  end

  local group = vim.api.nvim_create_augroup("TreeSitterConfig", { clear = true })
  api.nvim_create_autocmd("FileType", {
    group = group,
    callback = function(args)
      if vim.list_contains(treesitter.get_installed(), vim.treesitter.language.get_lang(args.match)) then
        vim.treesitter.start(args.buf)
      end
    end,
  })
end

setup_treesitter()

local function setup_obsidian()
  require("obsidian").setup({
    legacy_commands = false,
    workspaces = { { name = "My_Files", path = "~/Library/CloudStorage/Dropbox/My_Files" } },
    picker = { name = "fzf-lua" },
  })

  set("n", "<leader>nn", function()
    cmd("Obsidian workspace")
    vim.defer_fn(function()
      cmd("Obsidian new")
    end, 500)
  end, { desc = "New note" })
  set("n", "<leader>nf", "<cmd>Obsidian quick_switch<cr>", { desc = "Find note" })
  set("n", "<leader>ns", "<cmd>Obsidian search<cr>", { desc = "Search notes" })
  set("n", "<leader>nt", "<cmd>Obsidian today<cr>", { desc = "Today's daily note" })
  set("n", "<leader>nw", "<cmd>Obsidian workspace<cr>", { desc = "Switch workspace" })
end

setup_obsidian()

require("nvim-tree").setup({
  view = {
    width = 35,
  },
  filters = {
    dotfiles = false,
  },
  renderer = {
    group_empty = true,
  },
})
set("n", "<leader>e", function()
  require("nvim-tree.api").tree.toggle()
end, { desc = "Toggle NvimTree" })

api.nvim_set_hl(0, "NvimTreeNormalNC", { bg = "none" })
api.nvim_set_hl(0, "SignColumn", { bg = "none" })
api.nvim_set_hl(0, "NvimTreeSignColumn", { bg = "none" })
api.nvim_set_hl(0, "NvimTreeNormal", { bg = "none" })
api.nvim_set_hl(0, "NvimTreeWinSeparator", { fg = "#2a2a2a", bg = "none" })
api.nvim_set_hl(0, "NvimTreeEndOfBuffer", { bg = "none" })

require("fzf-lua").setup({})

set("n", "<leader>ff", function()
  require("fzf-lua").files()
end, { desc = "FZF Files" })
set("n", "<leader>fg", function()
  require("fzf-lua").live_grep()
end, { desc = "FZF Live Grep" })
set("n", "<leader>fb", function()
  require("fzf-lua").buffers()
end, { desc = "FZF Buffers" })
set("n", "<leader>fh", function()
  require("fzf-lua").help_tags()
end, { desc = "FZF Help Tags" })
set("n", "<leader>fx", function()
  require("fzf-lua").diagnostics_document()
end, { desc = "FZF Diagnostics Document" })
set("n", "<leader>fX", function()
  require("fzf-lua").diagnostics_workspace()
end, { desc = "FZF Diagnostics Workspace" })

require("mini.ai").setup({})
require("mini.comment").setup({})
require("mini.move").setup({})
require("mini.surround").setup({})
require("mini.cursorword").setup({})
require("mini.indentscope").setup({})
require("mini.pairs").setup({})
require("mini.trailspace").setup({})
require("mini.bufremove").setup({})
require("mini.notify").setup({})
require("mini.icons").setup({})

require("gitsigns").setup({
  signs = {
    add = { text = "\u{2590}" },          -- ▏
    change = { text = "\u{2590}" },       -- ▐
    delete = { text = "\u{2590}" },       -- ◦
    topdelete = { text = "\u{25e6}" },    -- ◦
    changedelete = { text = "\u{25cf}" }, -- ●
    untracked = { text = "\u{25cb}" },    -- ○
  },
  signcolumn = true,
  current_line_blame = false,
})

require("mason").setup({})

set("n", "]h", function()
  require("gitsigns").nav_hunk("next")
end, { desc = "Next git hunk" })
set("n", "[h", function()
  require("gitsigns").nav_hunk("prev")
end, { desc = "Previous git hunk" })
set("n", "<leader>hs", function()
  require("gitsigns").stage_hunk()
end, { desc = "Stage hunk" })
set("n", "<leader>hr", function()
  require("gitsigns").reset_hunk()
end, { desc = "Reset hunk" })
set("n", "<leader>hp", function()
  require("gitsigns").preview_hunk()
end, { desc = "Preview hunk" })
set("n", "<leader>hb", function()
  require("gitsigns").blame_line({ full = true })
end, { desc = "Blame line" })
set("n", "<leader>hB", function()
  require("gitsigns").toggle_current_line_blame()
end, { desc = "Toggle inline blame" })
set("n", "<leader>hd", function()
  require("gitsigns").diffthis()
end, { desc = "Diff this" })

-- which-key
local wk = require("which-key")
wk.setup({
  config = function()
    set("n", "<leader>?", function()
      wk.show({ global = false })
    end, { desc = "Buffer Local Keymaps (which-key)" })
  end,
})

-- ============================================================================
-- LSP, Linting, Formatting & Completion
-- ============================================================================

local diagnostic_signs = {
  Error = " ",
  Warn = " ",
  Hint = "",
  Info = "",
}

diagnostic.config({
  virtual_text = { prefix = "●", spacing = 4 },
  signs = {
    text = {
      [diagnostic.severity.ERROR] = diagnostic_signs.Error,
      [diagnostic.severity.WARN] = diagnostic_signs.Warn,
      [diagnostic.severity.INFO] = diagnostic_signs.Info,
      [diagnostic.severity.HINT] = diagnostic_signs.Hint,
    },
  },
  underline = true,
  update_in_insert = false,
  severity_sort = true,
  float = {
    border = "rounded",
    source = true,
    header = "",
    prefix = "",
    focusable = false,
    style = "minimal",
  },
})

do
  local orig = lsp.util.open_floating_preview
  function lsp.util.open_floating_preview(contents, syntax, opts, ...)
    opts = opts or {}
    opts.border = opts.border or "rounded"
    return orig(contents, syntax, opts, ...)
  end
end

local function lsp_on_attach(ev)
  local client = lsp.get_client_by_id(ev.data.client_id)
  if not client then
    return
  end

  local bufnr = ev.buf
  local opts = { noremap = true, silent = true, buffer = bufnr }

  set("n", "<leader>gd", function()
    require("fzf-lua").lsp_definitions({ jump_to_single_result = true })
  end, opts)

  set("n", "<leader>gD", lsp.buf.definition, opts)

  set("n", "<leader>gS", function()
    vim.cmd("vsplit")
    lsp.buf.definition()
  end, opts)

  set("n", "<leader>ca", lsp.buf.code_action, opts)
  set("n", "<leader>rn", lsp.buf.rename, opts)

  set("n", "<leader>D", function()
    diagnostic.open_float({ scope = "line" })
  end, opts)
  set("n", "<leader>d", function()
    diagnostic.open_float({ scope = "cursor" })
  end, opts)
  set("n", "<leader>nd", function()
    diagnostic.jump({ count = 1 })
  end, opts)

  set("n", "<leader>pd", function()
    diagnostic.jump({ count = -1 })
  end, opts)

  set("n", "K", lsp.buf.hover, opts)

  set("n", "<leader>fd", function()
    require("fzf-lua").lsp_definitions({ jump_to_single_result = true })
  end, opts)
  set("n", "<leader>fr", function()
    require("fzf-lua").lsp_references()
  end, opts)
  set("n", "<leader>ft", function()
    require("fzf-lua").lsp_typedefs()
  end, opts)
  set("n", "<leader>fs", function()
    require("fzf-lua").lsp_document_symbols()
  end, opts)
  set("n", "<leader>fw", function()
    require("fzf-lua").lsp_workspace_symbols()
  end, opts)
  set("n", "<leader>fi", function()
    require("fzf-lua").lsp_implementations()
  end, opts)

  if client:supports_method("textDocument/codeAction", bufnr) then
    set("n", "<leader>oi", function()
      lsp.buf.code_action({
        context = { only = { "source.organizeImports" }, diagnostics = {} },
        apply = true,
        bufnr = bufnr,
      })
      vim.defer_fn(function()
        lsp.buf.format({ bufnr = bufnr })
      end, 50)
    end, opts)
  end
end

vim.api.nvim_create_autocmd("LspAttach", { group = augroup, callback = lsp_on_attach })

set("n", "<leader>q", function()
  diagnostic.setloclist({ open = true })
end, { desc = "Open diagnostic list" })
set("n", "<leader>dl", diagnostic.open_float, { desc = "Show line diagnostics" })

require("blink.cmp").setup({
  keymap = {
    preset = "none",
    ["<C-Space>"] = { "show", "hide" },
    ["<CR>"] = { "accept", "fallback" },
    ["<C-j>"] = { "select_next", "fallback" },
    ["<C-k>"] = { "select_prev", "fallback" },
    ["<Tab>"] = { "snippet_forward", "fallback" },
    ["<S-Tab>"] = { "snippet_backward", "fallback" },
  },
  appearance = { nerd_font_variant = "mono" },
  completion = { menu = { auto_show = true } },
  sources = { default = { "lsp", "path", "buffer", "snippets" } },
  snippets = {
    expand = function(snippet)
      require("luasnip").lsp_expand(snippet)
    end,
  },

  fuzzy = {
    implementation = "prefer_rust",
    prebuilt_binaries = { download = true },
  },
})

lsp.config["*"] = {
  capabilities = require("blink.cmp").get_lsp_capabilities(),
}

lsp.config("lua_ls", {
  settings = {
    Lua = {
      diagnostics = { globals = { "vim" } },
      telemetry = { enable = false },
    },
  },
})
lsp.config("pyright", {})
lsp.config("bashls", {})
lsp.config("ts_ls", {})
lsp.config("gopls", {})
lsp.config("clangd", {})

do
  local luacheck = require("efmls-configs.linters.luacheck")
  local stylua = require("efmls-configs.formatters.stylua")

  local flake8 = require("efmls-configs.linters.flake8")
  local black = require("efmls-configs.formatters.black")

  local prettier = require("efmls-configs.formatters.prettier")
  local eslint = require("efmls-configs.linters.eslint")

  local fixjson = require("efmls-configs.formatters.fixjson")

  local shellcheck = require("efmls-configs.linters.shellcheck")
  local shfmt = require("efmls-configs.formatters.shfmt")

  local cpplint = require("efmls-configs.linters.cpplint")
  local clangfmt = require("efmls-configs.formatters.clang_format")

  local go_revive = require("efmls-configs.linters.go_revive")
  local gofumpt = require("efmls-configs.formatters.gofumpt")

  lsp.config("efm", {
    filetypes = {
      "c",
      "cpp",
      "css",
      "go",
      "html",
      "javascript",
      "javascriptreact",
      "json",
      "jsonc",
      "lua",
      "markdown",
      "python",
      "sh",
      "typescript",
      "typescriptreact",
      "vue",
      "svelte",
    },
    init_options = { documentFormatting = true },
    settings = {
      languages = {
        c = { clangfmt, cpplint },
        go = { gofumpt, go_revive },
        cpp = { clangfmt, cpplint },
        css = { prettier },
        html = { prettier },
        javascript = { eslint, prettier },
        javascriptreact = { eslint, prettier },
        json = { eslint, fixjson },
        jsonc = { eslint, fixjson },
        lua = { luacheck, stylua },
        markdown = { prettier },
        python = { flake8, black },
        sh = { shellcheck, shfmt },
        typescript = { eslint, prettier },
        typescriptreact = { eslint, prettier },
        vue = { eslint, prettier },
        svelte = { eslint, prettier },
      },
    },
  })
end

lsp.enable({
  "lua_ls",
  "pyright",
  "bashls",
  "ts_ls",
  "gopls",
  "clangd",
  "efm",
})

-- ============================================================================
-- FLOATING TERMINAL
-- ============================================================================

api.nvim_create_autocmd("TermClose", {
  group = augroup,
  callback = function()
    if vim.v.event.status == 0 then
      vim.api.nvim_buf_delete(0, {})
    end
  end,
})

api.nvim_create_autocmd("TermOpen", {
  group = augroup,
  callback = function()
    vim.opt_local.number = false
    vim.opt_local.relativenumber = false
    vim.opt_local.signcolumn = "no"
  end,
})

local terminal_state = { buf = nil, win = nil, is_open = false }

local function FloatingTerminal()
  if terminal_state.is_open and terminal_state.win and vim.api.nvim_win_is_valid(terminal_state.win) then
    api.nvim_win_close(terminal_state.win, false)
    terminal_state.is_open = false
    return
  end

  if not terminal_state.buf or not vim.api.nvim_buf_is_valid(terminal_state.buf) then
    terminal_state.buf = vim.api.nvim_create_buf(false, true)
    bo[terminal_state.buf].bufhidden = "hide"
  end

  local width = math.floor(vim.o.columns * 0.8)
  local height = math.floor(vim.o.lines * 0.8)
  local row = math.floor((vim.o.lines - height) / 2)
  local col = math.floor((vim.o.columns - width) / 2)

  terminal_state.win = vim.api.nvim_open_win(terminal_state.buf, true, {
    relative = "editor",
    width = width,
    height = height,
    row = row,
    col = col,
    style = "minimal",
    border = "rounded",
  })

  wo[terminal_state.win].winblend = 0
  wo[terminal_state.win].winhighlight = "Normal:FloatingTermNormal,FloatBorder:FloatingTermBorder"
  api.nvim_set_hl(0, "FloatingTermNormal", { bg = "none" })
  api.nvim_set_hl(0, "FloatingTermBorder", { bg = "none" })

  local has_terminal = false
  local lines = api.nvim_buf_get_lines(terminal_state.buf, 0, -1, false)
  for _, line in ipairs(lines) do
    if line ~= "" then
      has_terminal = true
      break
    end
  end
  if not has_terminal then
    fn.termopen(os.getenv("SHELL"))
  end

  terminal_state.is_open = true
  cmd("startinsert")

  api.nvim_create_autocmd("BufLeave", {
    buffer = terminal_state.buf,
    callback = function()
      if terminal_state.is_open and terminal_state.win and api.nvim_win_is_valid(terminal_state.win) then
        api.nvim_win_close(terminal_state.win, false)
        terminal_state.is_open = false
      end
    end,
    once = true,
  })
end

set("n", "<leader>t", FloatingTerminal, { noremap = true, silent = true, desc = "Toggle floating terminal" })
set("t", "<Esc>", function()
  if terminal_state.is_open and terminal_state.win and api.nvim_win_is_valid(terminal_state.win) then
    api.nvim_win_close(terminal_state.win, false)
    terminal_state.is_open = false
  end
end, { noremap = true, silent = true, desc = "Close floating terminal" })
