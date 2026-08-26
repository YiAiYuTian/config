-- 模糊查找 / 搜索（对应 ido、ido-ubiquitous、smex）
return {
  {
    "nvim-telescope/telescope.nvim",
    dependencies = { "nvim-lua/plenary.nvim" },
    keys = {
      { "<leader>ff", "<cmd>Telescope find_files<CR>", desc = "查找文件" },
      { "<leader>fg", "<cmd>Telescope live_grep<CR>", desc = "全文搜索" },
      { "<leader>fb", "<cmd>Telescope buffers<CR>", desc = "切换缓冲区" },
      { "<leader>fh", "<cmd>Telescope help_tags<CR>", desc = "查找帮助文档" },
    },
  },
}
