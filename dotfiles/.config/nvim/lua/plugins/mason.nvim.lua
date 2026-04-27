-- Package Manager for Neovim and Emacs
-- Install and use LSPs, DAPs, Linters and Formatters
return {
  "mason-org/mason.nvim",
  opts = {
    ui = {
      icons = {
        package_installed = "✓",
        package_pending = "➜",
        package_uninstalled = "✗",
      },
    },
  },
}
