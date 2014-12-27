if !has('python')
    echom "Python not installed, exiting"
    finish
endif

let s:plugin_path = escape(expand('<sfile>:p:h'), '\')
execute 'pyfile ' . s:plugin_path . '/vim_gnome_shell.py'

if !exists("g:vim_gnome_shell#uuid")
    let g:vim_gnome_shell#uuid=""
endif

if !exists("g:vim_gnome_shell#name")
    let g:vim_gnome_shell#name=""
endif

if !exists("g:vim_gnome_shell#cwd")
    let g:vim_gnome_shell#cwd=""
endif

if !exists("g:vim_gnome_shell#state")
    let g:vim_gnome_shell#state=0
endif

if !exists("g:vim_gnome_shell#loaded")
    let g:vim_gnome_shell#loaded=1
endif

function! s:GetCWD()
    return system('basename `pwd`')
endfunction

function! s:SetCWD()
    let g:vim_gnome_shell#cwd = s:GetCWD()
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

function! vim_gnome_shell#VGSUpdateState()
    python VGSUpdateState()
endfunction

function! vim_gnome_shell#VGS()
    python initVGS()
    let g:vim_gnome_shell#cwd = s:GetCWD()
    if(g:vim_gnome_shell#loaded)
        call s:SetCWD()
        echo g:vim_gnome_shell#cwd
        echo g:vim_gnome_shell#uuid
        echo g:vim_gnome_shell#name
        echo g:vim_gnome_shell#state
    else
        return
    endif
endfunction
