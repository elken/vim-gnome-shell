let b:current_syntax = "vim_gnome_shell"

syntax match vgsKeyword "^Name" 
syntax match vgsKeyword "^UUID"  
syntax match vgsKeyword "^Description"
syntax match vgsKeyword "^State"

syntax match vgsComment "\v\".*$"
highlight link vgsKeyword Keyword
highlight link vgsComment Comment
