return {
  "3rd/image.nvim",
  opts = {
    backend = "kitty",
    processor = "magick_rock",
    integrations = {
      -- Notice these are the settings for markdown files
      markdown = {
        enabled = true,
        clear_in_insert_mode = false,
        download_remote_images = true,
        only_render_image_at_cursor = false,
        -- markdown extensions (ie. quarto) can go here
        filetypes = { "markdown", "vimwiki" },
      },
      neorg = {
        enabled = true,
        clear_in_insert_mode = false,
        download_remote_images = true,
        only_render_image_at_cursor = false,
        filetypes = { "norg" },
      },
      -- This is disabled by default
      -- Detect and render images referenced in HTML files
      -- Make sure you have an html treesitter parser installed
      html = {
        enabled = true,
      },
      -- This is disabled by default
      -- Detect and render images referenced in CSS files
      -- Make sure you have a css treesitter parser installed
      css = {
        enabled = true,
      },
    },
    max_width = nil,
    max_height = nil,
    max_width_window_percentage = nil,
    max_height_window_percentage = 40,

    -- toggles images when windows are overlapped
    window_overlap_clear_enabled = true,
    window_overlap_clear_ft_ignore = { "cmp_menu", "cmp_docs", "" },

    -- auto show/hide images when the editor gains/looses focus
    editor_only_render_when_focused = true,

    -- auto show/hide images in the correct tmux window
    -- In the tmux.conf add `set -g visual-activity off`
    tmux_show_only_in_active_window = true,

    -- render image files as images when opened
    hijack_file_patterns = { "*.png", "*.jpg", "*.jpeg", "*.gif", "*.webp", "*.avif" },
  },
}
