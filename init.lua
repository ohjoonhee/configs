local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
    vim.fn.system(
        {
            "git",
            "clone",
            "--filter=blob:none",
            "https://github.com/folke/lazy.nvim.git",
            "--branch=stable", -- latest stable release
            lazypath
        }
    )
end
vim.opt.rtp:prepend(lazypath)

require("lazy").setup({
        "joshdick/onedark.vim",
        "wellle/targets.vim",
        "kana/vim-textobj-user",
        {
            "kana/vim-textobj-entire",
            dependencies = {
                "kana/vim-textobj-user"
            }
        },
        {
            "kana/vim-textobj-line",
            dependencies = {
                "kana/vim-textobj-user"
            }
        },
        "michaeljsmith/vim-indent-object",
        "AndrewRadev/sideways.vim",
        "lukelbd/vim-toggle",
        "chaoren/vim-wordmotion",
        "tpope/vim-repeat",
        {
          "gbprod/yanky.nvim",
          dependencies = {
            { "kkharji/sqlite.lua" }
          },
          opts = {
            ring = { storage = "sqlite" },
            highlight = {
                on_put = false,
                on_yank = false,
            },
          },
          keys = {
            -- { "<leader>p", function() require("telescope").extensions.yank_history.yank_history({ }) end, desc = "Open Yank History" },
            { "y", "<Plug>(YankyYank)", mode = { "n", "x" }, desc = "Yank text" },
            { "p", "<Plug>(YankyPutAfter)", mode = "n", desc = "Put yanked text after cursor" },
            { "P", "<Plug>(YankyPutBefore)", mode = "n", desc = "Put yanked text before cursor" },
            { "P", "<Plug>(YankyPutAfter)", mode = "x", desc = "Put yanked text after cursor" }, -- change behavior of 'p' and 'P' in visual mode
            { "p", "<Plug>(YankyPutBefore)", mode = "x", desc = "Put yanked text before cursor" }, -- whether to yank the pasted text
            { "gp", "<Plug>(YankyGPutAfter)", mode = { "n", "x" }, desc = "Put yanked text after selection" },
            { "gP", "<Plug>(YankyGPutBefore)", mode = { "n", "x" }, desc = "Put yanked text before selection" },
            { "<c-p>", "<Plug>(YankyPreviousEntry)", desc = "Select previous entry through yank history" },
            { "<c-n>", "<Plug>(YankyNextEntry)", desc = "Select next entry through yank history" },
            { "ap", function() require("yanky.textobj").last_put() end, mode = { "o", "x" }, desc = "Last put text object" },
          },
        },
        {"psliwka/vim-smoothie", cond = not vim.g.vscode},
        {"vim-airline/vim-airline", cond = not vim.g.vscode},
        {
            "folke/flash.nvim",
            event = "VeryLazy",
            ---@type Flash.Config
            opts = {},
            -- stylua: ignore
            keys = {
                {"s", mode = {"n", "x", "o"}, function() require("flash").jump() end, desc = "Flash"},
                {"r", mode = "o", function() require("flash").remote() end, desc = "Remote Flash"},
                {"<c-s>", mode = {"c"}, function() require("flash").toggle() end, desc = "Toggle Flash Search"}
            },
            config = function()
                require("flash").setup(
                    {
                        labels = "asdghklqwertyuiopzxcvbnmfj;",
                        modes = {
                            char = {
                              jump_labels = true
                            }
                          }
                    }
                )
            end
        },
        {
            "kylechui/nvim-surround",
            version = "*",
            config = function()
                require("nvim-surround").setup(
                    {
                        surrounds = {
                            ["("] = false,
                            ["["] = false,
                            ["{"] = false,
                            ["<"] = false
                        },
                        aliases = {
                            ["("] = ")",
                            ["["] = "]",
                            ["{"] = "}",
                            ["<"] = ">"
                        }
                    }
                )
            end
        },
        {
            "gbprod/substitute.nvim",
            config = function()
                require("substitute").setup({
                    on_substitute = require("yanky.integration").substitute(),
                })
            end,
            keys = {
                {"cx", mode = "n", "<cmd>lua require('substitute.exchange').operator()<cr>"},
                {"x", mode = "x", "<cmd>lua require('substitute.exchange').visual()<cr>"},
                -- {"gr", mode = "n", function() require("substitute").operator() end},
                -- {"gr", mode = "x", function() require("substitute").visual() end},
            }
        },
        {
            "vscode-neovim/vscode-multi-cursor.nvim",
            event = "VeryLazy",
            cond = not (not vim.g.vscode),
            config = function()
                require("vscode-multi-cursor").setup {
                    -- Whether to set default mappings
                    default_mappings = true,
                    -- If set to true, only multiple cursors will be created without multiple selections
                    no_selection = true,
                    -- move to keys section
                    vim.keymap.set("n", "<C-f>", "mcigw*<Cmd>nohl<CR>", {remap = true})
                }
            end,
            keys = {
                {"<C-L>", mode = "n", function() require("vscode-multi-cursor").selectHighlights() end},
            }
        }
})

