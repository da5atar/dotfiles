-- Show indentation and blankline
return {
  "lukas-reineke/indent-blankline.nvim",
  main = "ibl",
  ---@module "ibl"
  ---@type ibl.config
  config = function()
    local highlightLines = {
      "RainbowRed",
      "RainbowYellow",
      "RainbowBlue",
      "RainbowOrange",
      "RainbowGreen",
      "RainbowViolet",
      "RainbowCyan",
    }

    local highlightDimLines = {
      "RainbowDimRed",
      "RainbowDimYellow",
      "RainbowDimBlue",
      "RainbowDimOrange",
      "RainbowDimGreen",
      "RainbowDimViolet",
      "RainbowDimCyan",
    }

    local hooks = require("ibl.hooks")

    hooks.register(hooks.type.HIGHLIGHT_SETUP, function()
      vim.api.nvim_set_hl(0, "RainbowRed", { fg = "#8B0000" })
      vim.api.nvim_set_hl(0, "RainbowYellow", { fg = "#DAA520" })
      vim.api.nvim_set_hl(0, "RainbowBlue", { fg = "#4682B4" })
      vim.api.nvim_set_hl(0, "RainbowOrange", { fg = "#F19A66" })
      vim.api.nvim_set_hl(0, "RainbowGreen", { fg = "#2E8B57" })
      vim.api.nvim_set_hl(0, "RainbowViolet", { fg = "#8A2BE2" })
      vim.api.nvim_set_hl(0, "RainbowCyan", { fg = "#56B6F2" })
      vim.api.nvim_set_hl(0, "RainbowDimRed", { fg = "#E06C75" })
      vim.api.nvim_set_hl(0, "RainbowDimYellow", { fg = "#E5C07B" })
      vim.api.nvim_set_hl(0, "RainbowDimBlue", { fg = "#61AFEF" })
      vim.api.nvim_set_hl(0, "RainbowDimOrange", { fg = "#D19A66" })
      vim.api.nvim_set_hl(0, "RainbowDimGreen", { fg = "#98C379" })
      vim.api.nvim_set_hl(0, "RainbowDimViolet", { fg = "#C678DD" })
      vim.api.nvim_set_hl(0, "RainbowDimCyan", { fg = "#56B6C2" })
    end)

    vim.g.rainbow_delimiters = { highlight = highlightLines }

    require("ibl").setup({
      indent = {
        highlight = highlightDimLines,
        char = "┊",
        tab_char = "┊",
      },
      scope = {
        highlight = highlightLines,
        char = "▎",
      },
    })
  end,
}
