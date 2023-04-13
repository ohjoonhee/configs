local Plug = vim.fn['plug#']
vim.call("plug#begin")

-- For Both
Plug('joshdick/onedark.vim')
Plug('wellle/targets.vim')
Plug('kana/vim-textobj-user')
Plug('kana/vim-textobj-entire')
Plug('michaeljsmith/vim-indent-object')
Plug('kana/vim-textobj-line')
Plug('tpope/vim-capslock')
-- Plug('inkarkat/vim-ReplaceWithRegister', {branch= 'stable'})
--Plug('tommcdo/vim-exchange')
Plug('AndrewRadev/sideways.vim')
Plug('lukelbd/vim-toggle')
Plug('chaoren/vim-wordmotion')
Plug('tpope/vim-repeat')
-- Plug 'ojroques/vim-oscyank', {'branch': 'main'}

vim.call("plug#end")

if not vim.g.vscode then
    vim.cmd [[
    colorscheme onedark
    let g:airline_theme='onedark'
    ]]
end

require("packer").startup(function(use)
   use "wbthomason/packer.nvim"

  -- Plugins for Neovim only
   use {
       "psliwka/vim-smoothie",
       cond = function() return not vim.g.vscode end
   }
   use {
       "vim-airline/vim-airline",
       cond = function() return not vim.g.vscode end
   }
   use {
       "sheerun/vim-polyglot",
       cond = function() return not vim.g.vscode end
   }
   use {
       "scrooloose/nerdtree",
       cond = function() return not vim.g.vscode end
   }
   use {
       "ryanoasis/vim-devicons",
       cond = function() return not vim.g.vscode end
   }
   use {
       "williamboman/mason.nvim",
       cond = function() return not vim.g.vscode end
   }

   -- Plugins for Both Neovim and VSCode
   use {
       "phaazon/hop.nvim",
       branch = "v2",
       config = function()
           require("hop").setup({ keys = "asdghklqwertyuiopzxcvbnmfj;" })
       end
   }
   use({
        "kylechui/nvim-surround",
        tag = "*",
        config = function()
            require("nvim-surround").setup()
        end
    })
    use({
      "gbprod/substitute.nvim",
      config = function()
        require("substitute").setup({
          -- your configuration comes here
          -- or leave it empty to use the default settings
          -- refer to the configuration section below
        })
      end
    })
end)


-- hop keybindings
local hop = require("hop")
local directions = require("hop.hint").HintDirection
vim.keymap.set('', 's', function() 
    vim.api.nvim_command('noh')
    hop.hint_char2()
end)
vim.keymap.set('', 'f', function() 
    vim.api.nvim_command('noh')
    hop.hint_char1({ 
        direction = directions.AFTER_CURSOR, 
        current_line_only = true 
    }) 
end)
vim.keymap.set('', 'F', function() 
    vim.api.nvim_command('noh')
    hop.hint_char1({ 
        direction = directions.BEFORE_CURSOR, 
        current_line_only = true 
    }) 
end)
vim.keymap.set("", "t", function() 
    vim.api.nvim_command('noh')
    hop.hint_char1({
        direction = directions.AFTER_CURSOR,
        current_line_only = true,
        hint_offset = -1,
    })
end)
vim.keymap.set("", "T", function() 
    vim.api.nvim_command('noh')
    hop.hint_char1({
        direction = directions.AFTER_CURSOR,
        current_line_only = true,
        hint_offset = 1,
    })
end)
vim.keymap.set("", "K", function() 
    vim.api.nvim_command('noh')
    hop.hint_lines_skip_whitespace() 
end)
vim.api.nvim_command('highlight default HopNextKey  guifg=#00dfff gui=bold ctermfg=198 cterm=bold')

-- Exchange
vim.keymap.set("n", "cx", "<cmd>lua require('substitute.exchange').operator()<cr>", { noremap = true })
vim.keymap.set("x", "x", "<cmd>lua require('substitute.exchange').visual()<cr>", { noremap = true })


local set = vim.opt
if not vim.g.vscode then
    set.showmatch = true
    set.hlsearch = true
    set.tabstop = 4
    set.shiftwidth=4
    set.softtabstop=4
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
    vim.keymap.set('i', 'jk', '<Esc>')
    vim.g.mapleader = ' '
    vim.keymap.set('n', '<Leader>w', '<Cmd>write<CR>')
    vim.keymap.set('n', '<Leader>/', function() vim.cmd("noh") end)
end

set.ignorecase = true
set.smartcase = true
set.wildmode = "longest,list"
set.jumpoptions = set.jumpoptions + "stack"
-- set clipboard=unnamed
-- language en_US

-- Remote clipboard sync settings
-- autocmd TextYankPost * if v:event.operator is 'y' && v:event.regname is '' | OSCYankReg " | endif"
-- set clipboard& clipboard^=unnamed,unnamedplus
-- let g:oscyank_term = 'default'


vim.cmd [[
if !exists('g:vscode')
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
endif
]]



-- Keybindings
vim.keymap.set('n', 'gb', '<Cmd>Toggle<Cr>')
vim.keymap.set('n', 'H', '^')
vim.keymap.set('n', 'L', '$')
vim.keymap.set('x', 'H', '^')
vim.keymap.set('x', 'L', '$')
vim.keymap.set('n', 'gj', 'J')
vim.keymap.set('n', 'g<', '<Cmd>SidewaysLeft<Cr>')
vim.keymap.set('n', 'g>', '<Cmd>SidewaysRight<Cr>')
vim.keymap.set('n', 'gsi', '<Plug>SidewaysArgumentInsertBefore')
vim.keymap.set('n', 'gsa', '<Plug>SidewaysArgumentAppendAfter')
vim.keymap.set('n', 'gsI', '<Plug>SidewaysArgumentInsertFirst')
vim.keymap.set('n', 'gsA', '<Plug>SidewaysArgumentAppendLast')
-- revert vscode jumplist to neovim's
-- vim.keymap.set('n', '<C-o>', '<C-o>')


