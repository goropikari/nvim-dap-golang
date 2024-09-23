-- You can add your own plugins here or in other files in this directory!
--  I promise not to create any merge conflicts in this directory :)
--
-- See the kickstart.nvim README for more information
return {
  -- [[ Setting options ]]
  require 'custom.plugins.base',
  require 'custom.plugins.editor',

  -- [[ Basic Keymaps ]]
  require 'custom.plugins.keymaps',

  -- [[ Configure Telescope ]]
  require 'custom.plugins.telescope',

  -- [[ Configure Treesitter ]]
  -- See `:help nvim-treesitter`
  -- Defer Treesitter setup after first render to improve startup time of 'nvim {filename}'
  require 'custom.plugins.treesitter',

  -- [[ Configure LSP ]]
  require 'custom.plugins.lsp',

  -- [[ Configure autocmds ]]
  require 'custom.plugins.autocmds',
}
