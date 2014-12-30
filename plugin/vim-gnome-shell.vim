command! -nargs=0 VGS call vim_gnome_shell#Init()
command! -nargs=0 VGSEnable call vim_gnome_shell#Enable()
command! -nargs=0 VGSDisable call vim_gnome_shell#Disable()
command! -nargs=0 VGSCheck call vim_gnome_shell#AuCheck()
command! -nargs=0 VGSInsertUUID call vim_gnome_shell#Insert(g:vim_gnome_shell_uuid)
command! -nargs=0 VGSInsertName call vim_gnome_shell#Insert(g:vim_gnome_shell_name)
command! -nargs=0 VGSAppendUUID call vim_gnome_shell#Append(g:vim_gnome_shell_uuid)
command! -nargs=0 VGSAppendName call vim_gnome_shell#Append(g:vim_gnome_shell_name)
command! -nargs=0 VGSToggle call vim_gnome_shell#Toggle()

nnoremap <F8> :VGS<CR>:VGSToggle<CR>
