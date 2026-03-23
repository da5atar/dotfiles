-- nvim-rip-substitute.lua
-- find and replace alternative
-- https://github.com/chrisgrieser/nvim-rip-substitute
-- --
return {
  "chrisgrieser/nvim-rip-substitute",
  cmd = "RipSubstitute",
  opts = {},
  keys = {
    {
      "g/",
      function()
        require("rip-substitute").sub()
      end,
      mode = { "n", "x" },
      desc = " rip substitute",
    },
  },
}
