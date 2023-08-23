local M = {}
local marked_path = {}

local P = function(msg_str)
    print(vim.inspect(msg_str))
end

M.print = function()
    P(marked_path)
end

M._dir_path = vim.fn.stdpath("data") .. "/cwd_switcher"
M._data_path = M._dir_path .. "/data.json"

M._setup = function()
    if vim.fn.isdirectory(M._dir_path) == 0 then
        vim.fn.mkdir(M._dir_path, "p")
    end

    if vim.fn.filereadable(M._data_path) == 0 then
        P("No data file exist")
        return
    end

    local file = assert(io.open(M._data_path, "r"))
    local marked_path_json_data = file:read("*all")
    marked_path = vim.fn.json_decode(marked_path_json_data)
end

M._save = function()
    local encoded_data = vim.fn.json_encode(marked_path)
    local file = assert(io.open(M._data_path, "w"))
    file:write(encoded_data)
    file:close()
end

M.mark_this = function()
    local input = vim.fn.input("Mark this...? ", vim.fn.getcwd() .. "/", "file")
    marked_path[#marked_path + 1] = input
    M._save()
end

M.delete_this = function()
    local index = vim.fn.line(".")
    table.remove(marked_path, index)
    M._save()
    M._reload_ui()
end

M._reload_ui = function()
    vim.api.nvim_buf_set_lines(M._win_info.buf, 0, -1, false, {})
    vim.api.nvim_buf_set_lines(M._win_info.buf, 0, #marked_path, false, marked_path)
end

M.show = function()
    M._setup()

    local ui = require("cwd_switcher.ui")

    local win_info = ui.create_window("cwd_switcher")
    M._win_info = win_info

    vim.api.nvim_buf_set_lines(win_info.buf, 0, #marked_path, false, marked_path)
    vim.api.nvim_buf_set_keymap(
        win_info.buf,
        "n",
        "d",
        "<Cmd>lua require('cwd_switcher').delete_this()<CR>",
        { silent = true }
    )
end

M._setup()

return M
