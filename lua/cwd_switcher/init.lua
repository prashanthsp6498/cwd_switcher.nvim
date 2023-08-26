local M = {}
local marked_path = {}

M.ui = {}

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

---Mark the current directory from where calling this
M.mark_this = function()
    local input = vim.fn.input("Mark this...? ", vim.fn.getcwd() .. "/", "file")
    if input == "" then
        return
    end
    marked_path[#marked_path + 1] = input
    M._save()
end

M._change_to_this = function()
    local path_idx = vim.fn.line(".")

    M.ui.close()

    local buf_util = require("cwd_switcher.buf_util")
    local is_close_success = buf_util.close_open_buffers()

    if is_close_success then
        local success, err = pcall(function()
            local target_dir = vim.fn.fnameescape(tostring(marked_path[path_idx]))
            vim.api.nvim_set_current_dir(tostring(target_dir))

            print("pwd changed to : " .. marked_path[path_idx])

            buf_util.create_empty_buf()
        end)

        if not success then
            print("Error: ", err)
        end
    end
end

M.delete_this = function()
    local index = vim.fn.line(".")
    table.remove(marked_path, index)
    M._save()
    M._reload_ui()
end

M._reload_ui = function()
    M.ui.reload(marked_path)
end

---Shows marked directory in floating window
M.show = function()
    M._setup()

    M._caller_buf = vim.api.nvim_get_current_buf()
    M.ui = require("cwd_switcher.ui")

    local win_config = M.ui.get_config({title = "cwd_switcher", minheight = #marked_path + 1 })
    local win_info = M.ui.create_window("cwd_switcher", win_config)
    M._win_info = win_info

    vim.api.nvim_buf_set_lines(win_info.buf, 0, #marked_path, false, marked_path)
    vim.api.nvim_buf_set_keymap(
        win_info.buf,
        "n",
        "d",
        "<Cmd>lua require('cwd_switcher').delete_this()<CR>",
        { silent = true }
    )

    vim.api.nvim_buf_set_keymap(
        win_info.buf,
        "n",
        "<CR>",
        "<Cmd> lua require('cwd_switcher')._change_to_this()<CR>",
        { silent = true }
    )
end

M._setup()

return M
