local popup = require("plenary.popup")

local M = {}

M.get_default_window_config = function ()
    local height = 30
    local width = 90
    local borderchars = { "─", "│", "─", "│", "╭", "╮", "╯", "╰" }
    local opts = {
        title = "title",
        hightlight = "hightlight hehe",
        line = math.floor(((vim.o.lines - height ) / 2) - 1),
        col = math.floor(((vim.o.columns -  width) / 2)),
        minwidth = width,
        minheight = height,
        borderchars = borderchars,
    }

    return opts
end

M.create_window = function (title, opts)
    local window_opts = opts or M.get_default_window_config()
    window_opts.title = title

    local buf = vim.api.nvim_create_buf(false, false)
    local win_id, win = popup.create(buf, window_opts)

    vim.api.nvim_win_set_option(win_id, "number", true)
    vim.api.nvim_buf_set_keymap(buf, "n", "q", ":q!<CR>", { silent = true })
    vim.api.nvim_buf_set_option(buf, "buftype", "acwrite")
    vim.api.nvim_buf_set_option(buf, "bufhidden", "delete")

    return {
        buf = buf,
        win_id = win_id,
        win = win
    }
end

vim.inspect(M.get_default_window_config())

return M
