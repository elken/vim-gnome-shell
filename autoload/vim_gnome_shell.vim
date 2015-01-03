" Init {{{
if !has('python') "{{{
    echom "Python not installed, exiting"
    finish
endif
let s:plugin_path = escape(expand('<sfile>:p:h'), '\')
execute 'pyfile ' . s:plugin_path . '/vim_gnome_shell.py'
" }}}
if !exists("g:vim_gnome_shell_uuid") "{{{
    let g:vim_gnome_shell_uuid=""
endif "}}}
if !exists("g:vim_gnome_shell_name") "{{{
    let g:vim_gnome_shell_name=""
endif "}}}
if !exists("g:vim_gnome_shell_cwd") "{{{
    let g:vim_gnome_shell_cwd=""
endif "}}}
if !exists("g:vim_gnome_shell_state") "{{{
    let g:vim_gnome_shell_state=0
endif "}}}
if !exists("g:vim_gnome_shell_loaded") "{{{
    let g:vim_gnome_shell_loaded=1
endif "}}}
if !exists("g:vim_gnome_shell_width") "{{{
    let g:vim_gnome_shell_width = 80
endif "}}}
if !exists("g:vim_gnome_shell_vertical") "{{{
    let g:vim_gnome_shell_vertical = 0
endif "}}}
" }}}

" Util {{{
function! s:GetCWD() "{{{
    return system('basename `pwd`')
endfunction
" }}}
function! s:SetCWD() "{{{
    let g:vim_gnome_shell_cwd = s:GetCWD()
endfunction
" }}}
" }}}

" VGS Main {{{
function! vim_gnome_shell#AuCheck() "{{{
    python VGSIsExtensionDir()
endfunction
" }}}
function! vim_gnome_shell#Enable() "{{{
    python VGSEnable()
    python VGSUpdateState()
endfunction
" }}}
function! vim_gnome_shell#Disable() "{{{
    python VGSDisable()
    python VGSUpdateState()
endfunction
" }}}
function! vim_gnome_shell#Insert(...) "{{{
    python insert(vim.eval("a:000"))
endfunction
" }}}
function! vim_gnome_shell#Append(...) "{{{
    python append(vim.eval("a:000"))
endfunction
" }}}
function! vim_gnome_shell#IsVisible() "{{{
    if bufwinnr(bufnr("__VGS__")) != -1
        return 1
    else
        return 0
    endif
endfunction "}}}
function! vim_gnome_shell#GoTo(name) "{{{
    if bufwinnr(bufnr(a:name)) != -1
        exe bufwinnr(bufnr(a:name)) . "wincmd w"
        return 1
    else
        return 0
    endif
endfunction "}}}
function! vim_gnome_shell#Open() "{{{
    let vgswinnr = bufwinnr('__VGS__')
    if vgswinnr != -1
        if winnr() != vgswinnr
            call s:goto_win(vsgwinnr)
        endif
        return
    endif
    if g:vim_gnome_shell_vertical == 0
        let openpos = 'topleft vertical'
        let width = g:vim_gnome_shell_width
    else
        let openpos = 'leftabove'
        let width = g:vim_gnome_shell_vertical
    endif
    exe 'silent keepalt ' . openpos . width . ' split ' . '__VGS__'
    setlocal filetype=vim_gnome_shell
    setlocal buftype=nofile
    setlocal bufhidden=hide
    setlocal noswapfile
    setlocal nobuflisted
    setlocal nomodifiable
    setlocal nolist
    setlocal nowrap
    setlocal winfixwidth
    setlocal textwidth=0
    setlocal nospell
    setlocal nonumber
    setlocal norelativenumber

    nnoremap <buffer> n :py VGSOpenPrefs()<CR>
    nnoremap <buffer> t :py VGSToggleState()<CR>:call vim_gnome_shell#Populate()<CR>
    nnoremap <buffer> m :call vim_gnome_shell#Zip()<CR>

    call vim_gnome_shell#Populate()
endfunction
" }}}
function! vim_gnome_shell#Populate() "{{{
    python populate()  
endfunction "}}}
function! vim_gnome_shell#Close() "{{{
    if vim_gnome_shell#GoTo('__VGS__')
        quit
    endif
endfunction "}}}
function! vim_gnome_shell#Zip() "{{{
    if confirm('Create zip? (Overwrites existing zip)', "yes\nNo", 2) == 1
        python makeZip()
    endif
endfunction "}}}
function! vim_gnome_shell#Toggle() "{{{
    python initVGS()
    if(g:vim_gnome_shell_loaded == 1)
        python VGSUpdateState()

        call s:SetCWD()
    else
        return
    endif

    if vim_gnome_shell#IsVisible()
        call vim_gnome_shell#Close()
    else
        call vim_gnome_shell#Open()
    endif
endfunction
" }}}
" }}}
