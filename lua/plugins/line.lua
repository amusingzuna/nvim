---@diagnostic disable: missing-fields

return {
    {
        'rebelot/heirline.nvim',
        config = function()
            local conditions = require('heirline.conditions')
            local theme_colors = require('kanagawa.colors').setup({ theme = 'dragon' })

            local colors = {
                bg = theme_colors.theme.ui.bg_gutter,
                bg_secondary = theme_colors.palette.sumiInk1,
                fg = theme_colors.palette.oldWhite,
                git_add = theme_colors.theme.vcs.added,
                git_change = theme_colors.theme.vcs.changed,
                git_remove = theme_colors.theme.vcs.removed,
                normal = theme_colors.palette.springViolet2,
                visual = theme_colors.palette.oniViolet,
                insert = theme_colors.palette.autumnGreen,
                replace = theme_colors.palette.autumnRed,
                command = theme_colors.palette.autumnYellow,
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

                    self.has_changes = self.status_dict.added ~= 0 or self.status_dict.removed ~= 0 or
                        self.status_dict.changed ~= 0
                end,
                {
                    provider = "  "
                },
                {
                    provider = function(self)
                        return self.status_dict.head
                    end,
                },
                {
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
                {
                    provider = " "
                }
            }

            vim.api.nvim_set_hl(0, 'StatusLine', { bg = colors.bg_secondary, fg = colors.fg })

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
                        }
                    },
                    fallthrough = false,
                }
            })
        end
    }
}
