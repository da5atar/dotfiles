local set = vim.keymap.set

-- Next typed closing delimiter: ', ", `, >, ), ], }
local next_delimiter = "/['\"`>\\)\\]\\}]"
-- Previous typed opening delimiter: ', ", `, <, (, {, [
local prev_delimiter = "?['\"`<\\(\\{\\[]"

-- Command mode
--
set("n", "<leader><leader>", ":", { desc = "Enter command" })

--

-- Images
set("n", "<Leader>i", "", { desc = "[I]mages" })
--

-- Quickly move out of pairs
set(
  "i",
  "ll",
  "<C-o>" .. next_delimiter .. "<CR><C-o>:nohlsearch<CR><C-o>a",
  { noremap = true, silent = true, desc = "After next closing delimiter" }
)

set(
  "i",
  "hh",
  "<C-o>" .. prev_delimiter .. "<CR><C-o>:nohlsearch<CR>",
  { noremap = true, silent = true, desc = "Before previous opening delimiter" }
)

function EscapePair()
  local closers = { ")", "]", "}", ">", "'", '"', "`", "," }

  local line = vim.api.nvim_get_current_line()
  local row, col0 = unpack(vim.api.nvim_win_get_cursor(0)) -- col0 is 0-based

  -- start AFTER the cursor so we never land on the closer “under” it
  local search_from = col0 + 1
  local after = line:sub(search_from + 1, -1) -- characters after cursor

  local best_pos = nil
  for _, closer in ipairs(closers) do
    local i = after:find(closer, 1, true) -- plain match
    if i and (best_pos == nil or i < best_pos) then
      best_pos = i
    end
  end

  if best_pos then
    -- + best_pos lands on the closer; +1 moves to the character after it
    vim.api.nvim_win_set_cursor(0, { row, (search_from + best_pos) })
  else
    -- no closer found: move one column forward
    vim.api.nvim_win_set_cursor(0, { row, col0 + 1 })
  end
end

set("i", "<C-l>", "<cmd>lua EscapePair('after')<CR>", { noremap = true, silent = true })

-- Normal Mode
--
-- Exit insert mode after creating a new line above or below the current line.
set("n", "o", "o<Esc>", { desc = "Open new line below" })
set("n", "O", "O<Esc>", { desc = "Open new line above" })
--

-- Images
set("n", "<Leader>i", "", { desc = "[I]mages" })
--

--

-- Visual mode
--
-- move line up and down
set("v", "J", ":m '>+1<CR>gv==kgvo<esc>=kgvo", { desc = "move highlighted text down" })
set("v", "K", ":m '<-2<CR>gv==jgvo<esc>=jgvo", { desc = "move highlighted text up" })

--
