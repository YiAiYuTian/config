-- 编辑增强（对应 electric-pair-mode / colorful-mode / move-text / multiple-cursors）
return {
  {
    "windwp/nvim-autopairs", -- electric-pair-mode：自动配对括号/引号
    event = "InsertEnter",
    config = function()
      require("nvim-autopairs").setup({})
    end,
  },
  {
    "NvChad/nvim-colorizer.lua", -- colorful-mode：高亮颜色代码 #fff、rgb() 等
    event = "BufReadPre",
    config = function()
      require("colorizer").setup({})
    end,
  },
  {
    "echasnovski/mini.move", -- move-text：Alt + h/j/k/l 移动行或选中块
    event = "BufReadPre",
    config = function()
      require("mini.move").setup()
    end,
  },
  {
    "brenton-leighton/multiple-cursors.nvim", -- multiple-cursors
    version = "*",
    opts = {
      pre_hook = function()
        vim.opt.cursorline = false
      end,
      post_hook = function()
        vim.opt.cursorline = true
      end,
    },
    keys = {
      { "<C-j>", "<Cmd>MultipleCursorsAddDown<CR>", mode = { "n", "x" }, desc = "添加光标并向下" },
      { "<C-k>", "<Cmd>MultipleCursorsAddUp<CR>", mode = { "n", "x" }, desc = "添加光标并向上" },
      { "<C-Up>", "<Cmd>MultipleCursorsAddUp<CR>", mode = { "n", "i", "x" }, desc = "添加上方光标" },
      { "<C-Down>", "<Cmd>MultipleCursorsAddDown<CR>", mode = { "n", "i", "x" }, desc = "添加下方光标" },
      { "<C-LeftMouse>", "<Cmd>MultipleCursorsMouseAddDelete<CR>", mode = { "n", "i" }, desc = "鼠标点击添加/删除光标" },
      { "<C-Return>", "<Cmd>MultipleCursorsAddDelete<CR>", mode = { "n" }, desc = "添加/删除锁定光标" },
      { "<Leader>m", "<Cmd>MultipleCursorsAddVisualArea<CR>", mode = { "x" }, desc = "视觉选区的每行加光标" },
      { "<Leader>a", "<Cmd>MultipleCursorsAddMatches<CR>", mode = { "n", "x" }, desc = "选中当前词的所有匹配" },
      { "<Leader>A", "<Cmd>MultipleCursorsAddMatchesV<CR>", mode = { "n", "x" }, desc = "上次选区内的所有匹配" },
      { "<Leader>d", "<Cmd>MultipleCursorsAddJumpNextMatch<CR>", mode = { "n", "x" }, desc = "添加光标并跳到下一个匹配" },
      { "<Leader>D", "<Cmd>MultipleCursorsJumpNextMatch<CR>", mode = { "n", "x" }, desc = "跳到下一个匹配" },
      { "<Leader>l", "<Cmd>MultipleCursorsLock<CR>", mode = { "n", "x" }, desc = "锁定虚拟光标" },
    },
  },
}
