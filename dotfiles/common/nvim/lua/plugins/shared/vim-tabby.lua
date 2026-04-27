return {
  {
    "TabbyML/vim-tabby",
    lazy = false,
    dependencies = {
      "neovim/nvim-lspconfig",
    },
    init = function()
      -- Workaround config: See https://github.com/TabbyML/vim-tabby/issues/40
      --
      local default_register_capability = vim.lsp.handlers["client/registerCapability"]
      if default_register_capability then
        vim.lsp.handlers["client/registerCapability"] = function(err, params, ctx, config)
          local client = ctx and ctx.client_id and vim.lsp.get_client_by_id(ctx.client_id) or nil
          if client and client.name == "tabby" and params and type(params.registrations) == "table" then
            local filtered = {}
            local dropped = {}

            for _, reg in ipairs(params.registrations) do
              local method = reg and reg.method
              local capability = method and vim.lsp.protocol._request_name_to_server_capability[method] or nil

              if capability then
                filtered[#filtered + 1] = reg
              else
                dropped[#dropped + 1] = method or "<missing method>"
              end
            end

            if #dropped > 0 then
              vim.schedule(function()
                vim.notify(
                  ("tabby: ignored unsupported dynamic registrations: %s"):format(table.concat(dropped, ", ")),
                  vim.log.levels.WARN
                )
              end)
            end

            params = vim.tbl_extend("force", params, { registrations = filtered })
          end

          return default_register_capability(err, params, ctx, config)
        end
      end

      -- your init config, if any
      vim.g.tabby_agent_start_command = { "npx", "tabby-agent", "--stdio" }
      vim.g.tabby_inline_completion_trigger = "auto"
    end,
  },
}
