local aucmd = vim.api.nvim_create_autocmd

-- Set relative line numbers in normal mode
aucmd({ "InsertEnter" }, {
  callback = function()
    local fname = vim.fn.bufname()
    if fname == "copilot-chat" or vim.bo.buftype == "nofile" then
      return
    end
    vim.opt_local.relativenumber = false
  end,
})

-- and absolute line numbers in insert mode
aucmd({ "InsertLeave" }, {
  callback = function()
    local fname = vim.fn.bufname()
    if fname == "copilot-chat" or vim.bo.buftype == "nofile" then
      return
    end
    vim.opt_local.relativenumber = true
  end,
})

-- Terminal
aucmd("TermOpen", {
  callback = function()
    vim.opt_local.number = false
    vim.opt_local.relativenumber = false
    vim.cmd("startinsert")
  end,
})
