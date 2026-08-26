# Neovim 配置说明（由 Emacs 配置翻译而来）

目标：把你 Emacs 里用到的功能搬到 Neovim，**不改 Neovim 默认键位**，只补少量必要的新键。
主题（gruber-darker）按你的要求暂未配置。

## 一、安装

1. 把 `nvim` 文件夹整个复制到 `%LOCALAPPDATA%\nvim`（即 `C:\Users\20389\AppData\Local\nvim`）。
2. 打开终端，执行 `nvim`。首次启动会自动克隆 lazy.nvim 并安装插件（需要联网）。
3. 插件装完后，Mason 会自动安装 clangd 和 cmake-language-server（在 nvim 里可用 `:Mason` 查看/重装）。
4. C/C++ 项目建议生成 `compile_commands.json` 给 clangd 用（见文末）。

目录结构：

```
nvim/
  init.lua                       入口
  lua/config/options.lua         基础设置（行号/缩进/搜索/剪贴板…）
  lua/config/keymaps.lua         新增按键（只有 Space+e）
  lua/config/autocmds.lua        自动命令（保存脉冲/窗口变暗/自动重载/LSP 补全…）
  lua/plugins/lsp.lua            clangd + cmake-language-server（Mason 管理）
  lua/plugins/telescope.lua      模糊查找/搜索
  lua/plugins/git.lua            gitsigns（改动标记）+ neogit（git 界面）
  lua/plugins/editor.lua         自动配对/颜色高亮/移动行/多光标
  lua/plugins/treesitter.lua     可选：cpp/cmake 等 Tree-sitter 高亮（默认关闭）
```

## 二、Emacs 功能 → Neovim 对照

| Emacs 功能 | Neovim 对应 |
| --- | --- |
| eglot（clangd）+ company 补全 | LSP + 内置补全，clangd 自动补全 |
| magit（C-x g） | `<leader>gg` 打开 neogit |
| git-gutter 行内改动标记 | gitsigns（行号旁 +/- 标记） |
| ido / smex 模糊查找、M-x | `:` 命令带模糊补全；`<leader>ff/fg/fb` 模糊查找 |
| dired 文件管理 | netrw（`<leader>e` 或 `:Explore`） |
| multiple-cursors | 多光标插件（键位见下） |
| move-text（M-p / M-n 移动行） | `<A-j>` / `<A-k>`（以及 `<A-h>`/`<A-l>` 左右移） |
| electric-pair-mode 自动配对 | nvim-autopairs |
| colorful-mode 颜色高亮 | nvim-colorizer |
| pulse-line-after-save 保存脉冲 | 保存后当前行闪一下 |
| dimmer 窗口变暗 | 非活动窗口背景自动压暗 |
| comment-dwim（M-;） | `gc` / `gcc` / `gbc`（Neovim 自带） |
| duplicate-line（C-.） | `yyp`（复制本行到下方）/ `yyP`（到上方） |
| mark-whole-line（C-S-z） | `V` |
| 整块缩进 ±4（C-tab） | `>>` / `<<`（配合 shiftwidth=4） |
| kill-whole-line（C-c d） | `dd` |
| goto-line（C-c g） | `:行号` 回车，或 `行号G` |
| 矩形选区（C-M-z） | `<C-v>` |
| windmove（C-S-方向键） | `<C-w>` + h/j/k/l 或方向键 |
| compile（F5）+ 错误跳转 | `:make` + `]q` / `[q` |
| auto-revert 自动重载 | 已开启，切回窗口或停顿时自动 checktime |
| 相对行号 + 高亮当前行 | 已开启 |
| Consolas + 中文回退字体 | `guifont` 已设置；终端里由终端字体决定 |

## 三、快捷键速查

> `<leader>` 是空格键。下面**带 ★ 的是插件新增键**，其余都是 Neovim 默认键位。

### 1. 文件 / 缓冲区

| 按键 | 作用 |
| --- | --- |
| ★ `<leader>ff` | 模糊查找文件 |
| ★ `<leader>fg` | 全文搜索（需要 ripgrep） |
| ★ `<leader>fb` | 切换已打开的缓冲区 |
| ★ `<leader>fh` | 查找帮助文档 |
| `[b` / `]b` | 上一个 / 下一个缓冲区 |
| `<C-^>` | 在最近两个缓冲区间切换 |
| `:e 文件` / `:find 文件` | 打开文件（`:find` 支持模糊补全） |
| ★ `<leader>e` | 打开文件管理器 netrw |
| `:w` / `:q` / `:wq` | 保存 / 退出 / 保存并退出 |

### 2. C/C++ 核心：LSP（clangd）

| 按键 | 作用 |
| --- | --- |
| ★ `gd` | 跳转到定义 |
| ★ `gD` | 跳转到声明 |
| `K` | 悬停查看文档/类型 |
| `grn` | 重命名符号（项目内全部改名） |
| `grr` | 查看所有引用 |
| `gri` | 跳转到实现 |
| `grt` | 跳转到类型定义 |
| `gra` | 代码操作（自动修复、生成函数等） |
| `gO` | 列出当前文件的符号大纲 |
| `]d` / `[d` | 下一个 / 上一个诊断（报错、警告） |
| `]D` / `[D` | 当前文件第一个 / 最后一个诊断 |
| `<C-s>`（插入模式） | 参数提示（函数签名） |

### 3. 补全

| 按键 | 作用 |
| --- | --- |
| `<C-n>` / `<C-p>` | 下一个 / 上一个补全项（自动弹出） |
| `<C-y>` | 确认选中的补全 |
| `<C-e>` | 关闭补全菜单 |
| `<C-x><C-o>` | 手动触发 LSP 补全 |
| `<C-x><C-f>` | 文件路径补全（对应 company-files） |
| `<C-x><C-l>` | 整行补全（对应 company-dabbrev-code） |

