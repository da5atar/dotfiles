-- See https://neovide.dev/configuration.html
--
if vim.g.neovide then
  -- Put anything you want to happen only in Neovide here
  -- Font
  vim.o.guifont = "MonaspiceRn Nerd Font:h14"
  --
  -- Window blur
  vim.g.neovide_window_blurred = true
  --
  -- Floating blur amount
  vim.g.neovide_floating_blur_amount_x = 4.0
  vim.g.neovide_floating_blur_amount_y = 4.0
  --
  -- Floating blur shadow
  vim.g.neovide_floating_shadow = true
  vim.g.neovide_floating_z_height = 10
  vim.g.neovide_light_angle_degrees = 45
  vim.g.neovide_light_radius = 5
  --
  -- Opacity
  vim.g.neovide_opacity = 0.8
  vim.g.neovide_normal_opacity = 0.8
  --
  -- Padding
  vim.g.neovide_padding_top = 10
  vim.g.neovide_padding_bottom = 10
  vim.g.neovide_padding_right = 10
  vim.g.neovide_padding_left = 10
  -- Position animation length
  vim.g.neovide_position_animation_length = 0.15
  --
  -- Scroll animation length
  vim.g.neovide_scroll_animation_length = 0.3
  --
  -- Progress bar
  vim.g.neovide_progress_bar_enabled = true
  vim.g.neovide_progress_bar_height = 5.0
  vim.g.neovide_progress_bar_animation_speed = 200.0
  vim.g.neovide_progress_bar_hide_delay = 0.2
  --
  -- Hiding the mouse when typing
  vim.g.neovide_hide_mouse_when_typing = true
  --
  -- Underline automatic scaling
  vim.g.neovide_underline_stroke_scale = 1.0
  --
  -- Theme
  vim.g.neovide_theme = "auto"
  --
  -- Layer grouping
  vim.g.experimental_layer_grouping = true
  --
  -- Confirm quit
  vim.g.neovide_confirm_quit = true
  --
  -- Full screen
  vim.g.neovide_fullscreen = true
  --
  -- Simple full screen
  vim.g.neovide_macos_simple_fullscreen = true --
  -- Profiler
  vim.g.neovide_profiler = false
  --
  -- Cursor hack (prevents the cursor from flickering)
  vim.g.neovide_cursor_hack = true
  --
  -- Highlight matching pairs
  vim.g.neovide_highlight_matching_pair = true
  --
  -- Mac Option key is Meta
  vim.g.neovide_input_macos_option_key_is_meta = "only_left"
  --
  -- Cursor settings
  -- Animation length
  vim.g.neovide_cursor_animation_length = 0.15
  --
  -- Short animation length
  vim.g.neovide_cursor_short_animation_length = 0.04
  --
  -- Animation trail size (range 0 to 1)
  vim.g.neovide_cursor_trail_size = 0.8
  --
  -- Animate in Insert mode
  vim.g.neovide_cursor_animate_in_insert_mode = true
  --
  -- Animate switch to command line
  vim.g.neovide_cursor_animate_command_line = true
  --
  -- Particles?
  --
  -- a string
  -- vim.g.neovide_cursor_vfx_mode = "torpedo"
  -- or an array
  vim.g.neovide_cursor_vfx_mode = { "railgun", "ripple" }
  --
  -- Particle opacity
  vim.g.neovide_cursor_vfx_opacity = 150.0
  --
  -- Particle lifetime
  vim.g.neovide_cursor_vfx_particle_lifetime = 0.7
  vim.g.neovide_cursor_vfx_particle_highlight_lifetime = 0.4
  --
  -- Particle density
  vim.g.neovide_cursor_vfx_particle_density = 0.8
  --
  -- Particle speed (pixel/second)
  vim.g.neovide_cursor_vfx_particle_speed = 8.0
  --
  -- Particle phase
  vim.g.neovide_cursor_vfx_particle_phase = 3.0
  --
  -- Particle curl (railgun only)
  vim.g.neovide_cursor_vfx_particle_curl = 2.0
end
