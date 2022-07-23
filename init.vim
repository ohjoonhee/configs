call plug#begin('~/.vim/plugged')

"For Neovim
if !exists('g:vscode')
    Plug 'psliwka/vim-smoothie'
    Plug 'vim-airline/vim-airline'
    Plug 'sheerun/vim-polyglot'
    Plug 'scrooloose/nerdtree'
    Plug 'ryanoasis/vim-devicons'
    Plug 'neoclide/coc.nvim', {'branch': 'release'}
endif

"For Both
Plug 'joshdick/onedark.vim'
Plug 'wellle/targets.vim'
Plug 'kana/vim-textobj-user'
Plug 'kana/vim-textobj-entire'
Plug 'michaeljsmith/vim-indent-object'
Plug 'machakann/vim-sandwich'
Plug 'kana/vim-textobj-line'
Plug 'tpope/vim-capslock'
Plug 'inkarkat/vim-ReplaceWithRegister', {'branch': 'stable'}
Plug 'tommcdo/vim-exchange'
Plug 'AndrewRadev/sideways.vim'
Plug 'unblevable/quick-scope'

"For Vscode
Plug 'asvetliakov/vim-easymotion'

call plug#end()

runtime macros/sandwich/keymap/surround.vim


if !exists('g:vscode')
    set showmatch
    set hlsearch
    set tabstop=4
    set shiftwidth=4
    set softtabstop=4
    set autoindent
    set smartindent
    set expandtab
    set number
    set noruler
    filetype plugin indent on
    set noshowmode
    set laststatus=2
    syntax on
endif

set ignorecase
set smartcase
set wildmode=longest,list
set clipboard=unnamed
set jumpoptions+=stack
language en_US

if !exists('g:vscode')
    let &t_SI = "\<Esc>]50;CursorShape=5\x7"
    let &t_SR = "\<Esc>]50;CursorShape=4\x7"
    let &t_EI = "\<Esc>]50;CursorShape=0\x7"
endif

map <Space> <leader>
nnoremap <leader>w :w<CR>

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

colorscheme onedark
let g:airline_theme='onedark'

let g:sandwich#recipes = deepcopy(g:sandwich#default_recipes)
let g:sandwich#recipes += [{'external': ['i<', 'a<']}]

if !exists('g:vscode')
    " Start NERDTree. If a file is specified, move the cursor to its window.
    autocmd StdinReadPre * let s:std_in=1
    autocmd VimEnter * NERDTree | if argc() > 0 || exists("s:std_in") | wincmd p | endif

    " Exit Vim if NERDTree is the only window left.
    autocmd BufEnter * if tabpagenr('$') == 1 && winnr('$') == 1 && exists('b:NERDTree') && b:NERDTree.isTabTree() |
        \ quit | endif
endif

" Keybindings
inoremap jj <Esc>
noremap H ^
noremap L $
nnoremap J }
nnoremap K {
vnoremap J }
vnoremap K {
nnoremap gj J
nnoremap g< :SidewaysLeft<cr>
nnoremap g> :SidewaysRight<cr>
nmap gsi <Plug>SidewaysArgumentInsertBefore
nmap gsa <Plug>SidewaysArgumentAppendAfter
nmap gsI <Plug>SidewaysArgumentInsertFirst
nmap gsA <Plug>SidewaysArgumentAppendLast

" QuickScope
" Trigger a highlight in the appropriate direction when pressing these keys:
let g:qs_highlight_on_keys = ['f', 'F', 't', 'T']
" Trigger a highlight only when pressing f and F.
" let g:qs_highlight_on_keys = ['f', 'F']
" Vscode settings
highlight QuickScopePrimary guifg='#afff5f' gui=underline ctermfg=155 cterm=underline
highlight QuickScopeSecondary guifg='#5fffff' gui=underline ctermfg=81 cterm=underline

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



" TODO there is a more contemporary version of this file
" TODO Also some of it is redundant
"VSCode
if exists('g:vscode')
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

    " Better Navigation
    nnoremap gr <Cmd>call VSCodeNotify('editor.action.goToReferences')<CR>
    nmap <Esc> <Cmd>call VSCodeNotify('notebook.cell.quitEdit')<CR>

    " Bind C-/ to vscode commentary since calling from vscode produces double comments due to multiple cursors
    xnoremap <expr> <C-/> <SID>vscodeCommentary()
    nnoremap <expr> <C-/> <SID>vscodeCommentary() . '_'

    nnoremap <silent> <C-w>_ :<C-u>call VSCodeNotify('workbench.action.toggleEditorWidths')<CR>

    nnoremap <silent> <Space> :call VSCodeNotify('whichkey.show')<CR>
    xnoremap <silent> <Space> :<C-u>call <SID>openWhichKeyInVisualMode()<CR>

    xnoremap <silent> <C-P> :<C-u>call <SID>openVSCodeCommandsInVisualMode()<CR>

    xmap gc  <Plug>VSCodeCommentary
    nmap gc  <Plug>VSCodeCommentary
    omap gc  <Plug>VSCodeCommentary
    nmap gcc <Plug>VSCodeCommentaryLine

    " Simulate same TAB behavior in VSCode
    nmap <Tab> :Tabnext<CR>
    nmap <S-Tab> :Tabprev<CR>

    let g:EasyMotion_smartcase = 1
    nmap s <Plug>(easymotion-s2)
    xmap s <Plug>(easymotion-s2)
    nmap \\s <Plug>(easymotion-s)
    xmap \\s <Plug>(easymotion-s)

endif
