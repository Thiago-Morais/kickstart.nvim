local is_linked_editing_range_enabled = true

-- Main LSP Configuration
vim.pack.add {
  'https://github.com/neovim/nvim-lspconfig',
  'https://github.com/mason-org/mason.nvim',
  'https://github.com/mason-org/mason-lspconfig.nvim',
  'https://github.com/WhoIsSethDaniel/mason-tool-installer.nvim',
  -- Useful status updates for LSP.
  'https://github.com/j-hui/fidget.nvim',
}

-- Automatically install LSPs and related tools to stdpath for Neovim.
-- Mason must be set up before its dependents (mason-lspconfig, mason-nvim-dap).
require('mason').setup {}

-- Translates between nvim-lspconfig server names and mason.nvim package names (e.g. lua_ls <-> lua-language-server).
-- `automatic_enable` also starts any server installed through :Mason that isn't listed below.
require('mason-lspconfig').setup {
  automatic_enable = true,
}

require('fidget').setup {}

do
  -- If you're wondering about lsp vs treesitter, you can check out the wonderfully
  -- and elegantly composed help section, `:help lsp-vs-treesitter`

  --  This function gets run when an LSP attaches to a particular buffer.
  --    That is to say, every time a new file is opened that is associated with
  --    an lsp (for example, opening `main.rs` is associated with `rust_analyzer`) this
  --    function will be executed to configure the current buffer
  vim.api.nvim_create_autocmd('LspAttach', {
    group = vim.api.nvim_create_augroup('kickstart-lsp-attach', { clear = true }),
    callback = function(event)
      -- NOTE: Remember that Lua is a real programming language, and as such it is possible
      -- to define small helper and utility functions so you don't have to repeat yourself.
      --
      -- In this case, we create a function that lets us more easily define mappings specific
      -- for LSP related items. It sets the mode, buffer and description for us each time.
      local map = function(keys, func, desc, mode)
        mode = mode or 'n'
        vim.keymap.set(mode, keys, func, { buffer = event.buf, desc = 'LSP: ' .. desc })
      end

      -- Rename the variable under your cursor.
      --  Most Language Servers support renaming across files, etc.
      map('grn', vim.lsp.buf.rename, '[R]e[n]ame')

      -- Execute a code action, usually your cursor needs to be on top of an error
      -- or a suggestion from your LSP for this to activate.
      map('gra', vim.lsp.buf.code_action, '[G]oto Code [A]ction', { 'n', 'x' })

      -- Find references for the word under your cursor.
      map('grr', require('telescope.builtin').lsp_references, '[G]oto [R]eferences')

      -- Jump to the implementation of the word under your cursor.
      --  Useful when your language has ways of declaring types without an actual implementation.
      map('gri', require('telescope.builtin').lsp_implementations, '[G]oto [I]mplementation')

      -- Jump to the definition of the word under your cursor.
      --  This is where a variable was first declared, or where a function is defined, etc.
      --  To jump back, press <C-t>.
      map('grd', require('telescope.builtin').lsp_definitions, '[G]oto [D]efinition')

      -- WARN: This is not Goto Definition, this is Goto Declaration.
      --  For example, in C this would take you to the header.
      map('grD', vim.lsp.buf.declaration, '[G]oto [D]eclaration')

      map('grc', vim.lsp.codelens.run, '[R]un [C]odeLens')

      -- Fuzzy find all the symbols in your current document.
      --  Symbols are things like variables, functions, types, etc.
      map('gO', function()
        require('telescope.builtin').lsp_document_symbols {
          default_text = '',
        }
      end, 'Open Document Symbols')

      -- Fuzzy find all the symbols in your current workspace.
      --  Similar to document symbols, except searches over your entire project.
      map('gW', require('telescope.builtin').lsp_dynamic_workspace_symbols, 'Open Workspace Symbols')

      -- Jump to the type of the word under your cursor.
      --  Useful when you're not sure what type a variable is and you want to see
      --  the definition of its *type*, not where it was *defined*.
      map('grt', require('telescope.builtin').lsp_type_definitions, '[G]oto [T]ype Definition')

      -- The following two autocommands are used to highlight references of the
      -- word under your cursor when your cursor rests there for a little while.
      --    See `:help CursorHold` for information about when this is executed
      --
      -- When you move your cursor, the highlights will be cleared (the second autocommand).
      local client = vim.lsp.get_client_by_id(event.data.client_id)
      if client and client:supports_method('textDocument/documentHighlight', event.buf) then
        local highlight_augroup = vim.api.nvim_create_augroup('kickstart-lsp-highlight', { clear = false })
        vim.api.nvim_create_autocmd({ 'CursorHold', 'CursorHoldI' }, {
          buffer = event.buf,
          group = highlight_augroup,
          callback = vim.lsp.buf.document_highlight,
        })

        vim.api.nvim_create_autocmd({ 'CursorMoved', 'CursorMovedI' }, {
          buffer = event.buf,
          group = highlight_augroup,
          callback = vim.lsp.buf.clear_references,
        })

        vim.api.nvim_create_autocmd('LspDetach', {
          group = vim.api.nvim_create_augroup('kickstart-lsp-detach', { clear = true }),
          callback = function(event2)
            vim.lsp.buf.clear_references()
            vim.api.nvim_clear_autocmds { group = 'kickstart-lsp-highlight', buffer = event2.buf }
          end,
        })
      end

      -- The following code creates a keymap to toggle inlay hints in your
      -- code, if the language server you are using supports them
      --
      -- This may be unwanted, since they displace some of your code
      if client then
        if client:supports_method('textDocument/inlayHint', event.buf) then
          local action = function()
            vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled { bufnr = event.buf })
          end
          map('<leader>th', action, '[T]oggle Inlay [H]ints')
        end

        if client:supports_method('textDocument/inlineCompletion', event.buf) then
          local action = function()
            vim.lsp.inline_completion.enable(not vim.lsp.inline_completion.is_enabled { bufnr = event.buf })
          end
          map('<leader>ti', action, '[T]oggle [I]nline Completion')
        end

        if client:supports_method('textDocument/linkedEditingRange', event.buf) then
          local action = function()
            is_linked_editing_range_enabled = not is_linked_editing_range_enabled
            vim.lsp.linked_editing_range.enable(is_linked_editing_range_enabled)
          end
          map('<leader>tr', action, '[T]oggle Linked Editing [R]ange')
        end

        if client:supports_method('textDocument/codeLens', event.buf) then
          local action = function()
            vim.lsp.codelens.enable(not vim.lsp.codelens.is_enabled { bufnr = event.buf })
          end
          map('<leader>te', action, '[T]oggle CodeL[E]ns')
        end
      end
    end,
  })

  -- vim.lsp.inlay_hint.enable(true)

  vim.lsp.codelens.enable(true)
  -- Auto refresh codelens
  vim.api.nvim_create_augroup('kickstart-codelens', { clear = true })
  vim.api.nvim_create_autocmd({ 'BufEnter', 'CursorHold', 'InsertLeave' }, {
    group = 'kickstart-codelens',
    callback = function(args)
      vim.lsp.codelens.enable(true, { bufnr = args.buf })
    end,
  })

  vim.lsp.inline_completion.enable(true)

  vim.lsp.linked_editing_range.enable(is_linked_editing_range_enabled)

  -- Diagnostic Config
  -- See :help vim.diagnostic.Opts
  vim.diagnostic.config {
    severity_sort = true,
    float = { border = 'rounded', source = 'if_many' },
    underline = { severity = { min = vim.diagnostic.severity.WARN } },
    signs = vim.g.have_nerd_font and {
      text = {
        [vim.diagnostic.severity.ERROR] = '󰅚 ',
        [vim.diagnostic.severity.WARN] = '󰀪 ',
        [vim.diagnostic.severity.INFO] = '󰋽 ',
        [vim.diagnostic.severity.HINT] = '󰌶 ',
      },
    } or {},
    -- Auto open the float, so you can easily read the errors when jumping with `[d` and `]d`
    jump = {
      on_jump = function(_, bufnr)
        vim.diagnostic.open_float {
          bufnr = bufnr,
          scope = 'cursor',
          focus = false,
        }
      end,
    },
    virtual_text = {
      source = true,
      spacing = 2,
      format = function(diagnostic)
        local diagnostic_message = {
          [vim.diagnostic.severity.ERROR] = diagnostic.message,
          [vim.diagnostic.severity.WARN] = diagnostic.message,
          [vim.diagnostic.severity.INFO] = diagnostic.message,
          [vim.diagnostic.severity.HINT] = diagnostic.message,
        }
        return diagnostic_message[diagnostic.severity]
      end,
    },
  }

  -- Enable the following language servers
  --  Feel free to add/remove any LSPs that you want here. They will automatically be installed.
  --
  --  Add any additional override configuration in the following tables. Available keys are:
  --  - cmd (table): Override the default command used to start the server
  --  - filetypes (table): Override the default list of associated filetypes for the server
  --  - capabilities (table): Override fields in capabilities. Can be used to disable certain LSP features.
  --  - settings (table): Override the default settings passed when initializing the server.
  --        For example, to see the options for `lua_ls`, you could go to: https://luals.github.io/wiki/settings/
  ---@type table<string, vim.lsp.Config>
  local servers = {
    -- clangd = {},
    -- gopls = {},
    -- pyright = {},
    -- rust_analyzer = {},
    -- ... etc. See `:help lspconfig-all` for a list of all the preconfigured LSPs
    --
    -- Some languages (like TypeScript) have entire language plugins that can be useful:
    --    https://github.com/pmizio/typescript-tools.nvim
    --
    -- But for many setups, the LSP (`ts_ls`) will work just fine
    -- ts_ls = {},
    --
    jsonls = {},
    -- harper_ls = {
    --   settings = {
    --     ['harper-ls'] = {
    --       linters = {
    --         SentenceCapitalization = false,
    --         SpellCheck = false,
    --         OrthographicConsistency = false,
    --         Dashes = false,
    --       },
    --     },
    --   },
    -- },

    lua_ls = {
      -- cmd = { ... },
      -- filetypes = { ... },
      -- capabilities = {},
      settings = {
        Lua = {
          completion = {
            callSnippet = 'Replace',
          },
          -- You can toggle below to ignore Lua_LS's noisy `missing-fields` warnings
          -- diagnostics = { disable = { 'missing-fields' } },
        },
      },
      handlers = {
        -- Hides lua_ls's error about refusing the home folder as a workspace (if home is a git repo, loose Lua files
        -- under it resolve there). The file still gets single-file features. Matches the FAQ link because the message
        -- text itself is translated to the system language.
        ['window/showMessage'] = function(err, result, context)
          local is_home_workspace_refusal = result.message:find('faq#why-is-the-server-scanning-the-wrong-folder', 1, true)
          if is_home_workspace_refusal then
            return
          end
          return vim.lsp.handlers['window/showMessage'](err, result, context)
        end,
      },
    },
    emmet_language_server = {
      init_options = {
        showSuggestionsAsSnippets = true,
      },
      filetypes = { 'css', 'html', 'javascript', 'less', 'sass', 'scss', 'blade' },
    },
    html = {
      filetypes = { 'html', 'blade' },
      settings = { css = { lint = { validProperties = {} } } },
    },
    cssls = {
      filetypes = { 'css', 'scss', 'less', 'html', 'blade' },
      settings = {
        css = { lint = { validProperties = {} } },
        scss = { lint = { validProperties = {} } },
        lcss = { lint = { validProperties = {} } },
      },
    },
    qmlls = {
      cmd = { 'qmlls6' },
      filetypes = { 'qml' },
    },
  }

  -- Ensure the servers and tools above are installed
  --
  -- To check the current status of installed tools and/or manually install
  -- other tools, you can run
  --    :Mason
  --
  -- You can press `g?` for help in this menu.
  --
  -- You can add other tools here that you want Mason to install
  -- for you, so that they are available from within Neovim.
  local ensure_installed = vim.tbl_keys(servers or {})
  vim.list_extend(ensure_installed, {
    'stylua', -- Used to format Lua code
    'html',
    'cssls',
    'tree-sitter-cli',
  })
  require('mason-tool-installer').setup { ensure_installed = ensure_installed }

  for server_name, server_config in pairs(servers) do
    vim.lsp.config(server_name, server_config)
    vim.lsp.enable(server_name)
  end
end
