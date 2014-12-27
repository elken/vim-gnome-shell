" Python check {{{
if !has('python')
    echom "Python not installed, exiting"
    finish
endif
" }}}
" Init {{{
let s:plugin_path = escape(expand('<sfile>:p:h'), '\')
execute 'pyfile ' . s:plugin_path . '/vim_gnome_shell.py'
" }}}
" Variables {{{
if !exists("g:vim_gnome_shell_uuid")
    let g:vim_gnome_shell_uuid=""
endif

if !exists("g:vim_gnome_shell_name")
    let g:vim_gnome_shell_name=""
endif

if !exists("g:vim_gnome_shell_cwd")
    let g:vim_gnome_shell_cwd=""
endif

if !exists("g:vim_gnome_shell_state")
    let g:vim_gnome_shell_state=0
endif

if !exists("g:vim_gnome_shell_loaded")
    let g:vim_gnome_shell_loaded=1
endif

if !exists("g:vim_gnome_shell_width")
    let g:vim_gnome_shell_width = 80
endif

if !exists("g:vim_gnome_shell_vertical")
    let g:vim_gnome_shell_vertical = 0
endif
" }}}
" s:GetCWD() {{{
function! s:GetCWD()
    return system('basename `pwd`')
endfunction
" }}}
" s:SetCWD() {{{
function! s:SetCWD()
    let g:vim_gnome_shell_cwd = s:GetCWD()
endfunction
" }}}
" vim_gnome_shell#AuCheck() {{{
function! vim_gnome_shell#AuCheck()
    python VGSIsExtensionDir()
endfunction
" }}}
" vim_gnome_shell#Enable {{{
function! vim_gnome_shell#Enable()
    python VGSEnable()
    python VGSUpdateState()
endfunction
" }}}
" vim_gnome_shell#Disable {{{
function! vim_gnome_shell#Disable()
    python VGSDisable()
    python VGSUpdateState()
endfunction
" }}}
" vim_gnome_shell#Insert {{{
function! vim_gnome_shell#Insert(...)
    python insert(vim.eval("a:000"))
endfunction
" }}}
" vim_gnome_shell#Append {{{
function! vim_gnome_shell#Append(...)
    python append(vim.eval("a:000"))
endfunction
" }}}
" vim_gnome_shell#Show {{{
function! vim_gnome_shell#Show ()
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
    setlocal noreadonly
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
endfunction
" }}}
" vim_gnome_shell#Init() {{{
function! vim_gnome_shell#Init()
    python initVGS()
    if(g:vim_gnome_shell_loaded == 1)
        python VGSUpdateState()

        call s:SetCWD()
        echo "CWD:" g:vim_gnome_shell_cwd
        echo "UUID:" g:vim_gnome_shell_uuid
        echo "Name:" g:vim_gnome_shell_name
        echo "State:" g:vim_gnome_shell_state ? 'Enabled' : 'Disabled'
    else
        return
    endif
endfunction
" }}}
