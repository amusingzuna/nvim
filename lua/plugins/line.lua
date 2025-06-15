---@diagnostic disable: missing-fields

return {
    {
        'rebelot/heirline.nvim',
        config = function()
            local conditions = require('heirline.conditions')
            local theme_colors = require('kanagawa.colors').setup({ theme = 'dragon' })

            local colors = {
                bg = theme_colors.theme.ui.bg_gutter,
                bg_secondary = theme_colors.palette.dragonBlack1,
                fg = theme_colors.palette.oldWhite,
                git_add = theme_colors.theme.vcs.added,
                git_change = theme_colors.theme.vcs.changed,
                git_remove = theme_colors.theme.vcs.removed,
                diag_err = theme_colors.theme.diag.error,
                diag_warn = theme_colors.theme.diag.warning,
                diag_hint = theme_colors.theme.diag.hint,
                diag_info = theme_colors.theme.diag.info,
                normal = theme_colors.palette.springViolet2,
                -- normal = theme_colors.palette.crystalBlue,
                visual = theme_colors.palette.oniViolet,
                -- visual = theme_colors.palette.sakuraPink,
                insert = theme_colors.palette.autumnGreen,
                -- insert = theme_colors.palette.springGreen,
                replace = theme_colors.palette.waveRed,
                -- replace = theme_colors.palette.autumnRed,
                command = theme_colors.palette.boatYellow2,
                -- command = theme_colors.palette.autumnYellow,
            }

            local mode_map = {
                ['n']     = 'NORMAL',
                ['no']    = 'O-PENDING',
                ['nov']   = 'O-PENDING',
                ['noV']   = 'O-PENDING',
                ['no\22'] = 'O-PENDING',
                ['niI']   = 'NORMAL',
                ['niR']   = 'NORMAL',
                ['niV']   = 'NORMAL',
                ['nt']    = 'NORMAL',
                ['ntT']   = 'NORMAL',
                ['v']     = 'VISUAL',
                ['vs']    = 'VISUAL',
                ['V']     = 'V-LINE',
                ['Vs']    = 'V-LINE',
                ['\22']   = 'V-BLOCK',
                ['\22s']  = 'V-BLOCK',
                ['s']     = 'SELECT',
                ['S']     = 'S-LINE',
                ['\19']   = 'S-BLOCK',
                ['i']     = 'INSERT',
                ['ic']    = 'INSERT',
                ['ix']    = 'INSERT',
                ['R']     = 'REPLACE',
                ['Rc']    = 'REPLACE',
                ['Rx']    = 'REPLACE',
                ['Rv']    = 'V-REPLACE',
                ['Rvc']   = 'V-REPLACE',
                ['Rvx']   = 'V-REPLACE',
                ['c']     = 'COMMAND',
                ['cv']    = 'EX',
                ['ce']    = 'EX',
                ['r']     = 'REPLACE',
                ['rm']    = 'MORE',
                ['r?']    = 'CONFIRM',
                ['!']     = 'SHELL',
                ['t']     = 'TERMINAL',
            }

            local mode_color_map = {
                ['n']     = colors.normal,
                ['no']    = colors.normal,
                ['nov']   = colors.normal,
                ['noV']   = colors.normal,
                ['no\22'] = colors.normal,
                ['niI']   = colors.normal,
                ['niR']   = colors.normal,
                ['niV']   = colors.normal,
                ['nt']    = colors.normal,
                ['ntT']   = colors.normal,
                ['v']     = colors.visual,
                ['vs']    = colors.visual,
                ['V']     = colors.visual,
                ['Vs']    = colors.visual,
                ['\22']   = colors.visual,
                ['\22s']  = colors.visual,
                ['s']     = colors.visual,
                ['S']     = colors.visual,
                ['\19']   = colors.visual,
                ['i']     = colors.insert,
                ['ic']    = colors.insert,
                ['ix']    = colors.insert,
                ['R']     = colors.replace,
                ['Rc']    = colors.replace,
                ['Rx']    = colors.replace,
                ['Rv']    = colors.replace,
                ['Rvc']   = colors.replace,
                ['Rvx']   = colors.replace,
                ['r']     = colors.replace,
                ['rm']    = colors.replace,
                ['r?']    = colors.replace,
                ['c']     = colors.command,
                ['cv']    = colors.command,
                ['ce']    = colors.command,
                ['!']     = colors.command,
                ['t']     = colors.command,
            }

            local space = { provider = " " }

            local mode = {
                provider = function()
                    return " " .. mode_map[vim.fn.mode()] .. " "
                end,
                update = {
                    "ModeChanged",
                    pattern = "*:*",
                    callback = vim.schedule_wrap(function()
                        vim.cmd.redrawstatus()
                    end)
                }
            }

            local git = {
                condition = conditions.is_git_repo,
                init = function(self)
                    self.status_dict = vim.b.gitsigns_status_dict

                    self.has_changes = (self.status_dict.added or 0) ~= 0 or (self.status_dict.removed or 0) ~= 0 or
                        (self.status_dict.changed or 0) ~= 0
                end,
                {
                    provider = "  "
                },
                {
                    provider = function(self)
                        return self.status_dict.head
                    end,
                },
                {
                    condition = function(self)
                        return self.has_changes
                    end,
                    provider = " "
                },
                {
                    provider = function(self)
                        local count = self.status_dict.added or 0
                        return count > 0 and ("+" .. count)
                    end,
                    hl = { fg = colors.git_add },
                },
                {
                    provider = function(self)
                        local count = self.status_dict.removed or 0
                        return count > 0 and ("-" .. count)
                    end,
                    hl = { fg = colors.git_remove },
                },
                {
                    provider = function(self)
                        local count = self.status_dict.changed or 0
                        return count > 0 and ("~" .. count)
                    end,
                    hl = { fg = colors.git_change },
                },
                space
            }

            local file_icon = {
                init = function(self)
                    local file_name = vim.fn.expand('%:t')
                    local extension = vim.fn.fnamemodify(file_name, ":e")

                    self.icon, self.icon_color =
                        require("nvim-web-devicons").get_icon_color(file_name, extension, { default = true })
                end,
                provider = function(self)
                    return self.icon and self.icon .. " "
                end,
                hl = function(self)
                    return { fg = self.icon_color }
                end
            }

            local file_flags = {
                {
                    condition = function()
                        return vim.bo.modified
                    end,
                    provider = " ",
                    hl = { fg = colors.fg },
                },
                {
                    condition = function()
                        return not vim.bo.modifiable or vim.bo.readonly
                    end,
                    provider = "  ",
                    hl = { fg = colors.command },
                },
            }

            local file_preview = {
                {
                    provider = function()
                        local title = vim.fn.expand('%:t')
                        return title ~= '' and title or '[no file]'
                    end,
                },
                file_flags,
                space
            }

            local diagnostics = {
                condition = conditions.has_diagnostics,

                static = {
                    error_icon = '',
                    warn_icon = '',
                    info_icon = '󰋇',
                    hint_icon = '󰌵',
                },

                init = function(self)
                    self.errors = #vim.diagnostic.get(0, { severity = vim.diagnostic.severity.ERROR })
                    self.warnings = #vim.diagnostic.get(0, { severity = vim.diagnostic.severity.WARN })
                    self.hints = #vim.diagnostic.get(0, { severity = vim.diagnostic.severity.HINT })
                    self.info = #vim.diagnostic.get(0, { severity = vim.diagnostic.severity.INFO })
                end,

                update = { "DiagnosticChanged", "BufEnter" },

                {
                    provider = function(self)
                        return self.errors > 0 and (self.error_icon .. " " .. self.errors .. " ")
                    end,
                    hl = { fg = colors.diag_err },
                },
                {
                    provider = function(self)
                        return self.warnings > 0 and (self.warn_icon .. " " .. self.warnings .. " ")
                    end,
                    hl = { fg = colors.diag_warn },
                },
                {
                    provider = function(self)
                        return self.info > 0 and (self.info_icon .. " " .. self.info .. " ")
                    end,
                    hl = { fg = colors.diag_info },
                },
                {
                    provider = function(self)
                        return self.hints > 0 and (self.hint_icon .. " " .. self.hints)
                    end,
                    hl = { fg = colors.diag_hint },
                }
            }

            local position = {
                provider = ' %l:%c '
            }

            local percentage = {
                provider = ' %p%% '
            }

            local file_type = {
                space,
                file_icon,
                {
                    provider = function()
                        return vim.bo.filetype
                    end
                },
                condition = function()
                    return vim.bo.filetype ~= ''
                end,
            }

            require('heirline').setup({
                statusline = {
                    {
                        {
                            mode,
                            hl = function()
                                return { bg = mode_color_map[vim.fn.mode()], fg = colors.bg }
                            end
                        },
                        {
                            git,
                            hl = function()
                                return { fg = mode_color_map[vim.fn.mode()], bg = colors.bg }
                            end
                        },
                        {
                            space,
                            file_preview,
                            diagnostics,
                            hl = { fg = colors.fg }
                        },
                        { provider = "%=" },
                        {
                            file_type,
                            space,
                            hl = { fg = colors.fg }
                        },
                        {
                            percentage,
                            hl = function()
                                return { fg = mode_color_map[vim.fn.mode()], bg = colors.bg }
                            end
                        },
                        {
                            position,
                            hl = function()
                                return { bg = mode_color_map[vim.fn.mode()], fg = colors.bg }
                            end
                        },
                        hl = { bg = colors.bg_secondary }
                    }
                }
            })
        end
    }
}
