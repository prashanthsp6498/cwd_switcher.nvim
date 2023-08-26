local popup = require("plenary.popup")

local M = {}
local buf_info = {}

---Returns default window config table
---@return table
M.get_default_window_config = function()
    local height = 2
    local width = 90
    local borderchars = { "─", "│", "─", "│", "╭", "╮", "╯", "╰" }
    local opts = {
        title = "title",
        hightlight = "hightlight hehe",
        line = math.floor(((vim.o.lines - height) / 2) - 1),
        col = math.floor(((vim.o.columns - width) / 2)),
        minwidth = width,
        minheight = height,
        maxheight = 15,
        borderchars = borderchars,
    }

    return opts
end

---Merge the given config with default config table and returns updated config table
---@param config table
---@return table
M.get_config = function(config)
    local default_config = M.get_default_window_config()

    for key, value in pairs(config) do
        default_config[key] = value
    end
    return default_config
end

---Creates floating window and returns table containing window info
---@param title string
---@param opts table
---@return table
M.create_window = function(title, opts)
    -- local window_opts = opts or M.get_default_window_config()
    local window_opts = opts
    window_opts.title = title

    local buf = vim.api.nvim_create_buf(false, false)
    local win_id, win = popup.create(buf, window_opts)

    vim.api.nvim_win_set_option(win_id, "number", true)
    vim.api.nvim_buf_set_keymap(buf, "n", "q", ":q!<CR>", { silent = true })
    vim.api.nvim_buf_set_option(buf, "buftype", "acwrite")
    vim.api.nvim_buf_set_option(buf, "bufhidden", "delete")

    buf_info = {
        buf = buf,
        win_id = win_id,
        win = win,
    }

    return buf_info
end

---Reloads the floating window with given content
---@param content table
M.reload = function(content)
    vim.api.nvim_buf_set_lines(buf_info.buf, 0, -1, false, {})
    vim.api.nvim_buf_set_lines(buf_info.buf, 0, #content, false, content)
end

---Closes the floating window
M.close = function()
    vim.api.nvim_buf_delete(buf_info.buf, { force = true })
end

vim.inspect(M.get_default_window_config())

return M
