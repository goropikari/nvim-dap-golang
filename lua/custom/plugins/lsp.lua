-- [[ Configure LSP ]]
--  This function gets run when an LSP connects to a particular buffer.
local on_attach = function(client, bufnr)
  -- NOTE: Remember that lua is a real programming language, and as such it is possible
  -- to define small helper and utility functions so you don't have to repeat yourself
  -- many times.
  --
  -- In this case, we create a function that lets us more easily define mappings specific
  -- for LSP related items. It sets the mode, buffer and description for us each time.
  local nmap = function(keys, func, desc)
    if desc then
      desc = 'LSP: ' .. desc
    end

    vim.keymap.set('n', keys, func, { buffer = bufnr, desc = desc })
  end

  -- nmap('<leader>rn', vim.lsp.buf.rename, 'Rename')
  nmap('<F2>', vim.lsp.buf.rename, 'Rename')
  -- nmap('<leader>ca', function()
  --   vim.lsp.buf.code_action { context = { only = { 'quickfix', 'refactor', 'source' } } }
  -- end, '[C]ode [A]ction')

  nmap('gd', require('telescope.builtin').lsp_definitions, 'Goto Definition') -- 戻るときは Ctrl-o
  nmap('gr', require('telescope.builtin').lsp_references, 'Goto References')
  nmap('gI', require('telescope.builtin').lsp_implementations, 'Goto Implementation')
  -- nmap('<leader>D', require('telescope.builtin').lsp_type_definitions, 'Type Definition')
  -- nmap('<leader>ds', require('telescope.builtin').lsp_document_symbols, 'Document Symbols')
  -- nmap('<leader>ws', require('telescope.builtin').lsp_dynamic_workspace_symbols, '[W]orkspace Symbols')

  -- See `:help K` for why this keymap
  -- nmap('K', vim.lsp.buf.hover, 'Hover Documentation')
  -- nmap('<C-k>', vim.lsp.buf.signature_help, 'Signature Documentation')

  -- Lesser used LSP functionality
  -- nmap('gD', vim.lsp.buf.declaration, 'Goto Declaration') -- prototype 宣言に飛ぶ
  -- nmap('<leader>wa', vim.lsp.buf.add_workspace_folder, '[W]orkspace [A]dd Folder')
  -- nmap('<leader>wr', vim.lsp.buf.remove_workspace_folder, '[W]orkspace Remove Folder')
  -- nmap('<leader>wl', function()
  --   print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
  -- end, 'Workspace List Folders')

  -- Create a command `:Format` local to the LSP buffer
  vim.api.nvim_buf_create_user_command(bufnr, 'Format', function(_)
    vim.lsp.buf.format()
  end, { desc = 'Format current buffer with LSP' })

  -- BufWritePre: 保存時に自動的に実行される処理
  if client.supports_method("textDocument/formatting") then
    local augroup = vim.api.nvim_create_augroup("LspFormatting", {})
    vim.api.nvim_clear_autocmds({ group = augroup, buffer = bufnr })
    vim.api.nvim_create_autocmd("BufWritePre", {
      group = augroup,
      buffer = bufnr,
      callback = function()
        vim.lsp.buf.format()
        vim.lsp.buf.code_action({
          context = {
            diagnostics = {},
            only = { "source.organizeImports" },
          }, -- 保存時に自動的に goimports するときに必要
          apply = true,
        })
      end,
    })
  end

  local wk = require('which-key')
  wk.add(
    {
      { "<leader>l",  group = "[L]SP" },
      { "<leader>l_", hidden = true },
      {
        "<leader>lK",
        vim.lsp.buf.hover,
        desc = "Hover Documentation",
      },
      { "<leader>lc", group = "[C]ode" },
      {
        "<leader>lca",
        function()
          vim.lsp.buf.code_action {
            context = {
              diagnostics = {},
              only = { 'quickfix', 'refactor', 'source' },
            },
            apply = true,
          }
        end,
        desc = "[C]ode [A]ction",
      },
      {
        "<leader>ldS",
        vim.lsp.buf.signature_help,
        desc = "Signature Documentation",
      },
      {
        "<leader>ldh",
        vim.lsp.buf.hover,
        desc = "Hover Documentation",
      },
      {
        "<leader>lds",
        require('telescope.builtin').lsp_document_symbols,
        desc = "Document Symbols",
      },
      {
        "<leader>lf",
        function(_) vim.lsp.buf.format() end,
        desc = "Format",
      },
      { "<leader>lg", group = "Goto" },
      {
        "<leader>lgD",
        vim.lsp.buf.declaration,
        desc = "Goto Declaration",
      },
      {
        "<leader>lgI",
        require('telescope.builtin').lsp_implementations,
        desc = "Goto Implementation",
      },
      {
        "<leader>lgd",
        require('telescope.builtin').lsp_definitions,
        desc = "Goto Definition",
      },
      {
        "<leader>lgr",
        require('telescope.builtin').lsp_references,
        desc = "Goto References",
      },
      {
        "<leader>lk",
        vim.lsp.buf.signature_help,
        desc = "Signature Documentation",
      },
      { "<leader>lr",  group = "Rename" },
      { "<leader>lr_", hidden = true },
      {
        "<leader>lrn",
        vim.lsp.buf.rename,
        desc = "Rename",
      },

    }
  )