vim.cmd [[
:command! -bang -nargs=1 -range CycleSubstitute <line1>,<line2>call s:CycleSubstitute("<bang>", <f-args>)
" no back ref supported; makes no sense
function! s:CycleSubstitute(bang, repl_arg) range
    let do_loop = a:bang != "!"
    let sep = a:repl_arg[0]
    let fields = split(a:repl_arg, sep)
    let cleansed_fields = map(copy(fields), 'substitute(v:val, "\\\\[<>]", "", "g")')
    " build the action to execute
    let action = '\=s:DoCycleSubst('.do_loop.',' . string(cleansed_fields) . ', "^".submatch(0)."$")'
    " prepare the :substitute command
    let args = [join(fields, '\|'), action ]
    let cmd = a:firstline . ',' . a:lastline . 's'
          \. sep . join(fields, '\|')
          \. sep . action
          \. sep . 'g'
    " echom cmd
    " and run it
    exe cmd
endfunction

function! s:DoCycleSubst(do_loop, fields, what)
    let idx = (match(a:fields, a:what) + 1) % len(a:fields)
    return a:fields[idx]
endfunction
]]



-- TODO there is a more contemporary version of this file
-- TODO Also some of it is redundant
-- VSCode
if vim.g.vscode then
    vim.cmd [[
        function! s:split(...) abort
            let direction = a:1
            let file = a:2
            call VSCodeCall(direction == 'h' ? 'workbench.action.splitEditorDown' : 'workbench.action.splitEditorRight')
            if file != ''
                call VSCodeExtensionNotify('open-file', expand(file), 'all')
            endif
        endfunction

        function! s:splitNew(...)
            let file = a:2
            call s:split(a:1, file == '' ? '__vscode_new__' : file)
        endfunction

        function! s:closeOtherEditors()
            call VSCodeNotify('workbench.action.closeEditorsInOtherGroups')
            call VSCodeNotify('workbench.action.closeOtherEditors')
        endfunction

        function! s:manageEditorSize(...)
            let count = a:1
            let to = a:2
            for i in range(1, count ? count : 1)
                call VSCodeNotify(to == 'increase' ? 'workbench.action.increaseViewSize' : 'workbench.action.decreaseViewSize')
            endfor
        endfunction

        function! s:vscodeCommentary(...) abort
            if !a:0
                let &operatorfunc = matchstr(expand('<sfile>'), '[^. ]*$')
                return 'g@'
            elseif a:0 > 1
                let [line1, line2] = [a:1, a:2]
            else
                let [line1, line2] = [line("'["), line("']")]
            endif

            call VSCodeCallRange("editor.action.commentLine", line1, line2, 0)
        endfunction

        function! s:openVSCodeCommandsInVisualMode()
            normal! gv
            let visualmode = visualmode()
            if visualmode == "V"
                let startLine = line("v")
                let endLine = line(".")
                call VSCodeNotifyRange("workbench.action.showCommands", startLine, endLine, 1)
            else
                let startPos = getpos("v")
                let endPos = getpos(".")
                call VSCodeNotifyRangePos("workbench.action.showCommands", startPos[1], endPos[1], startPos[2], endPos[2], 1)
            endif
        endfunction

        function! s:openWhichKeyInVisualMode()
            normal! gv
            let visualmode = visualmode()
            if visualmode == "V"
                let startLine = line("v")
                let endLine = line(".")
                call VSCodeNotifyRange("whichkey.show", startLine, endLine, 1)
            else
                let startPos = getpos("v")
                let endPos = getpos(".")
                call VSCodeNotifyRangePos("whichkey.show", startPos[1], endPos[1], startPos[2], endPos[2], 1)
            endif
        endfunction



        command! -complete=file -nargs=? Split call <SID>split('h', <q-args>)
        command! -complete=file -nargs=? Vsplit call <SID>split('v', <q-args>)
        command! -complete=file -nargs=? New call <SID>split('h', '__vscode_new__')
        command! -complete=file -nargs=? Vnew call <SID>split('v', '__vscode_new__')
        command! -bang Only if <q-bang> == '!' | call <SID>closeOtherEditors() | else | call VSCodeNotify('workbench.action.joinAllGroups') | endif

        


        nnoremap <silent> <C-w>_ :<C-u>call VSCodeNotify('workbench.action.toggleEditorWidths')<CR>

        " nnoremap <silent> <Space> :call VSCodeNotify('whichkey.show')<CR>
        xnoremap <silent> <Space> :<C-u>call <SID>openWhichKeyInVisualMode()<CR>

        xnoremap <silent> <C-P> :<C-u>call <SID>openVSCodeCommandsInVisualMode()<CR>


        xmap gc  <Plug>VSCodeCommentary
        nmap gc  <Plug>VSCodeCommentary
        omap gc  <Plug>VSCodeCommentary
        nmap gcc <Plug>VSCodeCommentaryLine
    ]]


    -- Better Navigation
    vim.keymap.set("n", "gr", function() vim.fn.VSCodeNotify('editor.action.goToReferences') end)
    vim.keymap.set("n", "<Esc>", function() vim.fn.VSCodeNotify('notebook.cell.quitEdit') end)

end


