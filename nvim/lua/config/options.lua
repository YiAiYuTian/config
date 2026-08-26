-- 基础选项：对应 Emacs 的 core.el / custom.el（主题暂未配置，按你的要求跳过）

local opt = vim.opt

-- 行号：相对行号 + 当前行显示绝对行号（display-line-numbers relative）
opt.number = true
opt.relativenumber = true
opt.numberwidth = 4

-- 光标所在行高亮（hl-line-mode）
opt.cursorline = true

-- 滚动：光标上下各留 3 行（scroll-margin 3）
opt.scrolloff = 3

-- 鼠标：滚轮普通滚动 1 行，按住 Shift 滚动 5 行（mouse-wheel-scroll-amount）
opt.mouse = "a"
opt.mousescroll = "ver:1,hor:5"

-- 不显示启动画面（inhibit-startup-screen）
opt.shortmess:append("I")

-- 系统剪贴板：y/p 直接与 Windows 剪贴板互通
opt.clipboard = "unnamedplus"

-- 搜索忽略大小写（case-fold-search t）；输入大写时自动区分大小写
opt.ignorecase = true
opt.smartcase = true

-- 命令行模糊补全（对应 ido / smex 的感觉），":" 就是 M-x
opt.wildmenu = true
opt.wildmode = "longest:full,full"
opt.wildoptions = "fuzzy,pum"
opt.path:append("**") -- 让 :find 能递归搜索子目录

-- 代码格式：4 空格缩进，不用 Tab（indent-tabs-mode nil / tab-width 4 / c-basic-offset 4）
opt.expandtab = true
opt.tabstop = 4
opt.shiftwidth = 4
opt.softtabstop = 4
opt.autoindent = true

-- 文件
opt.encoding = "utf-8"
opt.fileencoding = "utf-8"
opt.swapfile = false -- 不生成 #xxx#（create-lockfiles nil）
opt.backup = false -- 不生成 xxx~（make-backup-files nil）
opt.undofile = true -- 撤销历史持久化，重启后仍可 u
opt.autoread = true -- 文件被外部改动自动重载（global-auto-revert-mode）
opt.confirm = true -- 需要确认时用 y/n（use-short-answers）

-- 编译命令（compile-command "make -j8"）
-- 这台机器上 make 不在 PATH，用 Qt 自带的 mingw32-make；
-- 如果你环境里能直接敲 make，改成 opt.makeprg = "make -j8" 即可。
opt.makeprg = "mingw32-make -j8"
-- 其他常见选择：
-- opt.makeprg = "cmake --build build -j8"
-- opt.makeprg = "ninja -C build -j8"

-- 补全菜单（内置 LSP 补全，见 lua/plugins/lsp.lua）
opt.completeopt = "menu,menuone,noselect"
opt.pumheight = 12

-- 括号配对高亮（show-paren-mode）
opt.showmatch = true
opt.matchtime = 3

-- 固定符号列，gitsigns 的 +/- 标记显示稳定
opt.signcolumn = "yes"

-- 外观 / 字体
opt.termguicolors = true
opt.guifont = "Consolas:h11" -- 仅 GUI（如 nvim-qt）生效；终端里由终端字体决定