if not vim.g.vscode then
    vim.cmd [[
    colorscheme onedark
    let g:airline_theme='onedark'
    ]]
end

-- vim.api.nvim_command('highlight default HopNextKey  guifg=#00dfff gui=bold ctermfg=198 cterm=bold')

local set = vim.opt
if not vim.g.vscode then
    set.showmatch = true
    set.hlsearch = true
    set.tabstop = 4
    set.shiftwidth = 4
    set.softtabstop = 4
    set.autoindent = true
    set.smartindent = true
    set.expandtab = true
    set.number = true
    vim.cmd([[filetype plugin indent on]])
    set.ruler = false
    set.showmode = false
    set.laststatus = 2
    set.syntax = "enable"

    -- Cursor config
    vim.cmd [[
    let &t_SI = "\<Esc>]50;CursorShape=5\x7"
    let &t_SR = "\<Esc>]50;CursorShape=4\x7"
    let &t_EI = "\<Esc>]50;CursorShape=0\x7"
    ]]

    -- Keybindings
    vim.keymap.set("i", "jk", "<Esc>")
    vim.g.mapleader = " "
    vim.keymap.set("n", "<Leader>w", "<Cmd>write<CR>")
    vim.keymap.set("n", "<Leader>/", function() vim.cmd("noh") end)
end

set.ignorecase = true
set.smartcase = true
set.wildmode = "longest,list"
set.jumpoptions = set.jumpoptions + "stack"
set.clipboard = "unnamedplus"
-- language en_US

if not vim.g.vscode then
    vim.cmd [[
    if (empty($TMUX))
      if (has("nvim"))
        "For Neovim 0.1.3 and 0.1.4 < https://github.com/neovim/neovim/pull/2198 >
        let $NVIM_TUI_ENABLE_TRUE_COLOR=1
      endif
      "For Neovim > 0.1.5 and Vim > patch 7.4.1799 < https://github.com/vim/vim/commit/61be73bb0f965a895bfb064ea3e55476ac175162 >
      "Based on Vim patch 7.4.1770 (`guicolors` option) < https://github.com/vim/vim/commit/8a633e3427b47286869aa4b96f2bfc1fe65b25cd >
      " < https://github.com/neovim/neovim/wiki/Following-HEAD#20160511 >
      if (has("termguicolors"))
        set termguicolors
      endif
    endif
    ]]
end

-- Keybindings
vim.keymap.set("n", "gb", "<Cmd>Toggle<Cr>")
vim.keymap.set("n", "H", "^")
vim.keymap.set("n", "L", "$")
vim.keymap.set("x", "H", "^")
vim.keymap.set("x", "L", "$")
vim.keymap.set("n", "gj", "J")
vim.keymap.set("n", "g<", "<Cmd>SidewaysLeft<Cr>")
vim.keymap.set("n", "g>", "<Cmd>SidewaysRight<Cr>")
vim.keymap.set("n", "gsi", "<Plug>SidewaysArgumentInsertBefore")
vim.keymap.set("n", "gsa", "<Plug>SidewaysArgumentAppendAfter")
vim.keymap.set("n", "gsI", "<Plug>SidewaysArgumentInsertFirst")
vim.keymap.set("n", "gsA", "<Plug>SidewaysArgumentAppendLast")
vim.keymap.set({"x", "o"}, "igw", "iW")
vim.keymap.set({"x", "o"}, "agw", "aW")
vim.keymap.set({"x", "o"}, "iW", "iw")
vim.keymap.set({"x", "o"}, "aW", "aw")
-- revert vscode jumplist to neovim's
-- vim.keymap.set('n', '<C-o>', '<C-o>')

if vim.g.vscode then
    vim.keymap.set("n", "gr", function() require("vscode-neovim").call("editor.action.goToReferences") end)
end
