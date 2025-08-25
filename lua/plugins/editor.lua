return {
    {
        'folke/which-key.nvim',
        opts = {},
    },

    {
        'folke/todo-comments.nvim',
        event = 'VimEnter',
        dependencies = { 'nvim-lua/plenary.nvim' },
        opts = { signs = false }
    },

    {
        'windwp/nvim-autopairs',
        event = 'InsertEnter',
        opts = {},
    },

    {
        'lukas-reineke/indent-blankline.nvim',
        main = 'ibl',
        opts = {},
    },

    {
        'lewis6991/gitsigns.nvim',
        opts = {
            signs = {
                add = { text = '+' },
                change = { text = '~' },
                delete = { text = '_' },
                topdelete = { text = '‾' },
                changedelete = { text = '~' },
            }
        }
    },

    {
        'nvim-neo-tree/neo-tree.nvim',
        version = "*",
        dependencies = {
            'nvim-lua/plenary.nvim',
            'nvim-tree/nvim-web-devicons',
            'MunifTanjim/nui.nvim',
        },
        config = function()
            require('neo-tree').setup {
                filesystem = {
                    hijack_netrw_behavior = "open_current",
                    filtered_items = {
                        visible = true
                    }
                }
            }
        end,
    },

    {
        'nvim-telescope/telescope.nvim',
        branch = '0.1.x',
        config = function()
            require('telescope').setup {
                defaults = {
                    file_ignore_patterns = { "node_modules", ".git" },
                    mappings = {
                        i = {
                            ['<C-u>'] = false,
                            ['<C-d>'] = false,
                        }
                    }
                }
            }

            require('telescope').load_extension('fzf')

            vim.keymap.set('n', '<leader><space>', require('telescope.builtin').find_files, { desc = '[ ] Search files' })
            vim.keymap.set('n', '<leader>g', require('telescope.builtin').live_grep, { desc = '[G] Search by grep' })
            vim.keymap.set('n', '<leader>d', require('telescope.builtin').diagnostics,
                { desc = '[D] Search diagnostics' })
            vim.keymap.set('n', '<leader>b', require('telescope.builtin').buffers, { desc = '[B] Search buffers' })
        end,
        dependencies = {
            'nvim-lua/plenary.nvim',
            {
                'nvim-telescope/telescope-fzf-native.nvim',
                build = 'make'
            }
        }
    },

    {
        'stevearc/conform.nvim',
        event = { 'BufWritePre' },
        cmd = { 'ConformInfo' },
        keys = {
            {
                '<leader>f',
                function()
                    require('conform').format { async = true, lsp_format = 'fallback' }
                end,
                mode = '',
                desc = '[F]ormat buffer',
            },
        },
        opts = {
            notify_on_error = false,
            format_on_save = function(bufnr)
                local disable_filetypes = { c = true, cpp = true }

                if disable_filetypes[vim.bo[bufnr].filetype] then
                    return nil
                else
                    return {
                        timeout_ms = 500,
                        lsp_format = 'fallback',
                    }
                end
            end,
            formatters_by_ft = {
                lua = { 'stylua' },
            },
        },
    },

    {
        'saghen/blink.cmp',
        event = 'VimEnter',
        version = '1.*',
        dependencies = {
            'L3MON4D3/LuaSnip',
            version = "2.*",
            build = 'make install_jsregexp',
            dependencies = {
                {
                    'rafamadriz/friendly-snippets',
                    config = function()
                        require('luasnip.loaders.from_vscode').lazy_load()
                    end
                }
            }
        },
        opts = {
            keymap = {
                preset = 'enter',
            },
            appearance = {
                nerd_font_variant = 'mono',
            },
            completion = {
                documentation = { auto_show = true },
            },
            sources = {
                default = { 'lsp', 'path', 'snippets', 'lazydev' },
                providers = {
                    lazydev = { module = 'lazydev.integrations.blink', score_offset = 100 },
                    lsp = {
                        score_offset = 100,
                    }
                },
            },
            snippets = { preset = 'luasnip' },
            fuzzy = { implementation = 'lua' },
        },
    },
}
