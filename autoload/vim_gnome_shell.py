#!/usr/bin/env python
import string
import json
import sys
import os

from gi.repository import Gio

class GnomeShell(object):

    def __init__(self):
        self.json = open('/home/elken/.vim/bundle/vim-gnome-shell/autoload/metadata.json')
        self.data = json.load(self.json)
        self.json.close()

        self.uuid = self.data['uuid']
        self.name = self.data['name']
        self.settings = Gio.Settings(schema='org.gnome.shell')
        self.extensions = self.settings.get_strv('enabled-extensions')

    def getUUID(self):
        return self.uuid

    def getName(self):
        return self.name

    def getState(self):
        if self.uuid in self.extensions:
            return 1
        else:
            return 0

    def hasPrefs(self):
        return os.path.exists(os.path.join(os.environ['HOME'],".local/share/gnome-shell/extensions/",self.uuid,"prefs.js"))

    def openPrefs(self):
        if self.hasPrefs():
            os.system("gnome-shell-extension-prefs "+self.uuid+" 2> /dev/null")
        else:
            return 0

    def enableExtension(self):
        if self.getState() == 1:
            print self.uuid + " is already enabled." 
            return

        self.extensions.append(self.uuid)
        self.settings.set_strv('enabled-extensions', self.extensions)
        print self.uuid + " is now enabled." 

    def disableExtension(self):
        if self.getState() == 0:
            print self.uuid + " is not enabled or installed." 
            return

        while self.uuid in self.extensions:
            self.extensions.remove(self.uuid)

        self.settings.set_strv('enabled-extensions', self.extensions)
        print self.uuid + " is now disabled." 

#g = GnomeShell()

#print vim.eval('g:uuid')
#print g.getName()
#state = g.getState()
#print state and "Enabled" or "Disabled"

def initVGS():
    g = GnomeShell()
    vim.command("let g:uuid = '%s'" % g.getUUID())
    vim.command("let g:name = '%s'" % g.getName())
