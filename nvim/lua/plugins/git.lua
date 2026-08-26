-- git 集成（对应 magit + git-gutter）
return {
  {
    "lewis6991/gitsigns.nvim", -- git-gutter：行号旁的 +/- 改动标记
    event = { "BufReadPre", "BufNewFile" },
    opts = {
      on_attach = function(bufnr)
        local gs = require("gitsigns")
        local opts = { buffer = bufnr }
        vim.keymap.set("n", "]c", function() gs.next_hunk() end,
          vim.tbl_extend("force", opts, { desc = "下一个 git 改动块" }))
        vim.keymap.set("n", "[c", function() gs.prev_hunk() end,
          vim.tbl_extend("force", opts, { desc = "上一个 git 改动块" }))
        vim.keymap.set("n", "<leader>hs", gs.stage_hunk,
          vim.tbl_extend("force", opts, { desc = "暂存当前改动块" }))
        vim.keymap.set("n", "<leader>hr", gs.reset_hunk,
          vim.tbl_extend("force", opts, { desc = "撤销当前改动块" }))
        vim.keymap.set("n", "<leader>hp", gs.preview_hunk,
          vim.tbl_extend("force", opts, { desc = "预览当前改动块" }))
        vim.keymap.set("n", "<leader>hb", function() gs.blame_line() end,
          vim.tbl_extend("force", opts, { desc = "当前行 blame" }))
        vim.keymap.set("n", "<leader>hd", gs.diffthis,
          vim.tbl_extend("force", opts, { desc = "查看当前文件 diff" }))
      end,
    },
  },
  {
    "NeogitOrg/neogit", -- magit：提交 / 分支 / 日志图形界面
    dependencies = { "nvim-lua/plenary.nvim" },
    keys = {
      { "<leader>gg", "<cmd>Neogit<CR>", desc = "打开 git 图形界面" },
    },
    config = function()
      require("neogit").setup({})
    end,
  },
}