### 4. 编辑

| 按键 | 作用 |
| --- | --- |
| `yy` + `p` | 复制当前行并粘贴到下方（重复行） |
| `dd` | 删除整行 |
| `D` | 删除光标到行尾 |
| `v` / `V` / `<C-v>` | 字符选区 / 整行选区 / 块选区 |
| `x` / `c` / `r` | 删除字符 / 修改 / 替换字符 |
| `u` / `<C-r>` | 撤销 / 重做 |
| `.` | 重复上一次修改 |
| `>>` / `<<` | 当前行缩进 / 反缩进（选区用 `>` / `<`） |
| `gc` / `gcc` / `gbc` | 注释/取消注释（行/整行/块） |
| ★ `<A-j>` / `<A-k>` | 当前行向下 / 向上移动 |
| ★ `<A-J>` / `<A-K>` | 向下 / 向上复制一行（mini.move） |
| `J` | 合并下一行 |
| `~` | 大小写切换 |
| `gi` | 回到上次编辑位置进入插入 |

### 5. 多光标（★ 插件新增）

| 按键 | 作用 |
| --- | --- |
| `<C-j>` / `<C-k>` | 在下方 / 上方添加一个光标 |
| `<C-Up>` / `<C-Down>` | 在上方 / 下方添加光标（插入模式也可用） |
| `<C-LeftMouse>` | 鼠标点击添加 / 删除光标 |
| `<C-Return>` | 添加 / 删除锁定光标 |
| `<leader>m` | 视觉选区的每一行都加光标 |
| `<leader>a` | 选中当前词的所有匹配（对应 mc/mark-all-like-this） |
| `<leader>A` | 上次选区内的所有匹配 |
| `<leader>d` / `<leader>D` | 添加光标并跳下一个匹配 / 只跳下一个匹配 |
| `<leader>l` | 锁定虚拟光标 |

多个光标出现后正常编辑（方向键、`x`、`c`、`I`、`A`、`p` 等）即可，`<Esc>` 退出。

### 6. 搜索

| 按键 | 作用 |
| --- | --- |
| `/ 内容` | 向下搜索（回车后 `n` / `N` 下一个/上一个） |
| `? 内容` | 向上搜索 |
| `*` / `#` | 搜索光标下的词，向下 / 向上 |
| `:%s/旧/新/gc` | 全局替换（c 逐个确认） |

### 7. 窗口 / 分屏

| 按键 | 作用 |
| --- | --- |
| `<C-w>s` / `<C-w>v` | 上下 / 左右分屏 |
| `<C-w>h/j/k/l` 或方向键 | 在窗口间移动 |
| `<C-w>q` / `<C-w>o` | 关闭窗口 / 只留当前窗口 |
| `<C-w>=` | 窗口等宽 |
| `<C-w>_` / `<C-w>|` | 窗口最大化（高 / 宽） |

### 8. 编译与错误（quickfix）

| 按键 | 作用 |
| --- | --- |
| `:make` | 编译（makeprg 已是 `mingw32-make -j8`） |
| `:copen` | 打开错误列表 |
| `]q` / `[q` | 下一个 / 上一个错误 |
| `]Q` / `[Q` | 最后一个 / 第一个错误 |
| `:cn` / `:cp` | 同 `]q` / `[q` |
| `:ccl` | 关闭错误列表 |

### 9. Git

| 按键 | 作用 |
| --- | --- |
| ★ `<leader>gg` | 打开 git 图形界面（提交/分支/日志，类似 magit） |
| `]c` / `[c` | 下一个 / 上一个改动块 |
| ★ `<leader>hs` | 暂存当前改动块 |
| ★ `<leader>hr` | 撤销当前改动块 |
| ★ `<leader>hp` | 预览当前改动块 |
| ★ `<leader>hb` | 当前行 blame |
| ★ `<leader>hd` | 查看当前文件 diff |

### 10. 文件管理器 netrw（★ `<leader>e` 打开）

| 按键 | 作用 |
| --- | --- |
| `%` | 新建文件 |
| `d` | 新建目录 |
| `D` | 删除 |
| `R` | 重命名 |
| `x` / 回车 | 打开文件 |
| `-` | 返回上级目录 |
| `gh` | 显示 / 隐藏隐藏文件（默认隐藏，对应 dired-omit） |
| `i` | 切换列表样式（详细/简略/树形） |
| `I` | 显示 / 隐藏顶部横幅 |

## 四、C/C++ 注意事项

1. **compile_commands.json**：clangd 需要它才能正确解析 include 路径和宏。
   在 CMake 项目里执行：
   `cmake -B build -DCMAKE_EXPORT_COMPILE_COMMANDS=ON`
   然后把 `build/compile_commands.json` 复制到项目根目录（clangd 会自动找到）。
2. **编译命令**：默认 `mingw32-make -j8`（你机器上 make 不在 PATH）。
   用 CMake/Ninja 的话，把 options.lua 里的 `makeprg` 改成
   `cmake --build build -j8` 或 `ninja -C build -j8`。
3. **ripgrep**：`<leader>fg` 全文搜索建议装一下：
   `winget install BurntSushi.ripgrep.MSVC`（没有也能用 `:vimgrep`）。
4. **Tree-sitter**：Neovim 0.12 自带 C 的 parser，开箱即有高亮；
   想要 cpp/cmake 等语言的高亮，先安装 tree-sitter-cli，再把
   `lua/plugins/treesitter.lua` 里的 `enabled = false` 改成 `true`。
5. **剪贴板**：`y`/`p` 直接使用系统剪贴板；若失效，安装 win32yank 即可。
6. **主题**：按你的要求暂未配置。之后想加 gruber-darker 时告诉我，我会补上。
