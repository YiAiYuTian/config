-- 新增按键：只加“Neovim 没有默认键位、但功能需要入口”的键。
-- 其余全部保持 Neovim 默认键位，速查表见 README.md。

local map = vim.keymap.set

-- 文件管理器（dired -> netrw）：Space + e
map("n", "<leader>e", ":Explore<CR>", { desc = "打开文件管理器 (netrw)" })
