-- [[ Setting options ]]
-- See `:help vim.o`
-- NOTE: You can change these options as you wish!

-- Set highlight on search
vim.o.hlsearch = true

-- Make line numbers default
vim.wo.number = true

-- Enable mouse mode
vim.o.mouse = 'a'

-- Sync clipboard between OS and Neovim.
--  Remove this option if you want your OS clipboard to remain independent.
--  See `:help 'clipboard'`
vim.o.clipboard = 'unnamedplus'

-- Enable break indent
-- 折り返された行もインデントが適用して表示される
vim.o.breakindent = true

-- Save undo history
-- vim.o.undofile = true

-- Case-insensitive searching UNLESS \C or capital in search
-- 検索時に大文字小文字を区別しない。ただし \C を付けて検索すると区別する
vim.o.ignorecase = true
vim.o.smartcase = true

-- Keep signcolumn on by default
-- git の差分がある行や breakpoint の位置などを表示する列を常に表示する
vim.wo.signcolumn = 'yes'

-- Decrease update time
-- vim.o.updatetime = 250
-- vim.o.timeoutlen = 300

-- Set completeopt to have a better completion experience
vim.o.completeopt = 'menuone,noselect'

-- NOTE: You should make sure your terminal supports this
vim.o.termguicolors = true

-- 折りたたみの基準
vim.o.foldmethod = 'indent'
vim.o.foldlevel = 99 -- 起動時にコードの折りたたみを無効にした状態で開く
-- vim.api.nvim_command('set nofoldenable') -- 起動時にコードの折りたたみを無効にした状態で開く
