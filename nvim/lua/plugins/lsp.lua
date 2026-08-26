-- LSP（对应 eglot + company-capf）：clangd 负责 C/C++
return {
  {
    "neovim/nvim-lspconfig",
    dependencies = {
      "williamboman/mason.nvim",
      "williamboman/mason-lspconfig.nvim",
    },
    config = function()
      -- Mason：一键安装/管理 LSP 服务器（clangd、cmake-language-server 等），
      -- 装好后在 nvim 里执行 :Mason 查看。
      -- 默认装到 C 盘 %LOCALAPPDATA%\nvim-data\mason；
      -- 这里改到 D 盘（目录不存在会自动创建）。想换路径改这一行即可。
      -- 注意：Mason 只往这个文件夹里放文件，不会修改 Windows 系统/用户环境变量，
      -- 不需要管理员权限，卸载就是删这个文件夹。
      require("mason").setup({
        install_root_dir = "D:/nvim-tools/mason",
      })
      require("mason-lspconfig").setup({
        ensure_installed = { "clangd", "cmake-language-server" },
      })

      local lspconfig = require("lspconfig")

      -- C/C++：clangd，和 Emacs 里一样禁用自动插入头文件
      lspconfig.clangd.setup({
        cmd = { "clangd", "--header-insertion=never" },
      })

      -- CMake：cmake-language-server
      lspconfig.cmake.setup({})
    end,
  },
}
