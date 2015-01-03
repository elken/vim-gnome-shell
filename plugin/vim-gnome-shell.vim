command! -nargs=0 VGSCheck call vim_gnome_shell#AuCheck()
command! -nargs=0 VGSInsertUUID call vim_gnome_shell#Insert(g:vim_gnome_shell_uuid)
command! -nargs=0 VGSInsertName call vim_gnome_shell#Insert(g:vim_gnome_shell_name)
command! -nargs=0 VGSAppendUUID call vim_gnome_shell#Append(g:vim_gnome_shell_uuid)
command! -nargs=0 VGSAppendName call vim_gnome_shell#Append(g:vim_gnome_shell_name)
command! -nargs=0 VGSToggle call vim_gnome_shell#Toggle()
command! -nargs=0 VGSMakeZip call vim_gnome_shell#Zip()

nnoremap <F8> :VGSToggle<CR>
