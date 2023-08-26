local M = {}

--- @return boolean
M.close_open_buffers = function()
    for _, bufnr in ipairs(vim.api.nvim_list_bufs()) do

        if vim.api.nvim_buf_get_option(bufnr, "modified") then
            local choice = vim.fn.confirm("This buffer has unsaved changes. close anyway?", "&Yes\n&No", 2)
            if choice == 2 then
                return false
            else
                local buf_name = vim.api.nvim_buf_get_name(bufnr)
                print("Closing " .. buf_name)
                vim.api.nvim_buf_delete(bufnr, { force = true })
            end
        else
            vim.api.nvim_buf_delete(bufnr, { force = true })
        end
    end

    return true
end

M.create_empty_buf = function()
    local empty_buf = vim.api.nvim_create_buf(true, true)
    vim.api.nvim_set_current_buf(empty_buf)
end

return M
