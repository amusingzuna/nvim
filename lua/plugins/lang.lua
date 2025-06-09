return {
    {
        'nvim-treesitter/nvim-treesitter',
        dependencies = {
            'nvim-treesitter/nvim-treesitter-textobjects',
        },
        build = ':TSUpdate',
        config = function()
            require('nvim-treesitter.configs').setup {
                ensure_installed = {},
                modules = {},
                ignore_install = {},
                sync_install = false,
                auto_install = true,

                highlight = { enable = true },
                indent = { enable = true },

                incremental_selection = {
                    enable = true,
                    keymaps = {
                        init_selection = '<c-space>',
                        node_incremental = '<c-space>',
                        scope_incremental = '<c-s>',
                        node_decremental = '<M-space>'
                    }
                },

                textobjects = {
                    select = {
                        enable = true,
                        lookahead = true,
                        keymaps = {
                            ['aa'] = '@parameter.outer',
                            ['ia'] = '@parameter.inner',
                            ['af'] = '@function.outer',
                            ['if'] = '@function.inner',
                            ['ac'] = '@class.outer',
                            ['ic'] = '@class.inner',
                        }
                    }
                },
            }
        end
    },

    {
        'mason-org/mason-lspconfig.nvim',
        opts = {},
        dependencies = {
            {
                'mason-org/mason.nvim',
                dependencies = {
                    {
                        'folke/lazydev.nvim',
                        ft = "lua",
                        opts = {
                            enabled = true
                        }
                    }
                },
                config = function()
                    require('mason').setup()
                    local lspconfig = require('mason-lspconfig')

                    local servers = {}

                    lspconfig.setup {
                        ensure_installed = {},
                        automatic_enable = true,
                        handlers = {
                            function(server_name)
                                local server = servers[server_name] or {}
                                server.capabilities = require('blink.cmp').get_lsp_capabilities(server.capabilities)
                                require('lspconfig')[server_name].setup(server)
                            end
                        }
                    }
                end,
            },
            {
                'neovim/nvim-lspconfig',
                dependencies = {
                    { 'j-hui/fidget.nvim', opts = {} }
                },
                config = function()
                    vim.api.nvim_create_autocmd('LspAttach', {
                        group = vim.api.nvim_create_augroup('lsp-attach', { clear = true }),
                        callback = function(event)
                            local function map(keys, func, desc, mode)
                                mode = mode or 'n'
                                vim.keymap.set(mode, keys, func, { buffer = event.buf, desc = 'LSP: ' .. desc })
                            end

                            map('grn', vim.lsp.buf.rename, '[R]e[n]ame')
                            map('gra', vim.lsp.buf.code_action, '[G]oto Code [A]ction')

                            map('gd', require('telescope.builtin').lsp_definitions, '[G]oto [D]efinition')
                            map('gD', vim.lsp.buf.declaration, '[G]oto [D]eclaration')

                            map('gr', require('telescope.builtin').lsp_references, '[G]oto [R]eferences')
                            map('gI', require('telescope.builtin').lsp_implementations, '[G]oto [I]mplementations')

                            map('gs', require('telescope.builtin').lsp_document_symbols, '[S] Search symbols')

                            map('K', vim.lsp.buf.hover, 'Hover Documentation')
                            map('J', vim.diagnostic.open_float, 'Hover Diagnostic')

                            local client = vim.lsp.get_client_by_id(event.data.client_id)
                            if client and client:supports_method(vim.lsp.protocol.Methods.textDocument_inlayHint, event.buf) then
                                map('<leader>th', function()
                                    vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled { bufnr = event.buf })
                                end, '[T]oggle Inlay [H]ints')
                            end
                        end
                    })
                end,
            },
        }
    },
}
