-- 可选：cpp / cmake / yaml / json / rust / c# 等语言的 Tree-sitter 高亮与缩进
-- 说明：
--   Neovim 0.12 自带 c / lua / markdown / vim 等 parser，配置里已自动启用；
--   其它语言需要先安装 tree-sitter-cli（winget/scoop/choco 装一个），
--   再把下面的 enabled = false 改成 true，重新打开 nvim 即会自动安装 parser。
return {
  {
    "nvim-treesitter/nvim-treesitter",
    enabled = false,
    lazy = false,
    build = ":TSUpdate",
    config = function()
      require("nvim-treesitter").setup({})
      require("nvim-treesitter").install({
        "c", "cpp", "cmake", "lua", "vim", "vimdoc", "query",
        "markdown", "markdown_inline", "yaml", "json", "bash",
        "rust", "c_sharp",
      })
    end,
  },
}
