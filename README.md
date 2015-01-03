# vim-gnome-shell

Vim plugin to interact with GNOME Shell extensions better. It's not perfect, but it does the job for me.

## s:GetCWD()
  
Returns the current working directory.

## s:SetCWD()

Calls s:GetCWD and puts the result in `g:vim_gnome_shell_cwd`.

## vim_gnome_shell#Append(var)

Appends `var` to the current line.

##  vim_gnome_shell#AuCheck()

WIP function to allow on-the-fly extension dir checking

##  vim_gnome_shell#Close()

Close the preview window.

##  vim_gnome_shell#GoTo(name)
    
Jump to the preview window "name".

##  vim_gnome_shell#Insert(var)

Insert `var` at cursor.

##  vim_gnome_shell#IsVisible
    
Return `True` if the preview window is visible.

##  vim_gnome_shell#Open
    
Opens & configures the preview window.
    
##  vim_gnome_shell#Populate
    
Populate the preview window with the vars.  
  
##  vim_gnome_shell#Toggle
    
Open the preview window if closed, close if open.
    
##  vim_gnome_shell#Zip
    
Create a zip file of the directory.