end -- on_attach

-- mason-lspconfig requires that these setup functions are called in this order
-- before setting up the servers.
require('mason').setup()
require('mason-lspconfig').setup()

-- Enable the following language servers
--  Feel free to add/remove any LSPs that you want here. They will automatically be installed.
--
--  Add any additional override configuration in the following tables. They will be passed to
--  the `settings` field of the server config. You must look up that documentation yourself.
--
--  If you want to override the default filetypes that your language server will attach to you can
--  define the property 'filetypes' to the map in question.
local servers = {
  html = { filetypes = { 'html', 'twig', 'hbs' } },
  typos_lsp = {},
  lua_ls = {
    Lua = {
      workspace = { checkThirdParty = false },
      telemetry = { enable = false },
      -- NOTE: toggle below to ignore Lua_LS's noisy `missing-fields` warnings
      -- diagnostics = { disable = { 'missing-fields' } },
    },
  },
}

local lsp_langs = {
  -- executable = {lsp = config}
  go = {
    gopls = {
      -- keys = {
      --   -- Workaround for the lack of a DAP strategy in neotest-go: https://github.com/nvim-neotest/neotest-go/issues/12
      --   { "<leader>td", "<cmd>lua require('dap-go').debug_test()<CR>", desc = "Debug Nearest (Go)" },
      -- },
      settings = {
        gopls = {
          gofumpt = true,
          codelenses = {
            gc_details = false,
            generate = true,
            regenerate_cgo = true,
            run_govulncheck = true,
            test = true,
            tidy = true,
            upgrade_dependency = true,
            vendor = true,
          },
          hints = {
            assignVariableTypes = true,
            compositeLiteralFields = true,
            compositeLiteralTypes = true,
            constantValues = true,
            functionTypeParameters = true,
            parameterNames = true,
            rangeVariableTypes = true,
          },
          analyses = {
            fieldalignment = true,
            nilness = true,
            unusedparams = true,
            unusedwrite = true,
            useany = true,
          },
          usePlaceholders = true,
          completeUnimported = true,
          staticcheck = true,
          directoryFilters = { "-.git", "-.vscode", "-.idea", "-.vscode-test", "-node_modules" },
          semanticTokens = true,
        },
      },
    }
  },
  ruby = {
    ruby_lsp = {},
  },
  clangd = {
    clangd = {},
  }
}

for executable, config in pairs(lsp_langs) do
  if vim.fn.executable(executable) == 1 then
    for key, val in pairs(config) do
      servers[key] = val
    end
  end
end

-- Setup neovim lua configuration
require('neodev').setup()

-- nvim-cmp supports additional completion capabilities, so broadcast that to servers
local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities = require('cmp_nvim_lsp').default_capabilities(capabilities)

-- Ensure the servers above are installed
local mason_lspconfig = require 'mason-lspconfig'

mason_lspconfig.setup {
  ensure_installed = vim.tbl_keys(servers),
}

mason_lspconfig.setup_handlers {
  function(server_name)
    require('lspconfig')[server_name].setup {
      capabilities = capabilities,
      on_attach = on_attach,
      settings = servers[server_name],
      filetypes = (servers[server_name] or {}).filetypes,
    }
  end,
}
