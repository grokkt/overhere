local M = {}

local opts_default = {
    hl_opts = {
        fg = nil,
        bg = "#004a3c",
        bold = false,
        italic = false,
        underline = false,
    },
    win_enter = true,
    buf_enter = true,
    buf_win_enter = true,
    clear_after_ms = 250
}

local function set_defaults(table, defaults)
    setmetatable(table, {__index = function(t, key)
        if type(defaults[key]) == "table" then
            local subtable = {}
            set_defaults(subtable, defaults[key])
            t[key] = subtable
            return subtable
        else
            return defaults[key]
        end
    end})
end

--- @param opts table Table
--     - hl_opts (optional) | Custom highlight options
--         - fg (optional) | Hex color string ex: "#FF0000", default nil
--         - bg (optional) | Hex color string ex: "#FF0000", default "#004a3c"
--         - bold (optional) | boolean; default false
--         - italic (optional) | boolean; default false
--         - underline (optional) | boolean; default false
--     - win_enter (optional) | boolean; enable overhere on 'WinEnter' event; default true
--     - buf_enter (optional) | boolean; enable overhere on 'BufEnter' event; default true
--     - buf_win_enter (optional) | boolean; enable overhere on 'BufWinEnter' event; default true
--     - clear_after_ms (optional) | number; number of milliseconds after overhere hl should be cleared; default 250
--
-- Ex usage:
-- ```lua
-- require('overhere.nvim').setup({
--    hl_opts = { bg = "#FF0000" },
--    buf_enter = false,
--    clear_after_ms = 1000
-- })
-- ```
function M.setup(opts)
    if opts == nil then opts = {} end
    set_defaults(opts, opts_default)

    vim.api.nvim_set_hl(0, 'OverHere', {
        fg = opts.hl_opts.fg,
        bg = opts.hl_opts.bg,
        bold = opts.hl_opts.bold,
        italic = opts.hl_opts.italic,
        underline = opts.hl_opts.underline
    })

    local set_view = function()
        local buf = vim.api.nvim_get_current_buf()
        local cur_line = vim.api.nvim_win_get_cursor(0)[1]
        local total_lines = vim.api.nvim_buf_line_count(buf)

        -- Calculate start and end lines, make sure inside buffer
        local start_line = math.max(cur_line - 2, 1)
        local end_line = math.min(cur_line + 2, total_lines)

        -- highlight the lines
        for line = start_line, end_line do
            vim.api.nvim_buf_add_highlight(buf, -1, 'OverHere', line - 1, 0, -1)
        end

        -- clearing hl after .25s
        vim.defer_fn(function()
            vim.api.nvim_buf_clear_namespace(buf, -1, 0, -1)
        end, opts.clear_after_ms)
    end

    if opts.win_enter then
        vim.api.nvim_create_autocmd('WinEnter', {
            callback = set_view,
            pattern = '*'
        })
    end

    if opts.buf_enter then
        vim.api.nvim_create_autocmd('BufEnter', {
            callback = set_view,
            pattern = '*'
        })
    end

    if opts.buf_win_enter then
        vim.api.nvim_create_autocmd('BufWinEnter', {
            callback = set_view,
            pattern = '*'
        })
    end
end

return M
