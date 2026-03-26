-- credits: https://github.com/Baguma03
return {
  {
    "goolord/alpha-nvim",
    event = "VimEnter",
    dependencies = { "nvim-tree/nvim-web-devicons", "ibhagwan/fzf-lua" },
    config = function()
      local alpha = require("alpha")
      local dashboard = require("alpha.themes.dashboard")

      -- Create a custom footer/message section
      local message = {
        type = "text",
        val = "What we assembled with trembling hands, rose to question its maker.",
        opts = {
          hl = "Comment", -- Using a subtle color; change to "Statement" for more pop
          position = "center",
        },
      }

      -- Helper function to convert image to ASCII
      local function get_image_header(path)
        local cmd = "ascii-image-converter " .. path .. " -b --width 180"

        local handle = io.popen(cmd)
        local result = handle:read("*a")
        handle:close()

        local lines = {}
        for line in result:gmatch("([^\n]*)\n?") do
          table.insert(lines, line)
        end
        return lines
      end

      -- Path to image
      local image_path = os.getenv("HOME") .. "/Pictures/adam-and-machine.png" -- set width to 50

      -- Set the header to the output of our function
      dashboard.section.header.val = get_image_header(image_path)

      -- Apply a colorscheme highlight group
      dashboard.section.header.opts.hl = "Statement"
      dashboard.section.buttons.opts.hl = "Number"

      -- Dashboard Buttons using fzf-lua
      dashboard.section.buttons.val = {
        dashboard.button("\\f", "󰈞  Find Files", ":FzfLua files<CR>", { desc = "Find Files" }),
        dashboard.button("\\r", "  Recent Files", ":FzfLua oldfiles<CR>", { desc = "Recent Files" }),
        dashboard.button("\\c", "󰚰  Command History", ":FzfLua command_history<CR>", { desc = "Command History" }),
        dashboard.button("\\C", "  Config", ":lua require('fzf-lua').files({cwd=vim.fn.stdpath('config')})<CR>",
          { desc = "Config" }),
        dashboard.button("\\U", "󰄉  Update", ":Lazy update<CR>", { desc = "Update" }),
        dashboard.button("Q", "󰅚  Quit", ":qa<CR>", { desc = "Quit" }),
      }

      -- Assemble the layout
      -- Insert the message between the header and the buttons
      dashboard.config.layout = {
        { type = "padding", val = 2 },
        dashboard.section.header,
        { type = "padding", val = 2 },
        message, -- Your new text message
        { type = "padding", val = 2 },
        dashboard.section.buttons,
        dashboard.section.footer,
      }

      -- Hiding the tildes
      vim.api.nvim_create_autocmd("User", {
        pattern = "AlphaReady",
        callback = function()
          vim.opt_local.fillchars = { eob = " " }
        end,
      })

      alpha.setup(dashboard.opts)
    end,
  },
}
