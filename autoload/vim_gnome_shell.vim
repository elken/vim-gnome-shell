if !has('python')
    echom "Python not installed, exiting"
    finish
endif

let s:plugin_path = escape(expand('<sfile>:p:h'), '\')

if !exists("g:uuid")
    let g:uuid=""
endif

if !exists("g:name")
    let g:name=""
endif

function! GetCWD()
    return system('basename `pwd`')
endfunction

function! s:VGSInit()
    execute 'pyfile ' . s:plugin_path . '/vim_gnome_shell.py'
    python initVGS()
endfunction

function! s:OutputAll()
    call s:VGSInit()
    echo GetCWD()
    echo g:uuid
    echo g:name
endfunction

function! vim_gnome_shell#VGS()
    call s:OutputAll()
endfunction
