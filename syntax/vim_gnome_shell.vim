let b:current_syntax = "vim_gnome_shell"

" vgsKeyword {{{
syntax match vgsKeyword "^Name" 
syntax match vgsKeyword "^UUID"  
syntax match vgsKeyword "^Description"
syntax match vgsKeyword "^State"
syntax match vgsKeyword "^URL"
"}}}
" vgsComment {{{
syntax match vgsComment "\v\".*$"
"}}}
" highlight {{{
highlight link vgsKeyword Keyword
highlight link vgsComment Comment
" }}}
