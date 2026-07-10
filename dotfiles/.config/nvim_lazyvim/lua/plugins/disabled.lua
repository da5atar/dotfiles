-- disabled.lua
-- holds disabled plugins
-- --
-- stylua: ignore

if true then return {} end
return {
  -- Example: Disable bufferline
  -- { "akinsho/bufferline.nvim", enabled = false },
  --
  -- Other disabled plugins under this line.

  -- Disable Snacks plugin explorer feature:
  {
    "folke/snacks.nvim",
    keys = {
      { "<leader><leader>", false },
    },
    -- opts = {
    --   explorer = {
    --     enabled = false,
    --   },
    -- },
  },
}
