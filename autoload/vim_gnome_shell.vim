if !has('python')
    echom "Python not installed, exiting"
    finish
endif

let s:plugin_path = escape(expand('<sfile>:p:h'), '\')
execute 'pyfile ' . s:plugin_path . '/vim_gnome_shell.py'

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

function! s:GetCWD()
    return system('basename `pwd`')
endfunction

function! s:SetCWD()
    let g:vim_gnome_shell_cwd = s:GetCWD()
endfunction

function! vim_gnome_shell#VGSAuCheck()
    python VGSIsExtensionDir()
endfunction

function! vim_gnome_shell#VGSEnable()
    python VGSEnable()
    python VGSUpdateState()
endfunction

function! vim_gnome_shell#VGSDisable()
    python VGSDisable()
    python VGSUpdateState()
endfunction

function! vim_gnome_shell#VGSInsert(...)
    python insert(vim.eval("a:000"))
endfunction

function! vim_gnome_shell#VGSAppend(...)
    python append(vim.eval("a:000"))
endfunction

function! vim_gnome_shell#VGS()
    if(g:vim_gnome_shell_loaded)
        python initVGS()
        python VGSUpdateState()
        let g:vim_gnome_shell_cwd = s:GetCWD()
        call s:SetCWD()
        echo "CWD:" g:vim_gnome_shell_cwd
        echo "UUID:" g:vim_gnome_shell_uuid
        echo "Name:" g:vim_gnome_shell_name
        echo "State:" g:vim_gnome_shell_state
    else
        return
    endif
endfunction
