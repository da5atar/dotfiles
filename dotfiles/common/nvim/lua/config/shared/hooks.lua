-- Startup hook to clean old cache files
-- Reason: A similar issue to https://github.com/neovim/neovim/issues/31165 noticed on 2026-06-21
-- Root Cause: On RHEL, the AppImage mounts Neovim at a different temporary path each time it's invoked
-- (e.g., %2ftmp%2f.mount_nvim.a65Rja0%2f... vs %2ftmp%2f.mount_nvim.aNpxXgo%2f...).
-- Since cache filenames are based on the full file path, the same Lua files get cached with
-- different names on each launch, leading to thousands of duplicate cache files accumulating
-- in ~/.cache/nvim/luac/
local cache_dir = vim.fn.stdpath("cache") .. "/luac"
if vim.fn.isdirectory(cache_dir) == 1 then
  os.execute("find " .. cache_dir .. " -type f -mtime +1 -delete") -- Remove files older than 1 days
end
