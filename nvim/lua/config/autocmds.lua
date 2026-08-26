-- 自动命令：对应 Emacs 里的各种 hook 与全局行为

local augroup = vim.api.nvim_create_augroup

-- LSP 附加时：
-- 1) 启用 Neovim 内置补全（对应 eglot + company-capf）
-- 2) 补一个默认键：gd 跳转定义（默认的 gd 只走 ctags，不走 clangd）
vim.api.nvim_create_autocmd("LspAttach", {
  group = augroup("lsp_setup", { clear = true }),
  callback = function(args)
    local client = vim.lsp.get_client_by_id(args.data.client_id)
    if client and client.server_capabilities.completionProvider then
      vim.lsp.completion.enable(true, client.id, args.buf, { autotrigger = true })
    end

    local opts = { buffer = args.buf }
    vim.keymap.set("n", "gd", vim.lsp.buf.definition, vim.tbl_extend("force", opts, { desc = "LSP: 跳转定义" }))
    vim.keymap.set("n", "gD", vim.lsp.buf.declaration, vim.tbl_extend("force", opts, { desc = "LSP: 跳转声明" }))
  end,
})

-- 保存后脉冲高亮当前行（对应 pulse-line-after-save）
local save_pulse_ns = vim.api.nvim_create_namespace("SavePulse")
vim.api.nvim_create_autocmd("BufWritePost", {
  group = augroup("save_pulse", { clear = true }),
  callback = function()
    local buf = vim.api.nvim_get_current_buf()
    local line = vim.fn.line(".")
    vim.api.nvim_buf_clear_namespace(buf, save_pulse_ns, 0, -1)
    vim.api.nvim_buf_add_highlight(buf, save_pulse_ns, "SavePulse", line - 1, 0, -1)
    vim.defer_fn(function()
      if vim.api.nvim_buf_is_valid(buf) then
        vim.api.nvim_buf_clear_namespace(buf, save_pulse_ns, 0, -1)
      end
    end, 150)
  end,
})

-- 非活动窗口变暗（对应 dimmer，只压暗背景，不动前景）
local function darken(hex, f)
  local r = math.floor(hex / 65536)
  local g = math.floor(hex / 256) % 256
  local b = hex % 256
  return string.format("#%02x%02x%02x", r * f, g * f, b * f)
end

vim.api.nvim_create_autocmd("ColorScheme", {
  group = augroup("custom_hl", { clear = true }),
  callback = function()
    -- 保存脉冲颜色（和 Emacs 里的 #4a4a40 一致）
    vim.api.nvim_set_hl(0, "SavePulse", { bg = "#4a4a40" })
    -- 变暗窗口：背景压暗约 8%
    local normal = vim.api.nvim_get_hl(0, { name = "Normal" })
    local bg = normal.bg or 0x101010
    vim.api.nvim_set_hl(0, "DimWindow", { fg = normal.fg, bg = darken(bg, 0.92) })
  end,
})

vim.api.nvim_create_autocmd("WinLeave", {
  group = augroup("dimmer", { clear = true }),
  callback = function()
    vim.wo.winhighlight = "Normal:DimWindow,SignColumn:DimWindow,EndOfBuffer:DimWindow"
  end,
})

vim.api.nvim_create_autocmd("WinEnter", {
  group = augroup("dimmer", { clear = true }),
  callback = function()
    vim.wo.winhighlight = ""
  end,
})

-- 文件被外部修改后自动重载（global-auto-revert-mode）
vim.api.nvim_create_autocmd({ "FocusGained", "CursorHold", "CursorHoldI" }, {
  group = augroup("autoread", { clear = true }),
  callback = function()
    vim.cmd("checktime")
  end,
})

-- markdown 软换行（对应 markdown-mode-hook 里的 visual-line-mode）
vim.api.nvim_create_autocmd("FileType", {
  group = augroup("markdown_wrap", { clear = true }),
  pattern = "markdown",
  callback = function()
    vim.opt_local.wrap = true
    vim.opt_local.linebreak = true
  end,
})

-- Neovim 0.12 自带 c/lua/markdown 等 parser：直接启用内置 Tree-sitter 高亮
-- （cpp/cmake 等其它语言见 lua/plugins/treesitter.lua 的可选配置）
vim.api.nvim_create_autocmd("FileType", {
  group = augroup("builtin_treesitter", { clear = true }),
  pattern = { "c", "lua", "markdown", "vim", "vimdoc", "query" },
  callback = function()
    pcall(vim.treesitter.start, 0)
  end,
})
