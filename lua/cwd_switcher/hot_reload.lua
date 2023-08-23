local reload = require("plenary.reload")
local cwd_switcher = require("cwd_switcher")

local M = {}

M.setup = function()
    -- vim.api.nvim_set_keymap("n", "<leader>r", ":lua require('cwd_switcher.hot_reload').reload()", { silent = true })
    vim.keymap.set("n", "<leader>r", M.reload)
    M.key_map_setup()
end

M.key_map_setup = function()
    -- vim.api.nvim_set_keymap("n", "<leader><leader>s", cwd_switcher.show(), { silent = true })
    -- vim.api.nvim_set_keymap("n", "<leader><leader>a", cwd_switcher.mark_this(), { silent = true })

    vim.keymap.set("n", "<leader><leader>a", require("cwd_switcher").mark_this)
    vim.keymap.set("n", "<leader><leader>s", require("cwd_switcher").show)
end

M.reload = function()
    reload.reload_module("cwd_switcher")
    M.key_map_setup()
    print("Reloaded")
end


return M
