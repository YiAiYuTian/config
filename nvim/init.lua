-- =============================================================================
-- Neovim 配置入口
-- 由 Emacs 配置翻译而来：保持 Neovim 默认键位，只补少量必须的新键。
-- 安装：把整个 nvim 文件夹复制到 %LOCALAPPDATA%\nvim，然后启动 nvim。
-- =============================================================================

vim.g.mapleader = " "
vim.g.maplocalleader = " "

require("config.options")
require("config.keymaps")
require("config.autocmds")

-- lazy.nvim 插件管理器（首次启动自动克隆）
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.uv.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable",
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

require("lazy").setup({
  -- 插件安装目录。默认在 C 盘 %LOCALAPPDATA%\nvim-data\lazy，
  -- 这里改到 D 盘（目录不存在会自动创建）。想换路径改这一行即可。
  root = "D:/nvim-tools/plugins",
  spec = {
    { import = "plugins" },
  },
  checker = { enabled = false },
  change_detection = { notify = false },
})
