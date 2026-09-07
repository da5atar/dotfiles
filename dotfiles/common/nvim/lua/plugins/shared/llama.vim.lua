return {
  "ggml-org/llama.vim",
  init = function()
    vim.g.llama_config = {
      enable_at_startup = true,
      show_info = 2,
      n_prefix = 1024,
      n_suffix = 1024,
      n_predict = 256,
      auto_fim = true,
      keymap_fim_trigger = "<C-F>",
      keymap_fim_accept_full = "<Tab>",
      keymap_fim_accept_line = "<S-Tab>",
      keymap_fim_accept_word = "<C-W>",
      keymap_fim_next = "<C-N>",
      keymap_fim_prev = "<C-P>",
      keymap_inst_trigger = "<leader>ali",
      keymap_inst_accept = "<Tab>",
      keymap_inst_cancel = "<Esc>",
      keymap_inst_rerun = "<leader>alr",
      keymap_inst_continue = "<leader>alc",
      keymap_debug_toggle = "",
    }
  end,
  vim.keymap.set({ "n", "v" }, "<leader>al", "", { desc = "Llama" }),
  vim.keymap.set(
    "n",
    "<leader>alt",
    ": silent LlamaToggle<CR>",
    { desc = "Toggle Llama", noremap = true, silent = true }
  ),
  vim.keymap.set(
    { "n", "v" },
    "<leader>ali",
    ": silent LlamaInstruct<CR>",
    { desc = "Toggle Instructions-based edits", noremap = true, silent = true }
  ),
  vim.keymap.set(
    { "n", "v" },
    "<leader>ald",
    ": silent LlamaDebugToggle<CR>",
    { desc = "Toggle Debug Panel", noremap = true, silent = true }
  ),
}
