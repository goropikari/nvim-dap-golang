-- https://github.com/LazyVim/LazyVim/blob/v12.38.2/lua/lazyvim/config/autocmds.lua

local function augroup(name)
  return vim.api.nvim_create_augroup(name, { clear = true })
end

-- Check if we need to reload the file when it changed
vim.api.nvim_create_autocmd({ 'FocusGained', 'TermClose', 'TermLeave' }, {
  group = augroup 'checktime',
  callback = function()
    if vim.o.buftype ~= 'nofile' then
      vim.cmd 'checktime'
    end
  end,
})

-- resize splits if window got resized
vim.api.nvim_create_autocmd({ 'VimResized' }, {
  group = augroup 'resize_splits',
  callback = function()
    local current_tab = vim.fn.tabpagenr()
    vim.cmd 'tabdo wincmd ='
    vim.cmd('tabnext ' .. current_tab)
  end,
})

-- Auto create dir when saving a file, in case some intermediate directory does not exist
vim.api.nvim_create_autocmd({ 'BufWritePre' }, {
  group = augroup 'auto_create_dir',
  callback = function(event)
    if event.match:match '^%w%w+:[\\/][\\/]' then
      return
    end
    local file = vim.uv.fs_realpath(event.match) or event.match
    vim.fn.mkdir(vim.fn.fnamemodify(file, ':p:h'), 'p')
  end,
})

-- -- https://github.com/golang/tools/blob/master/gopls/doc/vim.md#neovim-imports
-- local gopls_format = function()
--   local params = vim.lsp.util.make_range_params()
--   params.context = { only = { "source.organizeImports" } }
--   -- buf_request_sync defaults to a 1000ms timeout. Depending on your
--   -- machine and codebase, you may want longer. Add an additional
--   -- argument after params if you find that you have to write the file
--   -- twice for changes to be saved.
--   -- E.g., vim.lsp.buf_request_sync(0, "textDocument/codeAction", params, 3000)
--   local result = vim.lsp.buf_request_sync(0, "textDocument/codeAction", params)
--   for cid, res in pairs(result or {}) do
--     for _, r in pairs(res.result or {}) do
--       if r.edit then
--         local enc = (vim.lsp.get_client_by_id(cid) or {}).offset_encoding or "utf-16"
--         vim.lsp.util.apply_workspace_edit(r.edit, enc)
--       end
--     end
--   end
--   vim.lsp.buf.format({ async = false })
-- end
--
-- vim.api.nvim_create_autocmd({"BufWritePre"}, {
--   group = augroup("lsp_formatting"),
--   callback = function()
--     if vim.bo.filetype == "go" then
--       gopls_format()
--     else
--       vim.lsp.buf.format({ async = false })
--     end
--   end
-- })
